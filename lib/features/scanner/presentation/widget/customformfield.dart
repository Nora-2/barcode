import 'package:flutter/material.dart';

class CustomFormField extends StatefulWidget {
  const CustomFormField({
    required this.hint,
    required this.preicon,
    this.text,
    this.sign,
    this.massege,
    this.val,
    required this.ispass,
    this.suffix,
    required this.controller,
    this.onChanged,
    this.onsubmit,
    super.key,
  });
  final bool ispass;
  final String hint;
  final Widget preicon;
  final TextInputType? text;
  final String? sign;
  final String? massege;
  final Widget? suffix;
  final void Function(String)? onsubmit;
  final TextEditingController? controller;
  final String? Function(String?)? val;
  final void Function(String?)? onChanged;

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      onFieldSubmitted: (value) {
        if (widget.onsubmit != null) {
          widget.onsubmit!(value);
        }
        // Request focus again after submitting
        _focusNode.requestFocus();
      },
      onChanged: widget.onChanged,
      textAlignVertical: TextAlignVertical.center,
      textAlign: TextAlign.start,
      maxLines: 1,
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
        prefixIcon: widget.preicon,
        suffixIcon: widget.suffix,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey)),
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
      obscureText: widget.ispass,
      obscuringCharacter: '*',
      keyboardType: widget.text,
      validator: widget.val,
    );
  }
}
