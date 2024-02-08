import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final  controller;
  final bool obscureText;
  final TextInputType textInputType;
  final String? hintText;
  const CustomField({Key? key, this.controller, required this.obscureText, required this.textInputType, required this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      obscureText: obscureText,
      decoration: InputDecoration(
          hintText: hintText,
          focusedBorder: const OutlineInputBorder(),
          border: const OutlineInputBorder()),
    );
  }
}
