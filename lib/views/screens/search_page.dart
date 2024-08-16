import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tik_tok_clon/constants.dart';
import 'package:tik_tok_clon/views/widgets/loading.dart';
import 'package:tik_tok_clon/views/widgets/user_item.dart';

import '../../generated/assets.dart';
import '../../providers/home_provider.dart';
import '../../sheared/styles/colors.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.0.w),
      child: Column(
        children: [
          Consumer<HomeProvider>(
            builder: (context, value, child) => TextFormField(
              onChanged: (name) {
                value.searchForUser(name);
              },
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.white, fontSize: 18.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18.r),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.r),
                    borderSide: const BorderSide(color: Colors.white54)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.r),
                    borderSide: BorderSide(color: primaryColor!)),
              ),
            ),
          ),
          SizedBox(height: 15.h,),
          Selector<HomeProvider, SearchState?>(
            builder: (context, value, child) =>
                (value == null) ? const Spacer() : SizedBox(),
            selector: (p0, p1) {
              return p1.searchState;
            },
          ),
          Selector<HomeProvider, SearchState?>(
            builder: (context, value, child) =>
                (value == null) ? Lottie.asset(Assets.jsonSearch) : SizedBox(),
            selector: (p0, p1) {
              return p1.searchState;
            },
          ),
          Selector<HomeProvider, SearchState?>(
            builder: (context, value, child) => (value == null ||
                    value == SearchState.loading ||
                    (value == SearchState.success &&
                        (context.read<HomeProvider>().users == null ||
                            context.read<HomeProvider>().users!.isEmpty)))
                ? const Spacer()
                : SizedBox(),
            selector: (p0, p1) {
              return p1.searchState;
            },
          ),
          Consumer<HomeProvider>(
            builder: (context, value, child) {
              if (value.searchState == SearchState.loading) {
                return Loading();
              } else if (value.searchState == SearchState.success &&
                  (value.users == null || value.users!.isEmpty)) {
                return Text(
                  "User Not Found!",
                  style: TextStyle(color: Colors.white, fontSize: 22.sp),
                );
              } else {
                return Expanded(
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return UserItem(value.users![index],value);
                        },
                        separatorBuilder: (context, index) => SizedBox(
                              height: 15.h,
                            ),
                        itemCount: value.users?.length ?? 0));
              }
            },
          ),
          Selector<HomeProvider, SearchState?>(
            builder: (context, value, child) => (value == SearchState.loading ||
                    (value == SearchState.success &&
                        (context.read<HomeProvider>().users == null ||
                            context.read<HomeProvider>().users!.isEmpty)))
                ? const Spacer()
                : SizedBox(),
            selector: (p0, p1) {
              return p1.searchState;
            },
          ),
        ],
      ),
    );
  }
}
