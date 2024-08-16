// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lottie/lottie.dart';
// import 'package:tik_tok_clon/views/widgets/loading.dart';
// import 'package:video_player/video_player.dart';
//
// import '../../constants.dart';
// import '../../generated/assets.dart';
//
// class VideoPlayerItem extends StatefulWidget {
//   String videoUrl;
//
//   VideoPlayerItem(this.videoUrl);
//
//   @override
//   _VideoPlayerItemState createState() => _VideoPlayerItemState();
// }
//
// class _VideoPlayerItemState extends State<VideoPlayerItem> {
//   @override
//   void initState() {
//     super.initState();
//     if(videoPlayerController?.value.isPlaying??false){
//       videoPlayerController!.pause();
//     }
//     setState(() {
//       videoPlayerController = VideoPlayerController.networkUrl(
//           Uri.parse(widget.videoUrl),
//           videoPlayerOptions: VideoPlayerOptions());
//     });
//     videoPlayerController!.initialize().then(
//       (_) {
//         setState(() {});
//       },
//     );
//     videoPlayerController!.play();
//     videoPlayerController!.setVolume(1);
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.sizeOf(context).width,
//       height: MediaQuery.sizeOf(context).height,
//       color: Colors.black,
//       child: (videoPlayerController!.value.isInitialized)
//           ? InkWell(
//               onTap: () async {
//                 if (videoPlayerController!.value.isPlaying) {
//                   videoPlayerController!.pause();
//                   showDialog(
//                     context: context,
//                     barrierDismissible: false,
//                     barrierColor: Colors.transparent,
//                     builder: (context) {
//                       return AlertDialog(
//                         backgroundColor: Colors.transparent,
//                         elevation: 0,
//                         content: Lottie.asset(Assets.jsonPause,
//                             width: 100.w, height: 100.h),
//                       );
//                     },
//                   );
//                   await Future.delayed(800.ms);
//                   Navigator.pop(context);
//                 }else {
//                   videoPlayerController!.play();
//                   showDialog(
//                     context: context,
//                     barrierDismissible: false,
//                     barrierColor: Colors.transparent,
//                     builder: (context) {
//                       return AlertDialog(
//                         backgroundColor: Colors.transparent,
//                         elevation: 0,
//                         content: Lottie.asset(Assets.jsonPlay,
//                             width: 100.w, height: 100.h),
//                       );
//                     },
//                   );
//                   await Future.delayed(800.ms);
//                   Navigator.pop(context);
//                 }
//               },
//               child: VideoPlayer(videoPlayerController!))
//           : const Loading(),
//     );
//   }
// }
