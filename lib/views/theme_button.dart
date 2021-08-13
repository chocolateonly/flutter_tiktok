import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeButton extends StatelessWidget {
  final String title;

  final VoidCallback onPressed;

  final double fontSize;

  ThemeButton({this.title: 'submit', required this.onPressed, this.fontSize: 15});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.all(10),
      child: CupertinoButton(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(30),
          child: Text(title, style: TextStyle(color: Colors.white, fontSize: fontSize)),
          onPressed: () {
            onPressed();
          }),
    );
  }
}
