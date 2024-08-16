import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tik_tok_clon/constants.dart';
import 'package:tik_tok_clon/views/screens/add_video_bottom_sheet.dart';
import 'package:tik_tok_clon/views/screens/profile_screen.dart';
import 'package:tik_tok_clon/views/widgets/custom_add_icon.dart';

import '../../providers/home_provider.dart';
import '../../sheared/styles/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider()..getCurrentUser(),
      builder: (context, child) => Scaffold(
        bottomNavigationBar: Consumer<HomeProvider>(
          builder: (context, provider, child) => BottomNavigationBar(
            currentIndex: provider.currentTabIndex,
            onTap: (value) {
              if (value == 2) {
                showBottomSheet(
                    context: context,
                    builder: (context) {
                      return AddVideoBottomSheet();
                    },
                    showDragHandle: true);
              } else if (value == 4) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileScreen(firebaseAuth.currentUser?.uid ?? "",provider),
                    ));
              } else {
                provider.changeTab(value);
              }
            },
            backgroundColor: backgroundColor,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    size: 30.sp,
                  ),
                  label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    size: 30.sp,
                  ),
                  label: "Search"),
              const BottomNavigationBarItem(icon: CustomAddIcon(), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.message,
                    size: 30.sp,
                  ),
                  label: "Message"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    size: 30.sp,
                  ),
                  label: "Profile"),
            ],
          ),
        ),
        body: SafeArea(
          child: Consumer<HomeProvider>(
            builder: (context, value, child) => pages[value.currentTabIndex],
          ),
        ),
      ),
    );
  }
}
