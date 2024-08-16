import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tik_tok_clon/constants.dart';
import 'package:tik_tok_clon/views/screens/auth/sign_up_screen.dart';
import 'package:tik_tok_clon/views/screens/home_screen.dart';
import 'package:tik_tok_clon/views/widgets/text_input_field.dart';

import '../../../providers/login_provider.dart';
import '../../../sheared/styles/colors.dart';
import '../../widgets/loading.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginProvider(),
      builder: (context, child) => Form(
        key: formKey,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Tik Tok Clone",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: 35.sp,
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 25.sp, fontWeight: FontWeight.w700),
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
                  isEmail: true,
                  icon: Icons.email,
                ),
                SizedBox(
                  height: 25.h,
                ),
                Consumer<LoginProvider>(
                  builder: (context, value, child) => TextInputField(
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "This field is required";
                      }
                    },
                    isPasswordHide: value.passwordIsHide,
                    changePasswordVisibility: () {
                      value.changePasswordVisibility();
                    },
                    controller: passwordController,
                    label: "Password",
                    isPassword: true,
                    icon: Icons.lock,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Consumer<LoginProvider>(
                  builder: (context, value, child) => ElevatedButton(
                    onPressed: () {
                      value.login(emailController.text, passwordController.text,
                          () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const PopScope(
                                canPop: false,
                                child: AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  content: Loading(),
                                ),
                              );
                            },
                            barrierDismissible: false);
                      }, () {
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false,
                        );
                      }, () {
                        Navigator.pop(context);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r))),
                    child: Text(
                      "Login",
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
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 20.sp,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ));
                      },
                      child: Text(
                        "Register",
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
    );
  }
}
