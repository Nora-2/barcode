// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parcode/core/utilis/constant.dart';
import 'package:parcode/features/viewdata/cubit/cubit/data_cubit.dart';

class customsearchdatefield extends StatefulWidget {
  const customsearchdatefield({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  State<customsearchdatefield> createState() => _customsearchdatefieldState();
}

class _customsearchdatefieldState extends State<customsearchdatefield> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DataCubit(),
        child: BlocConsumer<DataCubit, DataState>(
          listener: (context, state) {},
          builder: (context, state) {
            return TextField(
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      DataCubit.get(context).selectDate(context);
                      DataCubit.get(context).searchQuery =
                          DataCubit.get(context).searchControllerDatetime.text;
                      DataCubit.get(context)
                          .loadDataDatetime(DataCubit.get(context).searchQuery);
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: widget.width * 0.05,
                      vertical: widget.height * 0.02),
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
              controller: DataCubit.get(context).searchControllerDatetime,
            );
          },
        ));
  }
}

class customqrfield extends StatefulWidget {
  const customqrfield({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  State<customqrfield> createState() => _customqrfieldState();
}

class _customqrfieldState extends State<customqrfield> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DataCubit(),
        child: BlocConsumer<DataCubit, DataState>(
          listener: (context, state) {},
          builder: (context, state) {
            return TextField(
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      DataCubit.get(context).searchQuery =
                          DataCubit.get(context).searchControllerQR.text;
                      DataCubit.get(context)
                          .loadDataQR(DataCubit.get(context).searchQuery);
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: widget.width * 0.05,
                      vertical: widget.height * 0.02),
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
            );
          },
        ));
  }
}

class customidfield extends StatefulWidget {
  const customidfield({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  State<customidfield> createState() => _customidfieldState();
}

class _customidfieldState extends State<customidfield> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => DataCubit(),
        child: BlocConsumer<DataCubit, DataState>(
          listener: (context, state) {},
          builder: (context, state) {
            return TextField(
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      DataCubit.get(context).searchQuery =
                          DataCubit.get(context).searchControllerID.text;
                      DataCubit.get(context)
                          .loadDataID(DataCubit.get(context).searchQuery);
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: widget.width * 0.05,
                      vertical: widget.height * 0.02),
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
            );
          },
        ));
  }
}
