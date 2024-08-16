import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_tok_clon/constants.dart';
import 'package:tik_tok_clon/models/reel_model.dart';
import 'package:tik_tok_clon/models/user_model.dart';
import 'package:video_compress/video_compress.dart';

import '../sheared/network/remote/firebase/firebase_manager.dart';
import '../sheared/styles/colors.dart';

class UploadVideoProvider extends ChangeNotifier {

  Future<File> getThumbnail(String path) async {
    await VideoCompress.deleteAllCache();
    if (VideoCompress.isCompressing) {
      await VideoCompress.cancelCompression();
    }
    File thumbnail = await VideoCompress.getFileThumbnail(path);
    return thumbnail;
  }
  Future<String> uploadImageToStorage(String path) async {
    try {
      File thumbnail = await getThumbnail(path);
      if (!thumbnail.existsSync()) {
        throw Exception("Thumbnail file does not exist.");
      }
      print("Uploading thumbnail...");
      String url = await FirebaseManager.uploadFile(thumbnail);
      print("Image URL: $url");
      return url;
    } catch (e) {
      print("Error: $e");
      return "";
    }
  }


  void uploadReel(
      {required File video,
      required String songName,
      required String caption,
      required Function onSuccess,
      required Function onLoading,
      required Function onError}) async {
    try {
      onLoading();
      String videoUrl = await FirebaseManager.uploadFile(video);
      UserModel? user = await FirebaseManager.getUserById(firebaseAuth.currentUser?.uid ?? "");
      var docRef = FirebaseManager.getReelCollection().doc();
      String thumbnailUrl = await uploadImageToStorage(video.path);
      ReelModel reelModel = ReelModel(
          username: user?.name ?? "",
          uid: user?.id ?? "",
          id: docRef.id,
          likes: [],
          commentCount: 0,
          shareCount: 0,
          songName: songName,
          caption: caption,
          videoUrl: videoUrl,
          thumbnail: thumbnailUrl);
      docRef.set(reelModel);
      Get.snackbar("Success", "Reel Uploaded Successfully",
          backgroundColor: Colors.green);
      onSuccess();
    } catch (e) {
      onError();
      print(e.toString());
      Get.snackbar("Error", e.toString(), backgroundColor: primaryColor);
    }
  }
}
