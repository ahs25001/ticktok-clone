import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tik_tok_clon/views/widgets/reel_item.dart';

import '../../providers/home_provider.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) => StreamBuilder(
        stream: homeProvider.getReels(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Get.snackbar("Error", snapshot.error.toString());
          }
          var data = snapshot.data?.docs ?? [];
          return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ReelItem(data[index].data());
              });
        },
      ),
    );
  }
}
