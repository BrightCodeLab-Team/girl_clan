// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/route_manager.dart';
// import 'package:girl_clan/core/constants/app_assest.dart';
// import 'package:girl_clan/core/constants/colors.dart';
// import 'package:girl_clan/core/constants/text_style.dart';
// import 'package:girl_clan/custom_widget/custom_button.dart';
// import 'package:girl_clan/ui/auth/login/login_view_model.dart';
// import 'package:girl_clan/ui/options/chat/chat_screen.dart';
// import 'package:girl_clan/ui/options/events/events_screen.dart';
// import 'package:girl_clan/ui/options/forums/forums_screen.dart';
// import 'package:girl_clan/ui/profile/profile_screen.dart';
// import 'package:provider/provider.dart';

// class OptionsScreen extends StatelessWidget {
//   const OptionsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => LoginViewModel(),
//       child: Consumer<LoginViewModel>(
//         builder: (context, viewModel, child) {
//           return Scaffold(
//             body: Container(
//               height:
//                   MediaQuery.of(
//                     context,
//                   ).size.height, // Explicitly set height if not already
//               width:
//                   MediaQuery.of(
//                     context,
//                   ).size.width, // Explicitly set width if not already
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image: AssetImage(AppAssets().optionImage),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               // The key change is wrapping the inner Padding/Column
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15),
//                 child: Column(
//                   // This Column needs to know its height
//                   children: [
//                     20.verticalSpace,
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           "user name ",
//                           style: style16.copyWith(color: whiteColor),
//                         ),
//                         Row(
//                           children: [
//                             Icon(Icons.location_on_outlined, color: whiteColor),
//                             2.horizontalSpace, // Added missing horizontalSpace
//                             Text(
//                               "Dublin,Ireland",
//                               style: style20.copyWith(color: whiteColor),
//                             ),
//                           ],
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Get.to(ProfileScreen());
//                           },
//                           child: CircleAvatar(
//                             radius: 15.r,
//                             backgroundImage: AssetImage(AppAssets().appLogo),
//                           ),
//                         ),
//                       ],
//                     ),
//                     100.verticalSpace,
//                     // Use Expanded to make the following content take available space
//                     Expanded(
//                       child: Center(
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 10),
//                           child: Column(
//                             mainAxisAlignment:
//                                 MainAxisAlignment
//                                     .center, // Center buttons vertically
//                             children: [
//                               Center(
//                                 child: CustomButton(
//                                   onTap: () {
//                                     Get.to(ChatScreen());
//                                   },
//                                   text: "Chat",
//                                   backgroundColor: primaryColor,
//                                 ),
//                               ),
//                               20.verticalSpace,
//                               Center(
//                                 child: CustomButton(
//                                   onTap: () {
//                                     Get.to(ForumsScreen());
//                                   },
//                                   text: "Forums",
//                                   backgroundColor: secondaryColor,
//                                 ),
//                               ),
//                               20.verticalSpace,
//                               Center(
//                                 child: CustomButton(
//                                   onTap: () {
//                                     Get.to(EventsScreen());
//                                   },
//                                   text: "Events",
//                                   backgroundColor: orangeColor,
//                                 ),
//                               ),
//                               80.verticalSpace,
//                               Container(
//                                 height: 40,
//                                 width: MediaQuery.of(context).size.width * 1,
//                                 decoration: BoxDecoration(
//                                   color: transparentColor,
//                                   border: Border.all(color: whiteColor),
//                                   borderRadius: BorderRadius.circular(10.r),
//                                 ),
//                                 child: Padding(
//                                   padding: EdgeInsets.symmetric(
//                                     horizontal: 20,
//                                     vertical: 5,
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         "Tell us your suggestion",
//                                         style: style16.copyWith(
//                                           color: whiteColor,
//                                         ),
//                                       ),
//                                       Icon(Icons.mic, color: whiteColor),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
