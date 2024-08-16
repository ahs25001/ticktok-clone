import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tik_tok_clon/constants.dart';
import 'package:tik_tok_clon/models/user_model.dart';

import '../sheared/network/remote/firebase/firebase_manager.dart';
import '../sheared/styles/colors.dart';

class EditeProfileProvider extends ChangeNotifier {
  File? pickedImage;

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

  void saveChanges(UserModel user, Function onLoading, Function onSuccess,
      Function onError) async {
    try {
      onLoading();
      firebaseAuth.currentUser!.verifyBeforeUpdateEmail(user.email!);
      Get.snackbar("Success", "Verify Email now",
          backgroundColor: Colors.green);
      firebaseAuth.currentUser!.updateEmail(user.email!);
      if (pickedImage != null) {
        var response = await firebaseStorage
            .ref()
            .child(pickedImage!.path)
            .putFile(pickedImage!);
        user.image = await response.ref.getDownloadURL();
      }
      await FirebaseManager.upDateUser(user);
      Get.snackbar("Success", "Profile updated successfully",
          backgroundColor: Colors.green);
      await firebaseAuth.signOut();
      onSuccess();
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: primaryColor);
      onError();
    }
  }
}
