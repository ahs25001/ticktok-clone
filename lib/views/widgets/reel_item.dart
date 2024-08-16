import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tik_tok_clon/constants.dart';
import 'package:tik_tok_clon/generated/assets.dart';
import 'package:tik_tok_clon/models/user_model.dart';
import 'package:tik_tok_clon/views/screens/comment_bottom_sheet.dart';
import 'package:video_player/video_player.dart';

import '../../models/reel_model.dart';
import '../../providers/home_provider.dart';
import '../../providers/reel_item_provider.dart';
import '../../sheared/styles/colors.dart';
import '../screens/profile_screen.dart';
import 'loading.dart';

class ReelItem extends StatefulWidget {
  ReelModel reelModel;

  ReelItem(this.reelModel, {super.key});

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    setState(() {
      videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(widget.reelModel.videoUrl),
          videoPlayerOptions: VideoPlayerOptions());
    });
    videoPlayerController.initialize().then(
      (_) {
        setState(() {});
      },
    );
    videoPlayerController.play();
    videoPlayerController.setVolume(1);
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReelItemProvider()..getAuthor(widget.reelModel.uid),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            color: Colors.black,
            child: (videoPlayerController.value.isInitialized)
                ? InkWell(
                    onTap: () async {
                      if (videoPlayerController.value.isPlaying) {
                        videoPlayerController.pause();
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          barrierColor: Colors.transparent,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              content: Lottie.asset(Assets.jsonPause,
                                  width: 100.w, height: 100.h),
                            );
                          },
                        );
                        await Future.delayed(800.ms);
                        Navigator.pop(context);
                      } else {
                        videoPlayerController.play();
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          barrierColor: Colors.transparent,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              content: Lottie.asset(Assets.jsonPlay,
                                  width: 100.w, height: 100.h),
                            );
                          },
                        );
                        await Future.delayed(800.ms);
                        Navigator.pop(context);
                      }
                    },
                    child: VideoPlayer(videoPlayerController))
                : const Loading(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.0.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Selector<ReelItemProvider, UserModel?>(
                      builder: (BuildContext context, UserModel? value,
                          Widget? child) {
                        return Text(
                          value?.name ?? "",
                          style: TextStyle(
                              fontSize: 20.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        );
                      },
                      selector: (p0, p1) {
                        return p1.author;
                      },
                    ),
                    SizedBox(
                      width: 200.w,
                      child: ExpandableText(
                        widget.reelModel.caption,
                        expandText: 'show more',
                        animation: true,
                        collapseText: 'show less',
                        expandOnTextTap: true,
                        collapseOnTextTap: true,
                        maxLines: 2,
                        linkColor: primaryColor,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.music_note,
                          size: 15.sp,
                          color: Colors.white,
                        ),
                        Text(
                          widget.reelModel.songName,
                          style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Consumer<ReelItemProvider>(
                      builder: (context, reelItemProvider, child) =>
                          (reelItemProvider.author == null)
                              ? const CircularProgressIndicator(
                                  color: Colors.red,
                                )
                              : Consumer<HomeProvider>(
                                  builder: (context, homeProvider, child) {
                                  if (homeProvider.currentUser == null) {
                                    homeProvider.getCurrentUser();
                                  }
                                  return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          width: 70.w,
                                          height: 80.h,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            videoPlayerController.pause();
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileScreen(
                                                        widget.reelModel.uid,
                                                        homeProvider),
                                              ),
                                              (route) => false,
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(35.r),
                                            child: FancyShimmerImage(
                                              imageUrl: reelItemProvider
                                                      .author?.image ??
                                                  "",
                                              boxFit: BoxFit.cover,
                                              shimmerHighlightColor: Colors.red,
                                              shimmerBaseColor: Colors.white,
                                              width: 60.w,
                                              height: 60.h,
                                              errorWidget: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(35.r),
                                                child: Image.asset(
                                                  Assets.imagesProfile,
                                                  width: 60.w,
                                                  height: 60.h,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        (homeProvider.currentUser == null)
                                            ? CircularProgressIndicator(
                                                color: primaryColor,
                                              )
                                            : ((firebaseAuth.currentUser?.uid !=
                                                        widget.reelModel.uid) &&
                                                    !(homeProvider
                                                        .currentUser!.following
                                                        .contains(widget
                                                            .reelModel.uid)))
                                                ? Positioned(
                                                    bottom: 0,
                                                    child: InkWell(
                                                      onTap: () => homeProvider
                                                          .follow(
                                                              widget.reelModel
                                                                  .uid, () {
                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (context) {
                                                            return const PopScope(
                                                              canPop: false,
                                                              child:
                                                                  AlertDialog(
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                content:
                                                                    Loading(),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      }, () async {
                                                        Navigator.pop(context);
                                                        showDialog(
                                                          context: context,
                                                          barrierDismissible:
                                                              false,
                                                          builder: (context) {
                                                            return PopScope(
                                                              canPop: false,
                                                              child:
                                                                  AlertDialog(
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                content: Lottie.asset(
                                                                    Assets
                                                                        .jsonFollow,
                                                                    height:
                                                                        200.h,
                                                                    width:
                                                                        200.w),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                        await Future.delayed(
                                                            3000.ms);
                                                        Navigator.pop(context);
                                                      }, () {
                                                        Navigator.pop(context);
                                                      }),
                                                      child: Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                Colors.red,
                                                            radius: 10.r,
                                                          ),
                                                          Icon(
                                                            Icons.add,
                                                            size: 15.sp,
                                                            color: Colors.white,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox()
                                      ]);
                                }),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Consumer<HomeProvider>(
                      builder: (context, value, child) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            child: Icon(
                              Icons.favorite,
                              size: 35.sp,
                              color: (widget.reelModel.likes
                                      .contains(firebaseAuth.currentUser?.uid))
                                  ? Colors.red
                                  : Colors.white,
                            ),
                            onTap: () {
                              value.likeReel(widget.reelModel, () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.transparent,
                                      content: Lottie.asset(Assets.jsonLove),
                                    );
                                  },
                                );
                                await Future.delayed(800.ms);
                                Navigator.pop(context);
                              });
                            },
                          ),
                          SizedBox(height: 7.h),
                          Text(
                            "${widget.reelModel.likes.length}",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.sp),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                            child: Icon(
                              Icons.comment,
                              size: 35.sp,
                              color: Colors.white,
                            ),
                            onTap: () {
                              showBottomSheet(
                                showDragHandle: true,
                                constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.sizeOf(context).height * .8),
                                context: context,
                                builder: (context) {
                                  return CommentBottomSheet(
                                      widget.reelModel.id);
                                },
                              );
                            }),
                        SizedBox(height: 7.h),
                        Text(
                          "${widget.reelModel.commentCount}",
                          style:
                              TextStyle(color: Colors.white, fontSize: 18.sp),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    InkWell(
                      onTap: () async {
                        await Share.share(
                            "https://app.tiktokclon.com?code=reel&reelId=${widget.reelModel.id}");
                      },
                      child: Icon(
                        Icons.reply,
                        size: 35.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Container(
                      padding: const EdgeInsets.all(3),
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35.r),
                          gradient: const LinearGradient(
                              colors: [Colors.grey, Colors.white])),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35.r),
                        child: FancyShimmerImage(
                          imageUrl: widget.reelModel.thumbnail,
                          boxFit: BoxFit.cover,
                          shimmerHighlightColor: Colors.red,
                          shimmerBaseColor: Colors.white,
                          width: 50.w,
                          height: 50.h,
                          errorWidget: ClipRRect(
                            borderRadius: BorderRadius.circular(35.r),
                            child: Image.asset(
                              Assets.imagesMusic,
                              width: 50.w,
                              height: 50.h,
                            ),
                          ),
                        ),
                      ),
                    ).animate(
                      onComplete: (controller) {
                        controller.repeat();
                      },
                    ).rotate(
                      end: 1,
                      begin: 0,
                      duration: 5.seconds,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
