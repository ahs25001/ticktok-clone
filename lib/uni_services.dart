import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tik_tok_clon/context_utility.dart';
import 'package:tik_tok_clon/models/reel_model.dart';
import 'package:tik_tok_clon/sheared/network/remote/firebase/firebase_manager.dart';
import 'package:tik_tok_clon/views/widgets/reel_item.dart';
import 'package:uni_links/uni_links.dart';

class UniServices {
  static init() async {
    try {
      final Uri? uri = await getInitialUri();
      uniHandler(uri);
    } on PlatformException catch (e) {
      print("Failed to received the code");
    } on FormatException catch (_) {
      print("Wrong format code received ");
    }
    uriLinkStream.listen((event) {
      uniHandler(event);
    }, onError: (error) {
      print("OnUriLink Error : $error");
    });
  }

  static uniHandler(Uri? uri) async {
    if (uri == null || uri.queryParameters.isEmpty) {
      return;
    }
    Map<String, String> prams = uri.queryParameters;
    String receivedCode = prams["code"] ?? "";
    if (ContextUtility.context != null) {
      if (receivedCode == "reel") {
        String reelId = prams["reelId"] ?? "";
        print("ID : $reelId");
        ReelModel? reelModel = await FirebaseManager.getReelById(reelId);
        Navigator.push(
            ContextUtility.context!,
            MaterialPageRoute(
              builder: (_) => Scaffold(body: ReelItem(reelModel!)),
            ));
      }
    }
  }
}
