// ignore_for_file: use_build_context_synchronously, unused_field, avoid_print, unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:parcode/core/widgets/AwesomeDiaglog.dart';

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

Future<void> deleteData(String docId, BuildContext context) async {
  try {
    await FirebaseFirestore.instance
        .collection('qrcodes')
        .doc(docId)
        .delete();
    await rearrangeAndSetCurrentId();
    emit(DataDeletedSuccessfully());

    // Show AlertDialog
    customAwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      title: 'Success',
      description:
          'The Barcode deleted successfully! \n تم حذف هذا الباركود بنجاح',
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
        description:
            'All Barcodes deleted successfully! \n تم حذف الباركود كل بنجاح',
        buttonColor: const Color(0xff00CA71),
      ).show();
    } catch (e) {
      emit(DataDeletionError());

      customAwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Error',
        description:
            'Error deleting all the Barcodes \n خطأ في حذف كل الباركود',
        buttonColor: const Color(0xffD93E47),
      ).show();

      print('Error: $e');
    }
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
    CollectionReference qrcodes =
        FirebaseFirestore.instance.collection('qrcodes');
    print('Querying with ID: $id'); // Debug print
    QuerySnapshot querySnapshot =
        await qrcodes.where('id', isEqualTo: id).get();
    print(
        'Query Snapshot: ${querySnapshot.docs.map((doc) => doc.data()).toList()}'); // Debug print
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> queryQRCodeByPartialDate(
      String partialDate) async {
    CollectionReference qrcodes =
        FirebaseFirestore.instance.collection('qrcodes');
    print('Querying with partial datetime: $partialDate'); // Debug print

    try {
      // Fetch all documents
      QuerySnapshot querySnapshot = await qrcodes.get();

      // Filter results locally
      List<Map<String, dynamic>> results = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((data) => (data['datetime'] as String).contains(partialDate))
          .toList();

      print('Filtered Results: $results'); // Debug print
      return results;
    } catch (e) {
      print('Error querying QR codes by partial date: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> queryQRCodeByCode(String qrCode) async {
    CollectionReference qrcodes =
        FirebaseFirestore.instance.collection('qrcodes');
    print('Querying with QR code: $qrCode'); // Debug print
    QuerySnapshot querySnapshot =
        await qrcodes.where('qrCode', isEqualTo: qrCode).get();
    print(
        'Query Snapshot: ${querySnapshot.docs.map((doc) => doc.data()).toList()}'); // Debug print
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> queryQRCodeByCompany(
      String company) async {
    CollectionReference qrcodes =
        FirebaseFirestore.instance.collection('qrcodes');
    print('Querying with company: $company'); // Debug print
    QuerySnapshot querySnapshot =
        await qrcodes.where('company', isEqualTo: company).get();
    print(
        'Query Snapshot: ${querySnapshot.docs.map((doc) => doc.data()).toList()}'); // Debug print
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
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
      int parsedId;
      parsedId = int.parse(id);
      qrcodes = await queryQRCodeById(parsedId);
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

    if (picked != null && picked != DateTime.now()) {
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
