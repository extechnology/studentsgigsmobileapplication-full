import 'package:flutter/material.dart';

Widget buildSectionLabel(String text, double? fontSize) {
  return Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 10),
    child: Text(
      text,
      style: TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
          color: Color(0xff3F414E)),
    ),
  );
}
