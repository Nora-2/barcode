// ignore_for_file: file_names, avoid_single_cascade_in_expression_statements, avoid_print

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

// ignore: camel_case_types
class customAwesomeDialog extends StatelessWidget {
  final BuildContext context;
  final DialogType dialogType;
  final String title;
  final String description;
  final Color buttonColor;
  final VoidCallback? onOkPressed;
  final AudioPlayer audio = AudioPlayer();

  customAwesomeDialog({
    super.key,
    required this.context,
    required this.dialogType,
    required this.title,
    required this.description,
    required this.buttonColor,
    this.onOkPressed,
  });

  Future<void> playErrorSound() async {
    try {
      await audio.play(AssetSource('audios/Error.mp3'));
      print('Sound played successfully');
    } catch (e) {
      print('Error: $e');
    }
  }

  void show() {
    if (title == 'Error') {
      playErrorSound();
    }
    AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: dialogType,
      title: title,
      titleTextStyle: const TextStyle(
        fontSize: 29,
        fontWeight: FontWeight.bold,
      ),
      desc: description,
      descTextStyle: const TextStyle(fontSize: 20, fontFamily: 'PlayfairDisplay'),
      btnOk: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const Text(
          'OK',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
