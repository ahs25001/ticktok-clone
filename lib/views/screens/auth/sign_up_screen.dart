import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tik_tok_clon/views/screens/auth/login_screen.dart';
import 'package:tik_tok_clon/views/widgets/loading.dart';

import '../../../constants.dart';
import '../../../generated/assets.dart';
import '../../../providers/sign_up_provider.dart';
import '../../../sheared/styles/colors.dart';
import '../../widgets/text_input_field.dart';

class SignUpScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpProvider(),
      builder: (context, child) => Form(
        key: formKey,
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 40.h,
                  ),
                  Text(
                    "Tik Tok Clone",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 35.sp,
                        fontWeight: FontWeight.w900),
                  ),
                  Text(
                    "Register",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Selector<SignUpProvider, File?>(
                          builder:
                              (BuildContext context, value, Widget? child) {
                            return CircleAvatar(
                              radius: 65.r,
                              backgroundImage: (value == null)
                                  ? const AssetImage(Assets.imagesProfile)
                                  : FileImage(value),
                              backgroundColor: Colors.white,
                            );
                          },
                          selector: (p0, p1) {
                            return p1.pickedImage;
                          },
                        ),
                        Consumer<SignUpProvider>(
                          builder: (context, provider, child) => IconButton(
                            icon: const Icon(Icons.add_a_photo),
                            onPressed: () {
                              provider.pickImageFromGallery();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  TextInputField(
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "This field is required";
                      }
                    },
                    controller: userNameController,
                    label: "User name",
                    icon: Icons.person,
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  TextInputField(
                    validator: (String? value) {
                      final bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value ?? "");
                      if (!emailValid) {
                        return "This email not valid";
                      } else if (value == null || value.isEmpty) {
                        return "This field is required";
                      }
                    },
                    controller: emailController,
                    label: "Email",
                    icon: Icons.email,
                    isEmail :true

                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Consumer<SignUpProvider>(
                    builder: (context, value, child) => TextInputField(
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "This field is required";
                        }
                      },
                      controller: passwordController,
                      label: "Password",
                      isPassword: true,
                      isPasswordHide: value.passwordIsHide,
                      changePasswordVisibility: (){
                        value.changePasswordVisibility();
                      },
                      icon: Icons.password,
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Consumer<SignUpProvider>(
                    builder: (context, value, child) => ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          value.register(
                              onSuccess: () {
                                Navigator.pop(context);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              onError: () {
                                Navigator.pop(context);
                              },
                              loading: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return PopScope(
                                        canPop: false,
                                        child: AlertDialog(
                                          backgroundColor: Colors.transparent,
                                          content: Loading(),
                                        ),
                                      );
                                    },
                                    barrierDismissible: false);
                              },
                              email: emailController.text,
                              password: passwordController.text,
                              image: value.pickedImage,
                              name: userNameController.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.r))),
                      child: Text(
                        "Register",
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontSize: 20.sp,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                            (route) => false,
                          );
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 20.sp, color: primaryColor),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
