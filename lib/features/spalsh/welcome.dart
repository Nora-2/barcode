import 'package:flutter/material.dart';
import 'package:parcode/features/home/home.dart';
import 'package:parcode/core/widgets/CustomButton.dart';

// ignore: camel_case_types
class welcomePage extends StatefulWidget {
  const welcomePage({super.key});
  static String id = 'welcomepage';
  @override
  State<welcomePage> createState() => _welcomePageState();
}

// ignore: camel_case_types
class _welcomePageState extends State<welcomePage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Column(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: height * 0.1, bottom: height * 0.05),
            child: SizedBox(
                width: width * 0.7,
                height: height * 0.3,
                child: Image.asset('assets/images/QR.jpg')),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: height * 0.05),
          child: const Text(
            'Welcome To Barcode Scanner',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: height * 0.01),
          child: const Text(
            'Please give access your Camera so that \n       we can scan and produce you \n            what is inside the code.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: height * 0.2),
          child: GestureDetector(
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, Core.id, (route) => false);
              },
              child: const customButton(text: "Let's Get Started")),
        ),
      ],
    ));
  }
}
