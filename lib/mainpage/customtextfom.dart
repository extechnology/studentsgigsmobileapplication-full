import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({super.key, this.hintText, this.iconTrailing, this.iconColor, this.controller, this.isObscured,});

  final TextEditingController username = TextEditingController();
  final String? hintText;
  final IconData? iconTrailing;
  final Color? iconColor;
  final TextEditingController? controller;
  final bool? isObscured;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black26),
        focusColor: Colors.white,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            borderSide: BorderSide(color: Colors.black26)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(
              color: Colors.black26, width: 2), // White border when focused
        ),
        suffixIcon: Icon(iconTrailing,color: iconColor,),
      ),
      //obscureText: isObscured,
    );
  }
}

class TextFieldDemo extends StatelessWidget {
  TextFieldDemo({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextField(
          obscureText: true,
          controller: controller,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            hintText: "enter name",
            hintStyle: TextStyle(color: Colors.black26),
            focusColor: Colors.white,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: Colors.black26)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(
                  color: Colors.black26, width: 2), // White border when focused
            ),
            suffixIcon: Icon(
              Icons.remove_red_eye,
              color: Colors.black45,
            ),
          ),
          //obscureText: isObscured,
        ),
      ),
    );
  }
}