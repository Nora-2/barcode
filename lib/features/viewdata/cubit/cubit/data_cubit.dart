// ignore_for_file: use_build_context_synchronously, unnecessary_cast, avoid_print, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_excel/excel.dart';
import 'dart:async';
import 'package:parcode/core/widgets/AwesomeDiaglog.dart';
import 'package:universal_html/html.dart' as html;
part 'data_state.dart';

class DataCubit extends Cubit<DataState> {
  DataCubit() : super(DataInitial()) {
    _initStream();
  }

  static DataCubit get(BuildContext context) => BlocProvider.of(context);

  final StreamController<List<Map<String, dynamic>>> _qrcodesController =
      StreamController<List<Map<String, dynamic>>>.broadcast();
  Stream<List<Map<String, dynamic>>> get qrcodesStream =>
      _qrcodesController.stream;

  void _initStream() {
    FirebaseFirestore.instance
        .collection('qrcodes')
        .orderBy('id')
        .snapshots()
        .listen((snapshot) {
      final qrcodes = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      _qrcodesController.add(qrcodes);
    }, onError: (error) {
      
      print("Error fetching QR codes stream: $error");
      _qrcodesController.addError(error);
    });
  }

Future<void> deleteselectedData(List<int> docIds, BuildContext context) async {
  try {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    
    for (int docId in docIds) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('qrcodes')
          .where('id', isEqualTo: docId)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
    }

    await batch.commit();
    await rearrangeAndSetCurrentId();

    emit(DataDeletedSuccessfully());
    customAwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: 'Success',
      description:'All Barcodes deleted successfully! \n تم حذف الباركود كل بنجاح',
      buttonColor: const Color(0xff00CA71),
    ).show();
  } catch (e) {
    emit(DataDeletionError());
    customAwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      title: 'Error',
      description: 'Error deleting the selected Barcodes',
      buttonColor: const Color(0xffD93E47),
    ).show();

    print('Error in deleteData: $e');
  }
}

  Future<void> deleteData(int docId, BuildContext context) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('qrcodes')
          .where('id', isEqualTo: docId)
          .get();

      WriteBatch batch = FirebaseFirestore.instance.batch();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      await rearrangeAndSetCurrentId();

      emit(DataDeletedSuccessfully());
      customAwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: 'Success',
        description: 'The Barcode deleted successfully! \n تم حذف هذا الباركود بنجاح',
        buttonColor: const Color(0xff00CA71),
      ).show();
    } catch (e) {
      emit(DataDeletionError());
      customAwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Error',
        description: 'Error deleting the Barcode \n خطأ في حذف هذا الباركود',
        buttonColor: const Color(0xffD93E47),
      ).show();
      
      print('Error in deleteData: $e');
    }
  }

  Future<void> deleteAllData(BuildContext context) async {
    try {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('qrcodes').get();
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      await _resetCurrentId();
      emit(AllDataDeletedSuccessfully());
      customAwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: 'Success',
        description: 'All Barcodes deleted successfully! \n تم حذف الباركود كل بنجاح',
        buttonColor: const Color(0xff00CA71),
      ).show();
    } catch (e) {
      emit(DataDeletionError());
      customAwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Error',
        description: 'Error deleting all the Barcodes \n خطأ في حذف كل الباركود',
        buttonColor: const Color(0xffD93E47),
      ).show();
     
      print('Error: $e');
    }
  }
Future<List<String>> fetchCompanyNames() async {
    CollectionReference qrcodes =
        FirebaseFirestore.instance.collection('qrcodes');

    QuerySnapshot querySnapshot = await qrcodes.get();

    // Use a Set to ensure uniqueness
    Set<String> companyNamesSet = querySnapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)['company'] as String)
        .toSet(); // Convert to Set to remove duplicates

    // Convert Set to List
    List<String> companyNames = companyNamesSet.toList();

    return companyNames;
  }
 Future<void> generateExcel(List<Map<String, dynamic>> qrcodes,BuildContext context) async {
    var excel = Excel.createExcel();

    Sheet sheetObject = excel['QR Codes'];
    sheetObject.appendRow([
      'ID',
      'Barcode \n الباركود',
      'DateTime \n التاريخ',
      'Company \n الشركة',
    ]);

    for (var code in qrcodes) {
      sheetObject.appendRow([
        code['id'],
        code['qrCode'],
        code['datetime'],
        code['company'],
      ]);
    }
    var bytes = excel.encode();

    if (bytes == null) {
      throw Exception('Failed to encode Excel file');
    }

    // Create a Blob from the bytes
    final blob = html.Blob([bytes],
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

    // Create a download link and trigger it
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'QRCodesquary.xlsx')
      ..click();
    html.Url.revokeObjectUrl(url);

    // Show success dialog
    customAwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: 'Success',
      description:
          'Excel file downloaded successfully! \n تم تنزيل ملف اكسل بنجاح',
      buttonColor: const Color(0xff00CA71),
    ).show();
  }
  Future<void> rearrangeAndSetCurrentId() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('qrcodes')
          .orderBy('id')
          .get();
      WriteBatch batch = FirebaseFirestore.instance.batch();
      int currentId = 1;

      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {'id': currentId});
        currentId++;
      }
      await batch.commit();

      DocumentReference idRef =
          FirebaseFirestore.instance.collection('metadata').doc('currentId');
      await idRef.set({'id': currentId});
    } catch (e) {
      print("Error rearranging IDs and setting currentId: $e");
    }
  }

  Future<void> _resetCurrentId() async {
    DocumentReference idRef =
        FirebaseFirestore.instance.collection('metadata').doc('currentId');
    await idRef.set({'id': 1});
  }

  Future<List<Map<String, dynamic>>> queryQRCodeById(int id) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('qrcodes')
          .where('id', isEqualTo: id)
          .get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error querying QR code by ID: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> queryQRCodeByPartialDate(
      String partialDate) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('qrcodes').orderBy('id').get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((data) => (data['datetime'] as String).contains(partialDate))
          .toList();
    } catch (e) {
      print('Error querying QR codes by partial date: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> queryQRCodeByCode(String qrCode) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('qrcodes')
          .where('qrCode', isEqualTo: qrCode)
          .get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error querying QR code by code: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> queryQRCodeByCompany(
      String company) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('qrcodes')
          .where('company', isEqualTo: company)
          .get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error querying QR code by company: $e');
      return [];
    }
  }

  Future<void> loadDataCompany(String company) async {
    if (company.isEmpty) {
      qrcodes = [];
    } else {
      qrcodes = await queryQRCodeByCompany(company);
    }
    emit(DataLoaded());
  }

  final TextEditingController searchControllerID = TextEditingController();
  final TextEditingController searchControllerQR = TextEditingController();
  final TextEditingController searchControllerDatetime =
      TextEditingController();
  String searchQuery = '';
  List<Map<String, dynamic>> qrcodes = [];

  Future<void> loadDataID(String id) async {
    if (id.isEmpty) {
      qrcodes = [];
    } else {
      qrcodes = await queryQRCodeById(int.parse(id));
    }
    emit(DataLoaded());
  }

  Future<void> loadDataQR(String qr) async {
    if (qr.isEmpty) {
      qrcodes = [];
    } else {
      qrcodes = await queryQRCodeByCode(qr);
    }
    emit(DataLoaded());
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      final formattedDate = "${picked.year}/${picked.month}/${picked.day}";
      searchControllerDatetime.text = formattedDate;
      searchQuery = formattedDate;
      await loadDataDatetime(searchQuery);
    }
  }

  Future<void> loadDataDatetime(String partialDate) async {
    if (partialDate.isEmpty) {
      qrcodes = [];
    } else {
      qrcodes = await queryQRCodeByPartialDate(partialDate);
    }
    emit(DataLoaded());
  }

  @override
  Future<void> close() {
    _qrcodesController.close();
    return super.close();
  }
}
