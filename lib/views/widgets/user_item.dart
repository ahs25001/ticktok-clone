import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tik_tok_clon/constants.dart';
import 'package:tik_tok_clon/models/user_model.dart';
import 'package:tik_tok_clon/views/screens/profile_screen.dart';

import '../../providers/home_provider.dart';
import '../../sheared/styles/colors.dart';


class UserItem extends StatelessWidget {
  UserModel userModel;
HomeProvider homeProvider ;
  UserItem(this.userModel,this.homeProvider);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(userModel.id ?? "",homeProvider),
            ));
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.r),
          side: BorderSide(color: primaryColor!)),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(35.r),
        child: FancyShimmerImage(
          imageUrl: userModel.image ?? "",
          width: 50.w,
          height: 50.h,
        ),
      ),
      title: Text(
        userModel.name ?? "",
        style: TextStyle(fontSize: 18.sp, color: Colors.white),
      ),
    );
  }
}
