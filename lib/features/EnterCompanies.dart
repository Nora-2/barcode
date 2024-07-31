// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parcode/core/utilis/constant.dart';
import 'package:parcode/core/widgets/AwesomeDiaglog.dart';
import 'package:parcode/core/widgets/toppart.dart';
import 'package:parcode/features/home/home.dart';

class Entercompanies extends StatefulWidget {
  static String id = 'entercompanies';

  const Entercompanies({super.key});

  @override
  State<Entercompanies> createState() => _EntercompaniesState();
}

class _EntercompaniesState extends State<Entercompanies> {
  TextEditingController companyController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isDataVisible = false;

  CollectionReference companies = FirebaseFirestore.instance.collection('companies');

Future<void> addCompany() async {
  String companyName = companyController.text.trim(); // Trim to remove any leading/trailing whitespace

  // Check if the company already exists
  QuerySnapshot querySnapshot = await companies.where('Company Name', isEqualTo: companyName).get();

  if (querySnapshot.docs.isEmpty) {
    // Company does not exist, proceed to add it
    try {
      await companies.add({'Company Name': companyName});
      customAwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: 'Success',
        description: 'Company added successfully! \n تم إضافة الشركة بنجاح',
        buttonColor: Colors.green,
      ).show();
      print("Company Added");
    } catch (error) {
      customAwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Error',
        description: 'Failed to add company: $error \n فشل في إضافة الشركة',
        buttonColor: Colors.red,
      ).show();
    }
  } else {
    // Company already exists
    customAwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      title: 'Error',
      description: 'Company already exists! \n الشركة موجودة بالفعل',
      buttonColor: Colors.red,
    ).show();
  }
}


  Future<void> deleteCompany(String docId) async {
    try {
      await companies.doc(docId).delete();
      customAwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: 'Success',
        description: 'Company deleted successfully! \n تم حذف الشركة بنجاح',
        buttonColor: Colors.green,
      ).show();
    } catch (error) {
      customAwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Error',
        description: 'Failed to delete company: $error \n فشل في حذف الشركة',
        buttonColor: Colors.red,
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: primarycolor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            toppart(
              height: height,
              width: width,
              SpecificPage: const Core(),
            ),
            Container(
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
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.14),
                      child: Center(
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Enter your company',
                            suffixIcon: const Icon(
                              Icons.edit,
                              size: 19,
                              color: Colors.black,
                            ),
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.blueGrey)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent.withOpacity(0),
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.transparent.withOpacity(0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          controller: companyController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a company name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                    SizedBox(
                    height: height * 0.02,
                  ),
                  SizedBox(
                    width: width * 0.4,
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addCompany();
                          companyController.clear();
                        }
                      },
                      child: const Text(
                        'Add',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'MulishRomanBold',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  SizedBox(
                    width: width * 0.4,
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
                      onPressed: () {
                        setState(() {
                          isDataVisible = !isDataVisible;
                        });
                      },
                      child: const Text(
                        'View',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'MulishRomanBold',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  if (isDataVisible)
                    SizedBox(
                      height: height * 0.7,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: companies.snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final companyDocs = snapshot.data!.docs;

                          return ListView.builder(
                            itemCount: companyDocs.length,
                            itemBuilder: (context, index) {
                              var companyData = companyDocs[index].data() as Map<String, dynamic>;
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                child: ListTile(
                                  title: Text(companyData['Company Name']),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      deleteCompany(companyDocs[index].id);
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    )
                  else
                    Container(color:  Colors.white, height: height * 0.7,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
