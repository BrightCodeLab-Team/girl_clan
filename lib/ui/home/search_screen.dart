// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/route_manager.dart';
// import 'package:girl_clan/core/constants/auth_text_feild.dart';
// import 'package:girl_clan/core/constants/colors.dart';
// import 'package:girl_clan/core/constants/text_style.dart';
// import 'package:girl_clan/core/model/event_model.dart';
// import 'package:girl_clan/core/model/up_coming_evnts.dart';
// import 'package:girl_clan/custom_widget/custom_button.dart';

// import 'package:girl_clan/ui/home/events_details_screen.dart';
// import 'package:girl_clan/ui/home/home_view_model.dart';

// import 'package:provider/provider.dart';

// class SearchScreen extends StatelessWidget {
//   const SearchScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (context) => HomeViewModel(),
//       child: Consumer<HomeViewModel>(
//         builder:
//             (context, model, child) => Scaffold(
//               appBar: AppBar(
//                 leading: Padding(
//                   padding: const EdgeInsets.only(left: 15.0),
//                   child: CircleAvatar(
//                     backgroundColor: thinGreyColor,
//                     child: GestureDetector(
//                       onTap: () {
//                         navigator!.pop(context);
//                       },
//                       child: Icon(Icons.arrow_back_ios_new_outlined),
//                     ),
//                   ),
//                 ),
//                 title: TextFormField(
//                   decoration: customHomeAuthField.copyWith(
//                     suffixIcon: Padding(
//                       padding: EdgeInsets.all(10),
//                       child: CircleAvatar(
//                         backgroundColor: whiteColor,
//                         child: IconButton(
//                           icon: Icon(Icons.tune),
//                           onPressed: () {
//                             showModalBottomSheet(
//                               context: context,
//                               isScrollControlled: true,
//                               backgroundColor: Colors.transparent,
//                               builder: (BuildContext context) {
//                                 return CustomFilterBottomSheet();
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               body: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 15),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     10.verticalSpace,
//                     // search found
//                     Row(
//                       children: [
//                         Text(
//                           'search found:',
//                           style: style14.copyWith(fontSize: 12),
//                         ),
//                         2.horizontalSpace,
//                         Text(
//                           '06',
//                           style: style14B.copyWith(
//                             fontSize: 13,
//                             color: primaryColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                     10.verticalSpace,

//                     //  search result
//                     Expanded(
//                       child: GridView.builder(
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               childAspectRatio: 0.68,
//                               crossAxisSpacing: 10,
//                               mainAxisSpacing: 10,
//                             ),
//                         itemCount: model.UpComingEventsList.length,
//                         shrinkWrap: true,
//                         scrollDirection: Axis.vertical,

//                         itemBuilder: (BuildContext context, int index) {
//                           return GestureDetector(
//                             onTap: () {
//                               Get.to(EventsDetailsScreen());
//                             },
//                             child: CustomSearchResultCard(
//                               eventModel: model.UpComingEventsList[index],
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//       ),
//     );
//   }
// }
