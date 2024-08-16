import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tik_tok_clon/models/user_model.dart';

import '../constants.dart';
import '../sheared/network/remote/firebase/firebase_manager.dart';
import '../sheared/styles/colors.dart';

class SignUpProvider extends ChangeNotifier {
  File? pickedImage;
  bool passwordIsHide = true;

  ///change password visibility
  void changePasswordVisibility() {
    passwordIsHide = !passwordIsHide;
    notifyListeners();
  }

  ///pick image
  Future<void> pickImageFromGallery() async {
    ImagePicker picker = ImagePicker();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (Platform.isAndroid) {
      if (androidInfo.version.sdkInt <= 32) {
        PermissionStatus permissionStatus = await Permission.storage.status;
        if (permissionStatus.isLimited || permissionStatus.isGranted) {
          XFile? image = await picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            pickedImage = File(image.path);
          }
        } else {
          permissionStatus = await Permission.storage.request();
          if (permissionStatus.isLimited || permissionStatus.isGranted) {
            XFile? image = await picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              pickedImage = File(image.path);
            }
          }
        }
      } else {
        PermissionStatus permissionStatus = await Permission.photos.status;
        if (permissionStatus.isLimited || permissionStatus.isGranted) {
          XFile? image = await picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            pickedImage = File(image.path);
          }
        } else {
          permissionStatus = await Permission.photos.request();
          if (permissionStatus.isLimited || permissionStatus.isGranted) {
            XFile? image = await picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              pickedImage = File(image.path);
            }
          }
        }
      }
    } else {
      PermissionStatus permissionStatus = await Permission.storage.status;
      if (permissionStatus.isLimited || permissionStatus.isGranted) {
        XFile? image = await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          pickedImage = File(image.path);
        }
      }
    }

    notifyListeners();
  }

  ///upload to fireStorage
  Future<String> uploadToStorage(File file) async {
    String url = await FirebaseManager.uploadFile(file);
    return url;
  }

  ///registering the user
  Future<void> register(
      {required String email,
      required String password,
      File? image,
      required Function loading,
      required Function onSuccess,
      required Function onError,
      required String name}) async {
    loading();
    try {
      UserCredential credential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      credential.user?.sendEmailVerification();
      String imageLink = "";
      if (image != null) {
        imageLink = await uploadToStorage(image);
      }
      UserModel userModel = UserModel(
          id: credential.user?.uid ?? "",
          email: email,
          name: name,
          likes: [],
          followers: [],
          following: [],
          image: imageLink);
      FirebaseManager.addUser(userModel);
      Get.snackbar("Massage", "User Created Successfully",
          backgroundColor: Colors.green);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar("Error", 'The password provided is too weak.',
            backgroundColor: primaryColor);
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar("Error", 'The account already exists for that email.',
            backgroundColor: primaryColor);
      }
      onError();
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: primaryColor);
      onError();
    }
  }
}
