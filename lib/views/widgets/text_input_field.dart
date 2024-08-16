import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tik_tok_clon/constants.dart';

import '../../sheared/styles/colors.dart';

class TextInputField extends StatelessWidget {
  TextEditingController controller;

  String label;
  IconData icon;
  Function validator;
  bool isPasswordHide;
  bool isPassword;
  Function? changePasswordVisibility;
  bool isEmail;

  TextInputField(
      {required this.controller,
      required this.label,
      required this.validator,
      required this.icon,
      this.isEmail = false,
      this.isPasswordHide = false,
      this.changePasswordVisibility,
      this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        return validator(value);
      },
      controller: controller,
      keyboardType: (isPassword)
          ? TextInputType.visiblePassword
          : (isEmail)?TextInputType.emailAddress:TextInputType.name,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: (isPassword)
            ? InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  changePasswordVisibility!();
                },
                child: Icon((isPasswordHide)
                    ? Icons.remove_red_eye
                    : Icons.visibility_off))
            : SizedBox(),
        prefixIcon: Icon(icon),
        labelStyle: TextStyle(
          fontSize: 20.sp,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.r),
            borderSide: const BorderSide(color: borderColor)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.r),
            borderSide: const BorderSide(color: borderColor)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.r),
            borderSide: const BorderSide(color: borderColor)),
      ),
      obscureText: isPassword && isPasswordHide,
    );
  }
}
