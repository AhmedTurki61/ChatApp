import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomFormTextFiled extends StatelessWidget {
  CustomFormTextFiled(
      {super.key,
      this.hintText,
      this.obscureText = false,
      required this.onchanged});
  String? hintText;
  bool? obscureText;
  Function(String)? onchanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        color: Colors.white,
      ),
      obscureText: obscureText!,
      validator: (data) {
        if (data!.isEmpty) {
          return 'this field is required';
        }
      },
      onChanged: onchanged,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: const TextStyle(
          color: Colors.white,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          // borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
    );
  }
}
