// ignore_for_file: use_build_context_synchronously, unused_local_variable, avoid_print

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcode/core/widgets/AwesomeDiaglog.dart';
import 'package:universal_html/html.dart' as html;

part 'excel_state.dart';

class ExcelCubit extends Cubit<ExcelState> {
  ExcelCubit() : super(ExcelInitial());

  static ExcelCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> downloadData(BuildContext context) async {
    try {
      // Fetch data from Firestore
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('qrcodes').get();
      List<Map<String, dynamic>> data = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      if (data.isEmpty) {
        throw Exception('No data available');
      }

      // Create an Excel file
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['QR Codes'];

      // Define headers
      List<String> headers = data[0].keys.toList();

      // Populate headers in the first row
      for (int i = 0; i < headers.length; i++) {
        var cell = sheetObject
            .cell(CellIndex.indexByString('${String.fromCharCode(65 + i)}1'));
        cell.value = headers[i];
      }

      // Populate Excel sheet with data
      for (int i = 0; i < data.length; i++) {
        Map<String, dynamic> row = data[i];
        int j = 0;
        for (String header in headers) {
          var cell = sheetObject.cell(CellIndex.indexByString(
              '${String.fromCharCode(65 + j)}${i + 2}'));
          cell.value = row[header];
          j++;
        }
      }

      // Encode the Excel file
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
        ..setAttribute('download', 'QRCodes.xlsx')
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

      // Emit success state
      emit(ExcelDownloadSuccess());
    } catch (e) {
      // Show error dialog
      customAwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Error',
        description: 'Failed to download Excel \n فشل في تنزيل ملف اكسل',
        buttonColor: const Color(0xffD93E47),
      ).show();

      print('Error: $e');
      // Emit failure state
      emit(ExcelDownloadFailed());
    }
  }
}
