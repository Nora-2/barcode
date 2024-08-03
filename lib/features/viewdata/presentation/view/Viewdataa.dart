// ignore_for_file: use_build_context_synchronously, unused_field, library_private_types_in_public_api, file_names, avoid_print, must_be_immutable, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_excel/excel.dart';
import 'package:parcode/core/utilis/constant.dart';
import 'package:parcode/core/widgets/AwesomeDiaglog.dart';
import 'package:parcode/features/home/home.dart';
import 'package:parcode/features/viewdata/cubit/cubit/data_cubit.dart';
import 'package:universal_html/html.dart' as html;

class ViewDataScreen extends StatefulWidget {
  const ViewDataScreen({super.key});
  static String id = 'viewdata';

  @override
  _ViewDataScreenState createState() => _ViewDataScreenState();
}

class _ViewDataScreenState extends State<ViewDataScreen> {
  String? selectedItem;
  List<Map<String, dynamic>> selectedQRCodes = [];
  bool isloding = false;
  @override
  void initState() {
    super.initState();
    // Initial setup, if needed
  }

  @override
  void dispose() {
    DataCubit.get(context).close(); // Ensure resources are closed
    super.dispose();
  }

  Future<List<String>> fetchCompanyNames() async {
    CollectionReference qrcodes =
        FirebaseFirestore.instance.collection('qrcodes');

    QuerySnapshot querySnapshot = await qrcodes.get();

    // Use a Set to ensure uniqueness
    Set<String> companyNamesSet = querySnapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)['company'] as String)
        .toSet(); // Convert to Set to remove duplicates

    // Convert Set to List
    List<String> companyNames = companyNamesSet.toList();

    return companyNames;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => DataCubit(),
      child: BlocConsumer<DataCubit, DataState>(
        listener: (context, state) {
          if (state is DataDeletedSuccessfully ||
              state is AllDataDeletedSuccessfully) {
            setState(() {});
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: primarycolor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Core()),
                  );
                },
              ),
              title: const Text(
                'View QR Codes',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pacifico',
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete_sweep, color: Colors.white),
                  onPressed: () async {
                    await DataCubit.get(context).deleteAllData(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ViewDataScreen()));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.download, color: Colors.white),
                  onPressed: () async {
                    final qrcodes = DataCubit.get(context).qrcodes;
                    await generateExcel(
                      qrcodes,
                    );
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: height * 0.05,
                        bottom: height * 0.05,
                        left: 16,
                        right: 16),
                    child: TextField(
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () {
                              DataCubit.get(context).selectDate(context);
                              DataCubit.get(context).searchQuery =
                                  DataCubit.get(context)
                                      .searchControllerDatetime
                                      .text;
                              DataCubit.get(context).loadDataDatetime(
                                  DataCubit.get(context).searchQuery);
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: width * 0.05,
                              vertical: height * 0.02),
                          labelText: 'Date',
                          hintText: 'Search by Date',
                          labelStyle: TextStyle(
                            fontSize: 25,
                            color: primarycolor,
                            fontWeight: FontWeight.bold,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF047EB0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF88AACA),
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF88AACA),
                            ),
                          )),
                      controller:
                          DataCubit.get(context).searchControllerDatetime,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: height * 0.05, left: 16, right: 16),
                    child: TextField(
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              DataCubit.get(context).searchQuery =
                                  DataCubit.get(context)
                                      .searchControllerQR
                                      .text;
                              DataCubit.get(context).loadDataQR(
                                  DataCubit.get(context).searchQuery);
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: width * 0.05,
                              vertical: height * 0.02),
                          labelText: 'BARCODE',
                          hintText: 'Search by Barcode',
                          labelStyle: TextStyle(
                            fontSize: 25,
                            color: primarycolor,
                            fontWeight: FontWeight.bold,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF047EB0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF88AACA),
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF88AACA),
                            ),
                          )),
                      controller: DataCubit.get(context).searchControllerQR,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: height * 0.05, left: 16, right: 16),
                    child: TextField(
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              DataCubit.get(context).searchQuery =
                                  DataCubit.get(context)
                                      .searchControllerID
                                      .text;
                              DataCubit.get(context).loadDataID(
                                  DataCubit.get(context).searchQuery);
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: width * 0.05,
                              vertical: height * 0.02),
                          labelText: 'ID',
                          hintText: 'Search by Id',
                          labelStyle: TextStyle(
                            fontSize: 25,
                            color: primarycolor,
                            fontWeight: FontWeight.bold,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF047EB0),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Color(0xFF88AACA),
                            ),
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF88AACA),
                            ),
                          )),
                      controller: DataCubit.get(context).searchControllerID,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: height * 0.05,
                      left: 16,
                      right: 16,
                    ),
                    child: Container(
                      height: height * 0.09,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: 2,
                          color: const Color(0xFF88AACA),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: FutureBuilder<List<String>>(
                            future: fetchCompanyNames(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<String>> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Text('No company names found');
                              } else {
                                return DropdownSearch<String>(
                                  popupProps: const PopupProps.menu(
                                    showSearchBox: true,
                                  ),
                                  items: snapshot.data!,
                                  dropdownDecoratorProps:
                                      const DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                        labelText: 'select company'),
                                  ),
                                  selectedItem: selectedItem,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedItem = newValue;

                                      DataCubit.get(context).searchQuery =
                                          newValue!;

                                      DataCubit.get(context).loadDataCompany(
                                          DataCubit.get(context).searchQuery);
                                    });
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: DataCubit.get(context).qrcodesStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      var qrcodes = DataCubit.get(context).qrcodes;

                      return qrcodes.isEmpty
                          ? const Text('No data exist')
                          : ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    height * 0.7, // Adjust the height as needed
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    DataTable(
                                      columns: const [
                                        DataColumn(label: Text('Select')),
                                        DataColumn(label: Text('ID')),
                                        DataColumn(
                                            label: Text('Barcode \n الباركود')),
                                        DataColumn(
                                            label: Text('DateTime \n التاريخ')),
                                        DataColumn(
                                            label: Text('Company \n الشركة')),
                                        DataColumn(label: Text('Actions')),
                                      ],
                                      rows: qrcodes
                                          .asMap()
                                          .entries
                                          .map<DataRow>((entry) {
                                        int index = entry.key;
                                        Map<String, dynamic> code = entry.value;
                                        bool isSelected =
                                            selectedQRCodes.contains(code);

                                        return DataRow(
                                          selected: isSelected,
                                          onSelectChanged: (selected) {
                                            setState(() {
                                              if (selected ?? false) {
                                                selectedQRCodes.add(code);
                                              } else {
                                                selectedQRCodes.remove(code);
                                              }
                                            });
                                          },
                                          cells: [
                                            DataCell(Checkbox(
                                              value: isSelected,
                                              onChanged: (selected) {
                                                setState(() {
                                                  if (selected ?? false) {
                                                    selectedQRCodes.add(code);
                                                  } else {
                                                    selectedQRCodes
                                                        .remove(code);
                                                  }
                                                });
                                              },
                                            )),
                                            DataCell(SizedBox(
                                              width: width * .1,
                                              child: Text('${index + 1}'),
                                            )),
                                            DataCell(SizedBox(
                                              width: width * .2,
                                              child: Text('${code['qrCode']}'),
                                            )),
                                            DataCell(SizedBox(
                                              width: width * .2,
                                              child:
                                                  Text('${code['datetime']}'),
                                            )),
                                            DataCell(SizedBox(
                                              width: width * .2,
                                              child: Text('${code['company']}'),
                                            )),
                                            DataCell(
                                              GestureDetector(
                                                onTap: () async {
                                                  int docId = code['id'];
                                                  await DataCubit.get(context)
                                                      .deleteData(
                                                          docId, context);
                                                  setState(() {
                                                    DataCubit.get(context)
                                                        .qrcodes
                                                        .removeWhere(
                                                            (element) =>
                                                                element['id'] ==
                                                                code['id']);
                                                  });
                                                  DataCubit.get(context)
                                                      .qrcodes
                                                      .sort((a, b) => (a['id']
                                                              as int)
                                                          .compareTo(
                                                              b['id'] as int));
                                                },
                                                child: SizedBox(
                                                  width: width * .05,
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () async {
                                                      int docId = code['id'];
                                                      await DataCubit.get(
                                                              context)
                                                          .deleteData(
                                                              docId, context);
                                                      setState(() {
                                                        DataCubit.get(context)
                                                            .qrcodes
                                                            .removeWhere(
                                                                (element) =>
                                                                    element[
                                                                        'id'] ==
                                                                    code['id']);
                                                      });
                                                      DataCubit.get(context)
                                                          .qrcodes
                                                          .sort((a, b) => (a[
                                                                  'id'] as int)
                                                              .compareTo(b['id']
                                                                  as int));
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
         ElevatedButton(
  onPressed: selectedQRCodes.isEmpty
      ? null
      : () async {
          OverlayEntry? overlayEntry;
          OverlayState? overlayState = Overlay.of(context);

          overlayEntry = OverlayEntry(
            builder: (context) => const Positioned(
              child: Material(
                color: Colors.black45,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          );
          overlayState.insert(overlayEntry);

          try {
            // Use a local copy of selectedQRCodes to avoid modifying the list while iterating
            var itemsToDelete = List<Map<String, dynamic>>.from(selectedQRCodes);

            for (var code in itemsToDelete) {
              int docId = code['id'];
              await DataCubit.get(context).deleteData(docId, context);
              DataCubit.get(context).qrcodes.removeWhere((element) =>
                  element['id'] == docId);
            }

            setState(() {
              selectedQRCodes.clear();
              DataCubit.get(context).qrcodes.sort((a, b) =>
                  (a['id'] as int).compareTo(b['id'] as int));
            });
          } catch (e) {
            print('Error deleting selected QR codes: $e');
          } finally {
            overlayEntry.remove();
          }
        },
  child: const Text('Delete Selected'),
)


                                  ],
                                ),
                              ),
                            );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> generateExcel(List<Map<String, dynamic>> qrcodes) async {
    var excel = Excel.createExcel();

    Sheet sheetObject = excel['QR Codes'];
    sheetObject.appendRow([
      'ID',
      'Barcode \n الباركود',
      'DateTime \n التاريخ',
      'Company \n الشركة',
    ]);

    for (var code in qrcodes) {
      sheetObject.appendRow([
        code['id'],
        code['qrCode'],
        code['datetime'],
        code['company'],
      ]);
    }
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
      ..setAttribute('download', 'QRCodesquary.xlsx')
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
  }
}
