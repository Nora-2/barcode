import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcode/core/utilis/constant.dart';
import 'package:parcode/features/excel/cubit/cubit/excel_cubit.dart';
import 'package:parcode/core/widgets/toppart.dart';

class DownloadDataScreen extends StatefulWidget {
  const DownloadDataScreen({super.key});
  static String id = 'excel';
  @override
  State<DownloadDataScreen> createState() => _DownloadDataScreenState();
}

class _DownloadDataScreenState extends State<DownloadDataScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return BlocProvider(
        create: (context) => ExcelCubit(),
        child: BlocConsumer<ExcelCubit, ExcelState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              backgroundColor: primarycolor,
              body: Column(
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
                            width: width * 0.6,
                            height: height * 0.3,
                            child: Image.asset('assets/images/download.png')),
                        const Text('Click the button to start downloding',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1)),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: height * 0.06,
                          ),
                          child: const Text(
                            'Downloading will be started automatically',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
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
                            onPressed: () =>
                                ExcelCubit.get(context).downloadData(context),
                            child: const Text(
                              'Download Data as Excel',
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
            );
          },
        ));
  }
}
