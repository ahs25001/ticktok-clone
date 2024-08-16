import 'dart:io';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tik_tok_clon/models/user_model.dart';
import 'package:tik_tok_clon/views/screens/auth/login_screen.dart';

import '../../constants.dart';
import '../../providers/edite_profile_provider.dart';
import '../../sheared/styles/colors.dart';
import '../widgets/loading.dart';
import '../widgets/text_input_field.dart';

class EditeProfileScreen extends StatelessWidget {
  UserModel user;

  late TextEditingController userNameController;
  late TextEditingController emailController;

  EditeProfileScreen(this.user) {
    userNameController = TextEditingController(text: user.name);
    emailController = TextEditingController(text: user.email);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EditeProfileProvider(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black12,
          title: Text(
            user.name ?? "",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Selector<EditeProfileProvider, File?>(
                      builder: (BuildContext context, value, Widget? child) {
                        return (value == null)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(75.r),
                                child: FancyShimmerImage(
                                    width: 150.w,
                                    height: 150.h,
                                    imageUrl: user.image ?? ""),
                              )
                            : CircleAvatar(
                                radius: 65.r,
                                backgroundImage: FileImage(value),
                                backgroundColor: Colors.white,
                              );
                      },
                      selector: (p0, p1) {
                        return p1.pickedImage;
                      },
                    ),
                    Consumer<EditeProfileProvider>(
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
                  isEmail: true),
              SizedBox(
                height: 15.h,
              ),
              Consumer<EditeProfileProvider>(
                builder: (context, value, child) => ElevatedButton(
                    onPressed: () {
                      user.name= userNameController.text;
                      user.email =emailController.text;
                      value.saveChanges(user,() {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return const PopScope(
                              canPop: false,
                              child: AlertDialog(
                                backgroundColor: Colors.transparent,
                                content: Loading(),
                              ),
                            );
                          },
                        );
                      },() {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                              (route) => false,
                        );
                      },(){
                        Navigator.pop(context);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r))),
                    child: Text(
                      "Save",
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
