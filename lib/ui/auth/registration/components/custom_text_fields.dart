import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projectTeraform/utils.dart';

class CustomField extends StatelessWidget {
  final controller;
  final bool obscureText;
  final TextInputType textInputType;
  final String? hintText;
  const CustomField(
      {Key? key,
      this.controller,
      required this.obscureText,
      required this.textInputType,
      required this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,
      obscureText: obscureText,
      decoration: InputDecoration(
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          filled: true,
          fillColor: textFieldColor,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          )),
    );
  }
}
