import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tik_tok_clon/constants.dart';

import '../models/reel_model.dart';
import '../models/user_model.dart';
import '../sheared/network/remote/firebase/firebase_manager.dart';
import '../sheared/styles/colors.dart';

enum GetProfileState { loading, success, error }

enum GetReelsState { loading, success, error }

class ProfileProvider extends ChangeNotifier {
  UserModel? user;
  GetProfileState? getProfileState;
  GetReelsState? getReelsState;
  List<ReelModel>? reels;

  void getUser(String id) async {
    try {
      getProfileState = GetProfileState.loading;
      user = await FirebaseManager.getUserById(id);
      getProfileState = GetProfileState.success;
      notifyListeners();
    } catch (e) {
      getProfileState = GetProfileState.error;
      Get.snackbar("Error", e.toString(), backgroundColor: primaryColor);
      notifyListeners();
    }
  }

  void getReelsList(String id) async {
    try {
      getReelsState = GetReelsState.loading;
      notifyListeners();
      reels = await FirebaseManager.getReelsByUserId(id);
      getReelsState = GetReelsState.success;
      notifyListeners();
    } catch (e) {
      getReelsState = GetReelsState.error;
      Get.snackbar("Error", e.toString(), backgroundColor: primaryColor);
      notifyListeners();
    }
  }

  void signOut(Function onSuccess, Function onLoading) {
    onLoading();
    firebaseAuth.signOut();
    notifyListeners();
    onSuccess();
  }

  void follow( Function onLoading, Function onSuccess, Function onError) async {
    try{
      onLoading();
      user!.followers.add(firebaseAuth.currentUser?.uid);
      await FirebaseManager.upDateUser(user!);
      var currentUser = await FirebaseManager.getUserById(firebaseAuth.currentUser?.uid ?? "");
      currentUser!.following.add(user?.id);
      await FirebaseManager.upDateUser(currentUser);
      onSuccess();
    }catch(e){
      Get.snackbar("Error", e.toString(), backgroundColor: primaryColor);
      onError();
    }

    notifyListeners();
  }

  void unFollow(
      Function onLoading, Function onSuccess, Function onError) async {
    try {
      onLoading();
      user!.followers.remove(firebaseAuth.currentUser?.uid);
      await FirebaseManager.upDateUser(user!);
      var currentUser = await FirebaseManager. getUserById(firebaseAuth.currentUser?.uid ?? "");
      currentUser!.following.remove(user?.id);
      await FirebaseManager.upDateUser(currentUser);
      onSuccess();
    } catch (e) {
      Get.snackbar("Error", e.toString(), backgroundColor: primaryColor);
      onError();
    }

    notifyListeners();
  }
}
