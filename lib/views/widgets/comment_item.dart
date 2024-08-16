import 'package:expandable_text/expandable_text.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tik_tok_clon/constants.dart';
import 'package:tik_tok_clon/models/comment_model.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../providers/home_provider.dart';
import '../../sheared/styles/colors.dart';

class CommentItem extends StatelessWidget {
  CommentModel? commentModel;

  CommentItem(this.commentModel);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(35.r),
          child: FancyShimmerImage(
            imageUrl: commentModel?.profilePhoto ?? "",
            boxFit: BoxFit.cover,
            shimmerHighlightColor: Colors.red,
            shimmerBaseColor: Colors.white,
            width: 50.w,
            height: 50.h,
            errorWidget: const Icon(
              Icons.error,
              color: Colors.red,
            ),
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              commentModel?.username ?? "",
              style: TextStyle(color: primaryColor, fontSize: 18.sp),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * .6,
              child: ExpandableText(
                commentModel?.comment ?? "",
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
                expandText: 'show more',
                animation: true,
                collapseText: 'show less',
                expandOnTextTap: true,
                collapseOnTextTap: true,
                maxLines: 2,
                linkColor: primaryColor,
              ),
            ),
            Text(
              "${timeago.format(commentModel!.datePublished.toDate())} ${(commentModel?.likes.length) ?? 0} likes ",
              style: TextStyle(color: Colors.white60, fontSize: 12.sp),
            ),
          ],
        ),
        const Spacer(),
        Consumer<HomeProvider>(
          builder: (context, value, child) => InkWell(
            onTap: () {
              value.likeTheComment(commentModel!);
            },
            child: Icon(
              ((commentModel?.likes.contains(firebaseAuth.currentUser?.uid)) ??
                      false)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: Colors.red,
              size: 25.sp,
            ),
          ),
        )
      ],
    );
  }
}
