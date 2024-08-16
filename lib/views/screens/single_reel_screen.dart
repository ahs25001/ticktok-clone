import 'package:flutter/material.dart';
import 'package:tik_tok_clon/constants.dart';
import 'package:tik_tok_clon/models/reel_model.dart';

import '../widgets/reel_item.dart';

class SingleReelScreen extends StatefulWidget {
  ReelModel reelModel;

  SingleReelScreen(this.reelModel);

  @override
  State<SingleReelScreen> createState() => _SingleReelScreenState();
}

class _SingleReelScreenState extends State<SingleReelScreen> {
  // @override
  // void dispose() {
  //   videoPlayerController?.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ReelItem(widget.reelModel));
  }
}
