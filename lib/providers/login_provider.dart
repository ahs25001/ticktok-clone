import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../sheared/styles/colors.dart';

class LoginProvider extends ChangeNotifier {
  bool passwordIsHide = true;

  ///change password visibility
  void changePasswordVisibility() {
    passwordIsHide = !passwordIsHide;
    notifyListeners();
  }

  /// login the user
  Future<void> login(String email, String password, Function loading,
      Function onSuccess, Function onError) async {
    loading();
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if(credential.user?.emailVerified??false){
        Get.snackbar("Success", 'Welcome!', backgroundColor: Colors.green);
        onSuccess();
      }else {
        onError();
        Get.snackbar("Error", 'Verify your email.',
            backgroundColor: primaryColor);
      }
    } on FirebaseAuthException catch (_) {
      onError();
      Get.snackbar("Error", 'Wrong password or Email.',
          backgroundColor: primaryColor);
    } catch (e) {
      onError();
      Get.snackbar("Error", e.toString(), backgroundColor: primaryColor);
    }
  }
}
