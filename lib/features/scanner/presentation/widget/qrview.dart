import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcode/core/utilis/constant.dart';
import 'package:parcode/features/scanner/cubit/cubit/scanner_cubit.dart';
import 'package:parcode/core/widgets/AwesomeDiaglog.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({super.key});
  static String id = 'qrview';

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      ScannerCubit.get(context).controller?.pauseCamera();
    }
    ScannerCubit.get(context).controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocProvider(
        create: (context) => ScannerCubit(),
        child: BlocConsumer<ScannerCubit, ScannerState>(
          listener: (context, state) {
            if (state is QRCodeStored) {
              debugPrint('QRCodeStored State Triggered'); // Debugging statement

              // Show AlertDialog
            } else if (state is QRCodeExists) {
              debugPrint(
                  'QRCodeExists State Triggered with: ${state.qrCode}'); // Debugging statement

              // Show AlertDialog
              customAwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      title: 'Error',
                      description:
                          'The Barcode already exists: ${ScannerCubit.get(context).result!.code} \n هذا الباركود موجود بالفعل \n ${state.time}',
                      buttonColor: Colors.red)
                  .show();
            } else if (state is QRCodeError) {
              debugPrint(
                  'QRCodeError State Triggered with: ${state.error}'); // Debugging statement

              // Show AlertDialog
              customAwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      title: 'Error',
                      description:
                          'Error storing the Barcode : ${state.error} \n حدث خطأأثناء تخزين الباركود',
                      buttonColor: const Color(0xffD93E47))
                  .show();
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: Column(
                children: <Widget>[
                  AppBar(
                    backgroundColor: primarycolor,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      color: Colors.white, // Use a different back icon
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    title: const Text(
                      'QR Scanner',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Expanded(
                      flex: 4,
                      child: ScannerCubit.get(context).buildQrView(context)),
                  Expanded(
                    flex: 1,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          if (ScannerCubit.get(context).result != null)
                            Text(
                              'Code: ${ScannerCubit.get(context).result!.code}',
                              style: const TextStyle(fontSize: 18),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                width: width * 0.84,
                                height: height * 0.07,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: primarycolor,
                                    shadowColor: Colors.grey, // Shadow color
                                    elevation: 5, // Elevation
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () => ScannerCubit.get(context)
                                      .startSingleScan(),
                                  child: const Text(
                                    'Scan Code',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontFamily: 'MulishRomanBold',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ));
  }

  @override
  void dispose() {
    ScannerCubit.get(context).controller?.dispose();
    ScannerCubit.get(context).close(); // Ensure to close the cubit
    super.dispose();
  }
}
