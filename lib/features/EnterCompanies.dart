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
  TextEditingController _companyController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CollectionReference companies =
      FirebaseFirestore.instance.collection('companies');

  Future<void> addCompany() async {
    String companyName = _companyController.text;

    QuerySnapshot querySnapshot =
        await companies.where('Company Name', isEqualTo: companyName).get();

    if (querySnapshot.docs.isEmpty) {
      try {
        await companies.add({'Company Name': companyName});
        print("Company Added");
      } catch (error) {
        // Handle errors when adding the company
        customAwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          title: 'Error',
          description: 'Failed to add company: $error \n فشل في إضافة الشركة',
          buttonColor: Colors.red,
        ).show();
      }
    } else {
      customAwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Error',
        description: 'Company already exists! \n الشركة موجودة بالفعل',
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
      body: Column(
        children: [
          toppart(
            height: height,
            width: width,
            SpecificPage: Core(),
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
            child: Column(children: [
              Padding(padding: EdgeInsets.only(top: height * 0.07)),
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: height * 0.3,
                      bottom: height * 0.05,
                      left: width * 0.14,
                      right: width * 0.14),
                  child: Center(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter your company',
                        suffixIcon: const Icon(
                          Icons.edit,
                          size: 19,
                          color: Colors.black,
                        ),
                        hintStyle:
                            const TextStyle(color: Colors.grey, fontSize: 16),
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
                      controller: _companyController,
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
                      _companyController.clear();
                    }
                  },
                  child: Text(
                    'Add',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontFamily: 'MulishRomanBold',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
