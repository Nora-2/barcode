import 'package:flutter/material.dart';
import 'package:parcode/core/utilis/constant.dart';
import 'package:parcode/features/viewdata/cubit/cubit/data_cubit.dart';

class builder extends StatefulWidget {
  const builder({super.key});

  @override
  State<builder> createState() => _builderState();
}
  String? selectedItem;
  List<Map<String, dynamic>> selectedQRCodes = [];
  bool isloding = false;
class _builderState extends State<builder> {
  @override
  Widget build(BuildContext context) {
       final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder<List<Map<String, dynamic>>>(
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
                                            },
                                      child: const Text('Delete Selected'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                  },
                );
  }
}