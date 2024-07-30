// ignore_for_file: use_build_context_synchronously, file_names

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parcode/core/utilis/constant.dart';
import 'package:parcode/core/widgets/AwesomeDiaglog.dart';

void manualCode(
    BuildContext context, TextEditingController code, String company) async {
  String enteredCode = code.text.trim();

  if (enteredCode.isEmpty) {
    customAwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            title: 'Info',
            description:
                'Please enter the Barcode ... \n ... من فضلك ادخل الباركود',
            buttonColor: primarycolor)
        .show();
    return;
  }

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('qrcodes')
        .where('qrCode', isEqualTo: enteredCode)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      customAwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              title: 'Error',
              description:
                  'The Barcode already exists: $enteredCode \n هذا الباركود موجود بالفعل\n datetime: ${querySnapshot.docs.first['datetime']}',
              buttonColor: Colors.red)
          .show();
      return;
    }

    int nextId = await _getNextId();
    int docId = nextId;

    await FirebaseFirestore.instance
        .collection('qrcodes')
        .doc(docId.toString())
        .set({
      'id': docId,
      'qrCode': enteredCode,
      'datetime': date,
      'company': company,
    });
  } catch (e) {
    customAwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: 'Error',
            description:
                'Error storing the Barcode:  $e \n حدث خطأأثناء تخزين الباركود',
            buttonColor: const Color(0xffD93E47))
        .show();
  }
}

Future<int> _getNextId() async {
  DocumentReference idRef =
      FirebaseFirestore.instance.collection('metadata').doc('currentId');
  DocumentSnapshot idSnapshot = await idRef.get();

  if (idSnapshot.exists) {
    var data = idSnapshot.data() as Map<String, dynamic>;
    int currentId = data['id'] ?? 0;
    await idRef.update({'id': currentId + 1});
    return currentId;
  } else {
    await idRef.set({'id': 1});
    return 1;
  }
}
