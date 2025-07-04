import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Keep this for GetMaterialApp and Get.to()
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/firebase_options.dart';
import 'package:girl_clan/locator.dart';
import 'package:girl_clan/ui/add_event/add_event_view_model.dart';
import 'package:girl_clan/ui/auth/splash_screen.dart';
import 'package:girl_clan/ui/chat/new_chat/chat_view_model.dart'; // This is correct
import 'package:girl_clan/ui/home/home_view_model.dart';
import 'package:girl_clan/ui/password/password_view_model.dart';
import 'package:girl_clan/ui/profile/profile_view_model.dart';
import 'package:girl_clan/ui/root_screen/root_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Confirm your design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => RootScreenViewModel()),
            ChangeNotifierProvider(create: (context) => HomeViewModel()),
            ChangeNotifierProvider(create: (context) => ProfileViewModel()),
            ChangeNotifierProvider(create: (context) => AddEventViewModel()),
            ChangeNotifierProvider(create: (context) => PasswordViewModel()),
            ChangeNotifierProvider(create: (context) => ChatViewModel()),
          ],
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'GirlClan',
            useInheritedMediaQuery: true,
            defaultTransition: Transition.leftToRight,
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
            home: SplashScreen(), // Your main chat list screen
          ),
        );
      },
    );
  }
}
