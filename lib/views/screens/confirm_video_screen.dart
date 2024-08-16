import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tik_tok_clon/views/screens/home_screen.dart';
import 'package:video_player/video_player.dart';

import '../../providers/upload_video_provider.dart';
import '../widgets/loading.dart';
import '../widgets/text_input_field.dart';

class ConfirmVideoScreen extends StatefulWidget {
  File video;

  ConfirmVideoScreen(this.video);

  @override
  State<ConfirmVideoScreen> createState() => _ConfirmVideoScreenState();
}

class _ConfirmVideoScreenState extends State<ConfirmVideoScreen> {
  late VideoPlayerController videoPlayerController;
  TextEditingController captionController = TextEditingController();
  TextEditingController songController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      videoPlayerController = VideoPlayerController.file(widget.video);
    });
    videoPlayerController.initialize().then(
      (_) {
        setState(() {});
      },
    );
    videoPlayerController.play();
    videoPlayerController.setVolume(1);
    videoPlayerController.setLooping(false);
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: ChangeNotifierProvider(
        create: (context) => UploadVideoProvider(),
        builder: (context, child) => Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 30.h,
                ),
                (videoPlayerController.value.isInitialized)
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 1.5,
                        child: VideoPlayer(videoPlayerController),
                      )
                    : const Loading(),
                SizedBox(
                  height: 30.h,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Consumer<UploadVideoProvider>(
                    builder: (context, value, child) => Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          width: MediaQuery.of(context).size.width - 20,
                          child: TextInputField(
                            controller: songController,
                            label: 'Song Name',
                            icon: Icons.music_note,
                            validator: (String? value) {
                              if (value == null || value.trim().isEmpty) {
                                return "this field is required";
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: MediaQuery.of(context).size.width - 20,
                          child: TextInputField(
                            controller: captionController,
                            label: 'Caption',
                            icon: Icons.closed_caption,
                            validator: (String? value) {
                              if (value == null || value.trim().isEmpty) {
                                return "this field is required";
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (key.currentState!.validate()) {
                                value.uploadReel(
                                    video: widget.video,
                                    songName: songController.text,
                                    caption: captionController.text,
                                    onSuccess: () {
                                      Navigator.pop(context);
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomeScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    },
                                    onLoading: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return const PopScope(
                                              canPop: false,
                                              child: AlertDialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                content: Loading(),
                                              ),
                                            );
                                          },
                                          barrierDismissible: false);
                                    },
                                    onError: () {
                                      Navigator.pop(context);
                                    });
                              }
                            },
                            child: Text(
                              'Share!',
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: Colors.white,
                              ),
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
