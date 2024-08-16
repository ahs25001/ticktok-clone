import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tik_tok_clon/constants.dart';
import 'package:tik_tok_clon/views/screens/auth/login_screen.dart';
import 'package:tik_tok_clon/views/screens/edite_profile_screen.dart';
import 'package:tik_tok_clon/views/screens/home_screen.dart';
import 'package:tik_tok_clon/views/screens/single_reel_screen.dart';
import 'package:tik_tok_clon/views/widgets/loading.dart';

import '../../generated/assets.dart';
import '../../providers/home_provider.dart';
import '../../providers/profile_provider.dart';
import '../../sheared/styles/colors.dart';

class ProfileScreen extends StatelessWidget {
  String uid;
  HomeProvider homeProvider;

  ProfileScreen(this.uid, this.homeProvider);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
        return true;
      },
      child: ChangeNotifierProvider<ProfileProvider>(
        create: (context) => ProfileProvider()
          ..getUser(uid)
          ..getReelsList(uid),
        child: Consumer<ProfileProvider>(
          builder: (context, value, child) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black12,
              leading: (firebaseAuth.currentUser?.uid == uid)
                  ? InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditeProfileScreen(value.user!),
                            ));
                      },
                      child: Icon(
                        Icons.edit,
                        size: 25.sp,
                      ))
                  : null,
              actions: [Icon(Icons.more_horiz, size: 25.sp)],
              centerTitle: true,
              title: Text(
                value.user?.name ?? "",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            body: Consumer<ProfileProvider>(
              builder: (context, value, child) {
                if (value.getProfileState == GetProfileState.loading) {
                  return const Center(child: Loading());
                } else if (value.getProfileState == GetProfileState.success) {
                  return Center(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(75.r),
                          child: FancyShimmerImage(
                            imageUrl: value.user?.image ?? "",
                            boxFit: BoxFit.cover,
                            shimmerHighlightColor: Colors.red,
                            shimmerBaseColor: Colors.white,
                            width: 100.w,
                            height: 100.h,
                            errorWidget:  CircleAvatar(
                              radius: 75.r,
                              backgroundImage:  const AssetImage(Assets.imagesProfile),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  (value.user?.following.length ?? 0)
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Following",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Column(
                              children: [
                                Text(
                                  (value.user?.followers.length ?? 0)
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Followers",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Column(
                              children: [
                                Text(
                                  (value.user?.likes.length ?? 0).toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Likes",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        (firebaseAuth.currentUser?.uid == uid)
                            ? InkWell(
                                onTap: () => value.signOut(() {
                                  Navigator.pop(context);
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginScreen(),
                                    ),
                                    (route) => false,
                                  );
                                }, () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return const PopScope(
                                        canPop: false,
                                        child: AlertDialog(
                                          backgroundColor: Colors.transparent,
                                          content: Loading(),
                                        ),
                                      );
                                    },
                                  );
                                }),
                                child: Text(
                                  "Sign Out",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                      color: primaryColor),
                                ),
                              )
                            : ((value.user!.followers
                                    .contains(firebaseAuth.currentUser?.uid))
                                ? InkWell(
                                    onTap: () {
                                      value.unFollow(() {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return PopScope(
                                              canPop: false,
                                              child: AlertDialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                content: Loading(),
                                              ),
                                            );
                                          },
                                        );
                                      }, () {
                                        Navigator.pop(context);
                                      }, () {
                                        Navigator.pop(context);
                                      });
                                      homeProvider.unFollow(uid,
                                          fromProfile: true);
                                    },
                                    child: Text(
                                      "Unfollow",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.sp,
                                          color: primaryColor),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      value.follow(() {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return PopScope(
                                              canPop: false,
                                              child: AlertDialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                content: Loading(),
                                              ),
                                            );
                                          },
                                        );
                                      }, () async {
                                        Navigator.pop(context);
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return PopScope(
                                              canPop: false,
                                              child: AlertDialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                content: Lottie.asset(
                                                    Assets.jsonFollow,
                                                    height: 200.h,
                                                    width: 200.w),
                                              ),
                                            );
                                          },
                                        );
                                        await Future.delayed(3000.ms);
                                        Navigator.pop(context);
                                      }, () {
                                        Navigator.pop(context);
                                      });
                                      homeProvider.follow(
                                          uid, () {}, () {}, () {},
                                          fromProfile: true);
                                    },
                                    child: Text(
                                      "Follow",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.sp,
                                          color: primaryColor),
                                    ),
                                  )),
                        SizedBox(
                          height: 20.h,
                        ),
                        (value.getReelsState == GetReelsState.loading)
                            ? const Loading()
                            : (value.getReelsState == GetReelsState.success &&
                                    (value.reels == null ||
                                        value.reels!.isEmpty))
                                ? Text(
                                    "No Reels yet",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22.sp),
                                  )
                                : Expanded(
                                    child: GridView.builder(
                                      itemCount: value.reels?.length ?? 0,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio: 1,
                                              crossAxisSpacing: 5.w,
                                              crossAxisCount: 2),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SingleReelScreen(
                                                        value.reels![index]),
                                              )),
                                          child: FancyShimmerImage(
                                            imageUrl:
                                                value.reels?[index].thumbnail ??
                                                    "",
                                            errorWidget:
                                                Image.asset(Assets.imagesVideo),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                      ],
                    ),
                  );
                } else {
                  return const Text("Error");
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
