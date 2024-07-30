// ignore_for_file: avoid_print

import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcode/core/utilis/constant.dart';
import 'package:parcode/core/widgets/AwesomeDiaglog.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

part 'scanner_state.dart';

class ScannerCubit extends Cubit<ScannerState> {
  ScannerCubit() : super(ScannerInitial());
  static ScannerCubit get(context) => BlocProvider.of(context);
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isScanning = false;
  int currentId = 1; // Current ID variable

  Widget buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.black,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!isScanning) {
        return;
      }

      result = scanData;
      isScanning = false;
      controller.pauseCamera();
      checkAndStoreQRCode(scanData.code);
    });
  }

  void startSingleScan() {
    result = null;
    isScanning = true;
    controller?.resumeCamera();
  }

  Future<int> _getNextId() async {
    DocumentReference idRef =
        FirebaseFirestore.instance.collection('metadata').doc('currentId');
    DocumentSnapshot idSnapshot = await idRef.get();

    if (idSnapshot.exists) {
      var data = idSnapshot.data() as Map<String, dynamic>;
      currentId = data['id'] ?? 1; // Initialize currentId to 1 if not found
      await idRef.update({'id': currentId + 1});
      return currentId;
    } else {
      await idRef.set({'id': 1});
      return 1;
    }
  }

  Future<void> checkAndStoreQRCode(String? qrCode) async {
    if (qrCode == null) return;

    try {
      int docId = await _getNextId(); // Get the current ID

      // Check if the QR code already exists in the collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('qrcodes')
          .where('qrCode', isEqualTo: qrCode)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        emit(QRCodeExists(qrCode, querySnapshot.docs.first['datetime']));
        return;
      }

      // If it doesn't exist, proceed to store it
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('qrcodes')
          .doc(docId.toString());

      await docRef.set({
        'id': docId,
        'qrCode': qrCode,
        'datetime': date,
      });

      emit(QRCodeStored());
    } catch (e) {
      emit(QRCodeError(e.toString()));
    }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      customAwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              title: 'Error',
              description:
                  'No permission to access the camera \n لا تصريح بالوصول إلى الكاميرا',
              buttonColor: const Color(0xffD93E47))
          .show();
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
}
