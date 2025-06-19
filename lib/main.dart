import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/firebase_options.dart';
import 'package:girl_clan/ui/auth/sign_up/sign_up_screen.dart';
import 'package:girl_clan/ui/root_screen/root_screen.dart';
import 'package:girl_clan/ui/root_screen/root_view_model.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        return ChangeNotifierProvider(
          create: (context) => RootScreenViewModel(),
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
            home: SignUpScreen(),
            // StreamBuilder(
            //   stream: FirebaseAuth.instance.authStateChanges(),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.waiting) {
            //       return const Center(child: CircularProgressIndicator());
            //     }
            //     if (snapshot.data != null) {
            //       return RootScreen();
            //     }
            //     return SignUpScreen();
            //   },
            // ),
          ),
        );
      },
    );
  }
}
/*
  Future<void> LoginUser() async {
    final User = auth.currentUser;
    try {
      // setState(ViewState.busy);
      loading = true;
      notifyListeners();

      await auth
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then(
        (value) {
          // setState(ViewState.idle);
          loading = false;
          notifyListeners();

        Get.snackbar("Login Done","user verified" );
          Get.to(
          RootScreen()
          );
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => HomeScreen(),
          //   ),
          // );
        },
      ).onError(
        (error, stackTrace) {
          //  setState(ViewState.idle);
          loading = false;
          notifyListeners();

          // normal print statement slow app use debug print
          debugPrint('login failed');
         Get.snackbar("Error","Login Failed");
        },
      );
    } catch (e) {
      // for de bugging this will be display in console
      print("User can not found $e");
      // setState(ViewState.idle);
      loading = false;
      notifyListeners();
    }
  }
  */