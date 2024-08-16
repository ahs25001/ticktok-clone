import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tik_tok_clon/views/screens/confirm_video_screen.dart';

import '../../constants.dart';
import '../../providers/home_provider.dart';
import '../widgets/loading.dart';

class AddVideoBottomSheet extends StatelessWidget {
  const AddVideoBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: HomeProvider(),
      builder: (context, child) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.0.w),
        child: Consumer<HomeProvider>(
          builder: (context, value, child) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  value.picVideoFromGallery(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ConfirmVideoScreen(value.pickedVideo!),
                        ));
                  },(){
                    const PopScope(
                      canPop: false,
                      child: AlertDialog(
                        backgroundColor: Colors.transparent,
                        content: Loading(),
                      ),
                    );
                  });
                },
                child: Row(
                  children: [
                    const Icon(Icons.image),
                    Padding(
                      padding: EdgeInsets.all(7.0.h),
                      child: Text(
                        'Gallery',
                        style: TextStyle(fontSize: 20.sp),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  value.picVideoFromCamera(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ConfirmVideoScreen(value.pickedVideo!),
                        ));
                  });
                },
                child: Row(
                  children: [
                    const Icon(Icons.camera_alt),
                    Padding(
                      padding: EdgeInsets.all(7.0.h),
                      child: Text(
                        'Camera',
                        style: TextStyle(fontSize: 20.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
