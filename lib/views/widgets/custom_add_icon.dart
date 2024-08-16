import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAddIcon extends StatelessWidget {
  const CustomAddIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 45.w,
      height: 30.h,
      child: Stack(
        children: [
          Container(
            margin:  EdgeInsets.only(
              left: 10.w,
            ),
            width: 38,
            decoration: BoxDecoration(
              color: const Color.fromARGB(
                255,
                250,
                45,
                108,
              ),
              borderRadius: BorderRadius.circular(7.r),
            ),
          ),
          Container(
            margin:  EdgeInsets.only(
              right: 10.w,
            ),
            width: 38.w,
            decoration: BoxDecoration(
              color: const Color.fromARGB(
                255,
                32,
                211,
                234,
              ),
              borderRadius: BorderRadius.circular(7.r),
            ),
          ),
          Center(
            child: Container(
              height: double.infinity,
              width: 38.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7.r),
              ),
              child:  Icon(
                Icons.add,
                color: Colors.black,
                size: 20.sp,
              ),
            ),
          )
        ],
      ),
    );
  }
}
