import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tik_tok_clon/constants.dart';
import 'package:tik_tok_clon/models/comment_model.dart';
import 'package:tik_tok_clon/views/widgets/loading.dart';
import 'package:tik_tok_clon/views/widgets/text_input_field.dart';

import '../../providers/home_provider.dart';
import '../../sheared/network/remote/firebase/firebase_manager.dart';
import '../../sheared/styles/colors.dart';
import '../widgets/comment_item.dart';

class CommentBottomSheet extends StatelessWidget {
  TextEditingController commentController = TextEditingController();
  String reelId;

  CommentBottomSheet(this.reelId);

  GlobalKey<FormState> commentKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: commentKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.0.w),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Consumer<HomeProvider>(
                  builder: (context, value, child) => StreamBuilder(
                    stream: value.getComments(reelId),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        Get.snackbar("Error", snapshot.error.toString(),
                            backgroundColor: primaryColor);
                      }
                      var data = snapshot.data?.docs
                              .map(
                                (e) => e.data(),
                              )
                              .toList() ??
                          [];
                      return ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(
                          height: 15.h,
                        ),
                        itemBuilder: (context, index) =>
                            CommentItem(data[index]),
                        itemCount: data.length,
                      );
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextInputField(
                        controller: commentController,
                        label: "Comment",
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "This Field is required";
                          }
                        },
                        icon: Icons.comment),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Consumer<HomeProvider>(
                    builder: (context, value, child) => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r))),
                        onPressed: () async {
                          if (commentKey.currentState!.validate()) {
                            var user = await FirebaseManager.getUserById(
                                firebaseAuth.currentUser?.uid ?? "");
                            value.sendComment(
                                CommentModel(
                                  username: user?.name ?? "",
                                  comment: commentController.text,
                                  reelId: reelId,
                                  likes: [],
                                  datePublished: DateTime.now(),
                                  profilePhoto: user?.image ?? "",
                                  uid: firebaseAuth.currentUser?.uid ?? "",
                                ), () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return const AlertDialog(
                                    backgroundColor: Colors.transparent,
                                    content: Loading(),
                                  );
                                },
                              );
                            }, () {
                              Navigator.pop(context);
                              commentController.clear();
                            }, () {
                              Navigator.pop(context);
                            });
                          }
                        },
                        child: Text(
                          "Send",
                          style:
                              TextStyle(color: Colors.white, fontSize: 18.sp),
                        )),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
