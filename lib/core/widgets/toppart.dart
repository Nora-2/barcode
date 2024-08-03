import 'package:flutter/material.dart';
import 'package:parcode/features/EnterCompanies.dart';


// ignore: camel_case_types
class toppart extends StatelessWidget {
  const toppart({
    super.key,
    required this.height,
    required this.width,
    // ignore: non_constant_identifier_names
    required this.SpecificPage,
  });

  final double height;
  final double width;
  // ignore: non_constant_identifier_names
  final Widget SpecificPage;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.2,
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(top: height * 0.03),
            alignment: Alignment.topLeft,
            child: IconButton(
               onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SpecificPage),
                );
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color.fromARGB(255, 242, 238, 238),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: height * 0.02),
            child: const Center(
              child: Text('Naham Inventory',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1)),
            ),
          ),
             Container(
               padding: EdgeInsets.only(top: height * 0.03),
            alignment: Alignment.topRight,
            child: IconButton(
               onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>const Entercompanies()),
                );
              },
              icon: const Icon(
                Icons.business,
                color: Color.fromARGB(255, 242, 238, 238),
              ),
            ),)
        ],
      ),
    );
  }
}
