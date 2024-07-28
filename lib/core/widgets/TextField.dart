// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:parcode/core/utilis/constant.dart';

class CustomTextFormField extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const CustomTextFormField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.onPressed,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final VoidCallback onPressed;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
            suffixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: height * 0.02),
            labelText: (widget.labelText),
            hintText: widget.hintText,
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
      ),
    );
  }
}
