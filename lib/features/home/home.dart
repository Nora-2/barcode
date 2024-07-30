import 'package:parcode/core/utilis/constant.dart';
import 'package:parcode/features/excel/presentation/view/excel.dart';
import 'package:parcode/features/scanner/presentation/view/scanner.dart';
import 'package:parcode/features/scanner/presentation/widget/customformfield.dart';
import 'package:parcode/features/viewdata/presentation/view/Viewdataa.dart';
import 'package:flutter/material.dart';
import 'package:parcode/core/widgets/CustomButton.dart';

class Core extends StatefulWidget {
  Core({super.key});
  static String id = 'homepage';

  @override
  State<Core> createState() => _CoreState();
}

class _CoreState extends State<Core> {
  final TextEditingController company = TextEditingController();

  // The selected item
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primarycolor,
      body: Column(
        children: [
          SizedBox(
            height: height * 0.2,
            width: width,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: height * 0.07),
                  child: const Center(
                    child: Text('Naham Inventory',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1)),
                  ),
                ),
              ],
            ),
          ),
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: height * 0.07)),
                  SizedBox(
                      width: width * 0.3,
                      height: height * 0.2,
                      child: Image.asset('assets/images/select (1).png')),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.05),
                    child: const Text(
                        'Please Enter Company Name .... \n      من فضلك ادخل اسم الشركة',
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: height * 0.04,
                        bottom: height * 0.05,
                        left: width * 0.16,
                        right: width * 0.16),
                    child: CustomFormField(
                      hint: 'Enter your Company',
                      preicon: const Icon(
                        Icons.edit,
                        size: 19,
                        color: Colors.black,
                      ),
                      controller: company,
                      onsubmit: (value) {
                        setState(() {
                          selectedItem = company.text;
                        });
                        selectedItem = company.text;
                      },
                      ispass: false,
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  const Text('Please Choose Your Operation ....',
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1)),
                  Padding(
                    padding: EdgeInsets.only(
                        top: height * 0.041, bottom: height * 0.04),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Scanner(company: selectedItem ?? '')),
                          );
                        },
                        child: const customButton(text: "Scan QR Code")),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.04),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const DownloadDataScreen()),
                          );
                        },
                        child:
                            const customButton(text: "Download Data as Excel")),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.04),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewDataScreen()),
                          );
                        },
                        child: const customButton(text: "View QR Code")),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
