import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tik_tok_clon/constants.dart';

import '../models/comment_model.dart';
import '../models/reel_model.dart';
import '../models/user_model.dart';
import '../sheared/network/remote/firebase/firebase_manager.dart';
import '../sheared/styles/colors.dart';

enum SearchState { loading, success, error }

class HomeProvider extends ChangeNotifier {
  int currentTabIndex = 0;
  File? pickedVideo;
  SearchState? searchState;
  List<UserModel>? users;
  UserModel? currentUser;

  /// Change tab
  void changeTab(int newIndex) {
    currentTabIndex = newIndex;
    notifyListeners();
  }

  /// Pick Video
  void picVideoFromGallery(Function onSuccess, Function onLoading) async {
    onLoading();
    ImagePicker picker = ImagePicker();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (Platform.isAndroid) {
      if (androidInfo.version.sdkInt <= 32) {
        PermissionStatus permissionStatus = await Permission.storage.status;
        if (permissionStatus.isLimited || permissionStatus.isGranted) {
          XFile? image = await picker.pickVideo(source: ImageSource.gallery);
          if (image != null) {
            pickedVideo = File(image.path);
          } else {
            pickedVideo = null;
          }
        } else {
          permissionStatus = await Permission.storage.request();
          if (permissionStatus.isLimited || permissionStatus.isGranted) {
            XFile? video = await picker.pickVideo(source: ImageSource.gallery);
            if (video != null) {
              pickedVideo = File(video.path);
            } else {
              pickedVideo = null;
            }
          }
        }
      } else {
        PermissionStatus permissionStatus = await Permission.photos.status;
        if (permissionStatus.isLimited || permissionStatus.isGranted) {
          XFile? video = await picker.pickVideo(source: ImageSource.gallery);
          if (video != null) {
            pickedVideo = File(video.path);
          } else {
            pickedVideo = null;
          }
        } else {
          permissionStatus = await Permission.photos.request();
          if (permissionStatus.isLimited || permissionStatus.isGranted) {
            XFile? video = await picker.pickVideo(source: ImageSource.gallery);
            if (video != null) {
              pickedVideo = File(video.path);
            } else {
              pickedVideo = null;
            }
          }
        }
      }
    } else {
      PermissionStatus permissionStatus = await Permission.storage.status;
      if (permissionStatus.isLimited || permissionStatus.isGranted) {
        XFile? video = await picker.pickVideo(source: ImageSource.gallery);
        if (video != null) {
          pickedVideo = File(video.path);
        } else {
          pickedVideo = null;
        }
      }
    }
    if (pickedVideo != null) {
      onSuccess();
    }
  }

  void picVideoFromCamera(Function onSuccess) async {
    ImagePicker picker = ImagePicker();
    PermissionStatus permissionStatus = await Permission.camera.status;
    if (permissionStatus.isLimited || permissionStatus.isGranted) {
      XFile? video = await picker.pickVideo(source: ImageSource.camera);
      if (video != null) {
        pickedVideo = File(video.path);
      }
    } else {
      permissionStatus = await Permission.camera.request();
      if (permissionStatus.isLimited || permissionStatus.isGranted) {
        XFile? video = await picker.pickVideo(source: ImageSource.camera);
        if (video != null) {
          pickedVideo = File(video.path);
        } else {
          pickedVideo = null;
        }
      }
    }
    if (pickedVideo != null) {
      onSuccess();
    }
  }

  ///Get Reels
  Stream<QuerySnapshot<ReelModel>> getReels() {
    var snapshot = FirebaseManager.getReelCollection().snapshots();
    return snapshot;
  }

  /// like reel
  void likeReel(ReelModel reel, Function onSuccess) {
    try {
      String currentUserId = firebaseAuth.currentUser?.uid ?? "";
      if (reel.likes.contains(currentUserId)) {
        reel.likes.remove(currentUserId);
        FirebaseManager.getReelCollection().doc(reel.id).update(reel.toJson());
      } else {
        reel.likes.add(currentUserId);
        FirebaseManager.getReelCollection().doc(reel.id).update(reel.toJson());
        onSuccess();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: primaryColor);
    }
    notifyListeners();
  }

  /// Get Comments
  Stream<QuerySnapshot<CommentModel>> getComments(String reelId) {
    return FirebaseManager.getCommentsById(reelId);
  }

  void sendComment(CommentModel commentModel, Function onLoading,
      Function onSuccess, Function onError) async {
    try {
      onLoading();
      FirebaseManager.addComment(commentModel);
      var snapshot = await FirebaseManager.getReelCollection().doc(commentModel.reelId).get();
      ReelModel reelModel = snapshot.data()!;
      reelModel.commentCount = (reelModel.commentCount) + 1;
      await FirebaseManager.getReelCollection()
          .doc(commentModel.reelId)
          .update(reelModel.toJson());
      onSuccess();
    } catch (e) {
      onError();
      Get.snackbar("Error", e.toString(), backgroundColor: primaryColor);
    }
    notifyListeners();
  }

  void likeTheComment(CommentModel commentModel) {
    try{
      var commentCollection = FirebaseManager.getCommentCollection();
      if (commentModel.likes.contains(firebaseAuth.currentUser?.uid)) {
        commentModel.likes.remove(firebaseAuth.currentUser?.uid);
      } else {
        commentModel.likes.add(firebaseAuth.currentUser?.uid);
      }
      commentCollection.doc(commentModel.id).update(commentModel.toJson());
    }catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: primaryColor);
    }
  }

  void searchForUser(String name) async {
    try {
      searchState = SearchState.loading;
      notifyListeners();
      users = await FirebaseManager.getUserByName(name);
      searchState = SearchState.success;
    } catch (e) {
      searchState = SearchState.error;
      Get.snackbar("Error", e.toString(), backgroundColor: primaryColor);
    }
    notifyListeners();
  }

  void getCurrentUser() async {
    try{
      currentUser = await FirebaseManager.getUserById(firebaseAuth.currentUser?.uid ?? "");
    }catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: primaryColor);
    }
    notifyListeners();

  }

  void follow(
      String uid, Function onLoading, Function onSuccess, Function onError,
      {bool fromProfile = false}) async {
    try {
      if (fromProfile) {
        currentUser!.following.add(uid);
      } else {
        onLoading();
        var user = await FirebaseManager.getUserById(uid);
        user!.followers.add(currentUser?.id ?? "");
        currentUser!.following.add(uid);
        await FirebaseManager.upDateUser(currentUser!);
        await FirebaseManager.upDateUser(user);
        getCurrentUser();
        onSuccess();
      }
    } catch (e) {
      onError();
      Get.snackbar("Error", e.toString(), backgroundColor: primaryColor);
    }

    notifyListeners();
  }

  void unFollow(String uid, {bool fromProfile = false}) async {
    try{
      if (fromProfile) {
        currentUser!.following.remove(uid);
      } else {
        var user = await FirebaseManager.getUserById(uid);
        user!.followers.remove(currentUser?.id ?? "");
        currentUser!.following.remove(uid);
        await FirebaseManager.upDateUser(currentUser!);
        await FirebaseManager.upDateUser(user);
        getCurrentUser();
      }
    }catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: primaryColor);
    }
    notifyListeners();
  }
}
