// ignore_for_file: use_build_context_synchronously, unused_field, library_private_types_in_public_api, file_names, avoid_print, must_be_immutable, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcode/core/utilis/constant.dart';
import 'package:parcode/features/home/home.dart';
import 'package:parcode/features/viewdata/cubit/cubit/data_cubit.dart';
import 'package:parcode/features/viewdata/presentation/view/confirmdelelt.dart';


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
                    bool? confirmDelete = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const confirmdelete();
                      },
                    );

                    if (confirmDelete == true) {
                      await DataCubit.get(context).deleteAllData(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ViewDataScreen()),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.download, color: Colors.white),
                  onPressed: () async {
                    final qrcodes = DataCubit.get(context).qrcodes;
                    await DataCubit.get(context).generateExcel(
                      qrcodes,context
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
                            future: DataCubit.get(context).fetchCompanyNames(),
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
                                                    onPressed:  () async {
                    bool? confirmDelete = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const confirmdelete();
                      },
                    );

                    if (confirmDelete == true) {
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
                    }
                  },
                                                   
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: height * 0.08),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                          ),
                                          foregroundColor: Colors.white,
                                          backgroundColor: primarycolor,
                                          shadowColor: Colors.grey,
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: selectedQRCodes.isEmpty
                                            ? null
                                            : () async {
                    bool? confirmDelete = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const confirmdelete();
                      },
                    );

                    if (confirmDelete == true) {
                      OverlayEntry? overlayEntry;
                                                OverlayState? overlayState =
                                                    Overlay.of(context);

                                                overlayEntry = OverlayEntry(
                                                  builder: (context) =>
                                                      const Positioned(
                                                    child: Material(
                                                      color: Colors.black45,
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                                overlayState
                                                    .insert(overlayEntry);

                                                try {
                                                  var idsToDelete =
                                                      selectedQRCodes
                                                          .map((code) =>
                                                              code['id'] as int)
                                                          .toList();
                                                  await DataCubit.get(context)
                                                      .deleteselectedData(
                                                          idsToDelete, context);

                                                  setState(() {
                                                    selectedQRCodes.clear();
                                                    DataCubit.get(context)
                                                        .qrcodes
                                                        .removeWhere((element) =>
                                                            idsToDelete
                                                                .contains(
                                                                    element[
                                                                        'id']));
                                                    DataCubit.get(context)
                                                        .qrcodes
                                                        .sort((a, b) => (a['id']
                                                                as int)
                                                            .compareTo(b['id']
                                                                as int));
                                                  });
                                                } catch (e) {
                                                  print(
                                                      'Error deleting selected QR codes: $e');
                                                } finally {
                                                  overlayEntry.remove();
                                                }
                                              
                    }
                  },
                                            
                                                
                                        child: const Text('Delete Selected'),
                                      ),
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
}
