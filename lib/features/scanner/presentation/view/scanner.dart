// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:parcode/core/utilis/constant.dart';
import 'package:parcode/features/scanner/presentation/widget/customformfield.dart';
import 'package:parcode/features/scanner/presentation/widget/manualCode.dart';
import 'package:parcode/features/scanner/presentation/widget/qrview.dart';
import 'package:parcode/core/widgets/toppart.dart';

class Scanner extends StatefulWidget {
  Scanner({super.key, required this.company});
  static String id = 'Scanner';
  String company;
  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final TextEditingController code = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primarycolor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            toppart(height: height, width: width),
            Container(
              height: height * 0.8,
              width: width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: height * 0.07)),
                  SizedBox(
                      width: width * 0.4,
                      height: height * 0.3,
                      child: Image.asset('assets/images/scan.png')),
                  const Text('Place the QR code in the area',
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1)),
                  const Text(
                    'Scanning will be started automatically',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: height * 0.06,
                        bottom: height * 0.06,
                        left: width * 0.16,
                        right: width * 0.16),
                    child: CustomFormField(
                      ispass: false,
                      hint: 'Enter your Code',
                      suffix: IconButton(
                        icon: const Icon(Icons.qr_code_scanner),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const QRViewExample()));
                        },
                      ),
                      preicon: const Icon(
                        Icons.edit,
                        size: 19,
                        color: Colors.black,
                      ),
                      controller: code,
                      onsubmit: (value) {
                        manualCode(context, code, widget.company);
                        code.clear();
                      },
                    ),
                  ),
                  SizedBox(
                    width: width * 0.84,
                    height: height * 0.07,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: primarycolor,
                        shadowColor: Colors.grey,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () =>
                          manualCode(context, code, widget.company),
                      child: const Text(
                        'Store Code',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'MulishRomanBold',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
