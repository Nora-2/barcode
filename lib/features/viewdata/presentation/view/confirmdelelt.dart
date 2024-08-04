


import 'package:flutter/material.dart';

class confirmdelete extends StatelessWidget {
  const confirmdelete({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Confirm Delete',
        style: TextStyle(
            fontSize: 27,
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontFamily: 'MulishRomanBold'),
      ),
      content: const Text(
        'Are you sure you want to delete all data?',
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w200,
            fontFamily: 'MulishRomanBold'),
      ),
      backgroundColor: Colors.white,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .pop(false); // Cancel the delete action
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xff2452B1),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .pop(true); // Confirm the delete action
          },
          child: const Text(
            'Delete',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xff2452B1),
            ),
          ),
        ),
      ],
    );
  }
}
