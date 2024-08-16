import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:tik_tok_clon/constants.dart';
import 'package:tik_tok_clon/context_utility.dart';
import 'package:tik_tok_clon/providers/home_provider.dart';
import 'package:tik_tok_clon/sheared/styles/colors.dart';
import 'package:tik_tok_clon/uni_services.dart';
import 'package:tik_tok_clon/views/screens/auth/login_screen.dart';
import 'firebase_options.dart';
import 'views/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UniServices.init();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(create: (context) => HomeProvider(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print(ContextUtility.navigatorState == null);
    print(ContextUtility.context == null);
    return ScreenUtilInit(
      designSize: Size(
          MediaQuery.sizeOf(context).width, MediaQuery.sizeOf(context).height),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
        navigatorKey: ContextUtility.navigatorKey,
        debugShowCheckedModeBanner: false,
        home: (firebaseAuth.currentUser != null) ? HomeScreen() : LoginScreen(),
        theme:
            ThemeData.dark().copyWith(scaffoldBackgroundColor: backgroundColor),
      ),
    );
  }
}
