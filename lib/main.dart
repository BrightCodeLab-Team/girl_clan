import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/ui/auth/login/login_screen.dart';
import 'package:girl_clan/ui/auth/sign_up/sign_up_screen.dart';
import 'package:girl_clan/ui/auth/splash_screen.dart';
import 'package:girl_clan/core/constants/colors.dart';

void main() => runApp(
  DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp()),
  // const MyApp(),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sportat',
          useInheritedMediaQuery: true,
          defaultTransition: Transition.leftToRight,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              backgroundColor: transparentColor,
              shadowColor: transparentColor,
              surfaceTintColor: transparentColor,
            ),
            scaffoldBackgroundColor: backGroundColor,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true,
          ),
          home: SignUpScreen(),
        );
      },
    );
  }
}
