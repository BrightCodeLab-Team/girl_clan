import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/firebase_options.dart';
import 'package:girl_clan/locator.dart';
import 'package:girl_clan/ui/auth/splash_screen.dart';
import 'package:girl_clan/ui/home/home_view_model.dart';
import 'package:girl_clan/ui/password/change_password_screen.dart';
import 'package:girl_clan/ui/profile/profile_screen.dart';
import 'package:girl_clan/ui/profile/profile_view_model.dart';
import 'package:girl_clan/ui/root_screen/root_screen.dart';
import 'package:girl_clan/ui/root_screen/root_view_model.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupLocator();
  // runApp(
  //   DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp()),
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => RootScreenViewModel()),
            ChangeNotifierProvider(create: (_) => HomeViewModel()),
            ChangeNotifierProvider(create: (_) => ProfileViewModel()),
          ],
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'GirlClan',
            useInheritedMediaQuery: true,
            defaultTransition: Transition.leftToRight,
            // locale: DevicePreview.locale(context),
            // builder: DevicePreview.appBuilder,
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
            home: SplashScreen(),
            // StreamBuilder(
            //   stream: FirebaseAuth.instance.authStateChanges(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const Center(child: CircularProgressIndicator());
            //     }
            //     if (snapshot.data != null) {
            //       return RootScreen();
            //     }
            //     return SplashScreen();
            //   },
            // ),
          ),
        );
      },
    );
  }
}
