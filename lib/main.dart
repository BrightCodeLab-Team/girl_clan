// ignore_for_file: sort_child_properties_last, deprecated_member_use, library_private_types_in_public_api

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Keep this for GetMaterialApp and Get.to()
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/firebase_options.dart';
import 'package:girl_clan/locator.dart';
import 'package:girl_clan/ui/add_event/add_event_view_model.dart';
import 'package:girl_clan/ui/auth/sign_up/sign_up_view_model.dart';
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
            ChangeNotifierProvider(create: (context) => SignUpViewModel()),
          ],
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'GirlClan',
            useInheritedMediaQuery: true,
            defaultTransition: Transition.leftToRight,
            theme: ThemeData(
              checkboxTheme: CheckboxThemeData(
                side: BorderSide(
                  color: Colors.white,
                  width: 2,
                ), // border color & thickness
                checkColor: MaterialStateProperty.all(whiteColor),
              ),

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

// // import 'package:flutter/material.dart';
// // import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'WebView JS Injection Demo',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: WebViewDemo(),
//     );
//   }
// }

// class WebViewDemo extends StatefulWidget {
//   @override
//   _WebViewDemoState createState() => _WebViewDemoState();
// }

// class _WebViewDemoState extends State<WebViewDemo> {
//   InAppWebViewController? webViewController;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('JS Injection Demo'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.play_arrow),
//             onPressed: () async {
//               await webViewController?.evaluateJavascript(
//                 source: """
//                 document.getElementById('myInput').value = 'Hello from Flutter!';
//                 document.getElementById('myButton').click();
//               """,
//               );
//             },
//           ),
//         ],
//       ),
//       body: InAppWebView(
//         initialUrlRequest: URLRequest(url: WebUri("https://www.youtube.com")),
//         onWebViewCreated: (controller) {
//           webViewController = controller;
//         },
//       ),
//     );
//   }
// }
