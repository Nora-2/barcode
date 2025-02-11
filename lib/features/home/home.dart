// ignore_for_file: avoid_print

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:parcode/core/utilis/constant.dart';
import 'package:parcode/core/widgets/AwesomeDiaglog.dart';
import 'package:parcode/core/widgets/toppart.dart';
import 'package:parcode/features/EnterCompanies.dart';
import 'package:parcode/features/excel/presentation/view/excel.dart';
import 'package:parcode/features/scanner/presentation/view/scanner.dart';
import 'package:parcode/features/viewdata/presentation/view/Viewdataa.dart';
import 'package:flutter/material.dart';
import 'package:parcode/core/widgets/CustomButton.dart';

class Core extends StatefulWidget {
  const Core({super.key});
  static String id = 'homepage';

  @override
  State<Core> createState() => _CoreState();
}

class _CoreState extends State<Core> {
  final TextEditingController company = TextEditingController();

  String? selectedItem;
  List<String> _dropdownItems = [];

  @override
  void initState() {
    super.initState();
    _fetchCompanyNames();
  }

 

Future<void> _fetchCompanyNames() async {
  try {
    // Enable offline persistence if not already enabled
    FirebaseFirestore.instance.settings =const Settings(persistenceEnabled: true);

    CollectionReference companies = FirebaseFirestore.instance.collection('companies');
    QuerySnapshot querySnapshot = await companies.get(const GetOptions(source: Source.cache));

    if (querySnapshot.docs.isEmpty) {
      querySnapshot = await companies.get();
    }

    // Extract company names
    List<String> companyNames = querySnapshot.docs
        .map((doc) => doc['Company Name'] as String)
        .toList();

    setState(() {
      _dropdownItems = companyNames;
    });
  } catch (e) {
    print("Error fetching company names: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primarycolor,
      body: Column(
        children: [
          toppart(
            height: height,
            width: width,
            SpecificPage: const Entercompanies(),
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
                    child: Container(
                      width: width * 0.84,
                      height: height * 0.09,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 2,
                          color: primarycolor,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Center(
                          child: DropdownSearch<String>(
                            popupProps: const PopupProps.menu(
                              showSearchBox: true,
                            ),
                            items: _dropdownItems,
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Select a company",
                              ),
                            ),
                            selectedItem: selectedItem,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedItem = newValue;
                              });
                              if (newValue != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Scanner(company: newValue),
                                    ));
                              }
                            },
                          ),
                        ),
                      ),
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
                          if (selectedItem == null || selectedItem == '') {
                            customAwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.info,
                                    title: 'Info',
                                    description:
                                        'Please choose the company ... \n ...من فضلك اخترالشركة',
                                    buttonColor: primarycolor)
                                .show();
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Scanner(company: selectedItem!)),
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
                                builder: (context) => const ViewDataScreen()),
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
