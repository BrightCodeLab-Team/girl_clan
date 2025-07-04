// ignore_for_file: unused_field, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/app_assets.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/model/event_model.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/chat/new_chat/chat_screen.dart';
import 'package:girl_clan/ui/home/home_view_model.dart';
import 'package:provider/provider.dart';

class EventsDetailsScreen extends StatefulWidget {
  EventModel? eventModel;
  EventsDetailsScreen({required this.eventModel});

  @override
  State<EventsDetailsScreen> createState() => _EventsDetailsScreenState();
}

class _EventsDetailsScreenState extends State<EventsDetailsScreen> {
  bool isJoined = false;
  bool isLoading = false;
  int bookedSeats = 0;
  int totalSeats = 0;

  @override
  void initState() {
    super.initState();
    totalSeats = int.tryParse(widget.eventModel?.capacity ?? '30') ?? 30;
    bookedSeats = int.tryParse(widget.eventModel?.joiningPeople ?? '0') ?? 0;

    checkIfJoined();
  }

  void checkIfJoined() async {
    final model = Provider.of<HomeViewModel>(context, listen: false);
    final joined = await model.hasUserJoined(widget.eventModel!.id!);
    setState(() {
      isJoined = joined;
    });
  }

  Future<void> fetchInitialData() async {
    final model = Provider.of<HomeViewModel>(context, listen: false);
    final joined = await model.hasUserJoined(widget.eventModel!.id!);
    final seatData = await model.getEventSeatData(widget.eventModel!.id!);

    setState(() {
      isJoined = joined;
      totalSeats = seatData['capacity']!;
      bookedSeats = seatData['joined']!;
    });
  }

  Future<void> handleJoin(HomeViewModel model) async {
    if (bookedSeats >= totalSeats) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: Text("Seats Full"),
              content: Text("Sorry, no seats are available."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
      );
      return;
    }

    setState(() => isLoading = true);
    await model.joinEvent(widget.eventModel!.id!);
    await model.updateSeatCount(widget.eventModel!.id!, bookedSeats + 1);
    await fetchInitialData();
    setState(() => isLoading = false);
  }

  Future<void> handleLeave(HomeViewModel model) async {
    setState(() => isLoading = true);
    await model.leaveEvent(widget.eventModel!.id!);
    await model.updateSeatCount(widget.eventModel!.id!, bookedSeats - 1);
    await fetchInitialData();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final int availableSeats = totalSeats - bookedSeats;

    return Consumer<HomeViewModel>(
      builder:
          (context, model, child) => Scaffold(
            body:
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Event Image
                          SizedBox(
                            height: 275.h,
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                AppAssets().loginImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          10.verticalSpace,

                          /// Event Details
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Top Row
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        widget.eventModel?.eventName ?? '',
                                        style: style18B,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "$bookedSeats Booked",
                                          style: style14B.copyWith(
                                            color: primaryColor,
                                          ),
                                        ),
                                        Text(
                                          "$availableSeats Available",
                                          style: style14B.copyWith(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                10.verticalSpace,

                                /// Date / Time / Category
                                Row(
                                  children: [
                                    Text(
                                      widget.eventModel?.date ?? '',
                                      style: style14.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    4.horizontalSpace,
                                    Container(
                                      height: 10.h,
                                      width: 1.w,
                                      color: blackColor,
                                    ),
                                    4.horizontalSpace,
                                    Text(
                                      widget.eventModel?.startTime ?? '',
                                      style: style14.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.circular(99),
                                      ),
                                      child: Text(
                                        widget.eventModel?.category ?? '',
                                        style: style14B.copyWith(
                                          color: whiteColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                10.verticalSpace,

                                /// Location
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 15.h,
                                    ),
                                    4.horizontalSpace,
                                    Expanded(
                                      child: Text(
                                        widget.eventModel?.location ?? '',
                                        style: style14.copyWith(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                20.verticalSpacingRadius,

                                /// About
                                Text('About Event', style: style16B),
                                10.verticalSpace,
                                Text(
                                  widget.eventModel?.description ?? '',
                                  style: style14.copyWith(fontSize: 13),
                                ),
                                20.verticalSpace,

                                /// Google Map Placeholder
                                Text('Location', style: style16B),
                                10.verticalSpace,
                                Container(
                                  height: 180.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Center(
                                      child: Text(
                                        'Google Map Placeholder',
                                        style: style14.copyWith(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                50.verticalSpace,

                                /// Button Section
                                if (!isJoined)
                                  CustomButton(
                                    onTap: () => handleJoin(model),
                                    text: 'Join Event',
                                    backgroundColor: primaryColor,
                                  )
                                else
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          onTap: () {
                                            if (widget.eventModel!.hostUserId !=
                                                    null &&
                                                widget
                                                    .eventModel!
                                                    .hostUserId!
                                                    .isNotEmpty) {
                                              Get.to(
                                                () => ChatScreen(
                                                  chatTitle:
                                                      widget
                                                          .eventModel!
                                                          .hostName ??
                                                      'Host',
                                                  chatImageUrl:
                                                      widget
                                                          .eventModel!
                                                          .hostImage ??
                                                      '',
                                                  isGroupChat: false,
                                                ),
                                              );

                                              print(
                                                "user hostUserName: ${widget.eventModel?.hostName}",
                                              );

                                              print(
                                                "user hostUserId: ${widget.eventModel?.hostUserId}",
                                              );

                                              print(
                                                "user id: ${widget.eventModel?.id}",
                                              );
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Host info not available.',
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          text: 'Join Chat',
                                          backgroundColor: secondaryColor,
                                        ),
                                      ),
                                      10.horizontalSpace,
                                      Expanded(
                                        child: CustomButton(
                                          onTap: () => handleLeave(model),
                                          text: 'Leave Event',
                                          backgroundColor: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                50.verticalSpace,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
          ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:girl_clan/core/constants/app_assets.dart';
// import 'package:girl_clan/core/constants/colors.dart';
// import 'package:girl_clan/core/constants/text_style.dart';
// import 'package:girl_clan/core/model/event_model.dart';
// import 'package:girl_clan/custom_widget/custom_button.dart';
// import 'package:girl_clan/ui/chat/new_chat/chat_screen.dart';
// import 'package:girl_clan/ui/home/home_view_model.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';

// class EventsDetailsScreen extends StatefulWidget {
//   EventModel? eventModel;
//   EventsDetailsScreen({required this.eventModel});
//   @override
//   State<EventsDetailsScreen> createState() => _EventsDetailsScreenState();
// }

// class _EventsDetailsScreenState extends State<EventsDetailsScreen> {
//   final CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );

//   final Set<Marker> _markers = {
//     Marker(
//       markerId: MarkerId('eventLocation'),
//       position: LatLng(37.42796133580664, -122.085749655962),
//       infoWindow: InfoWindow(title: 'Event Location'),
//     ),
//   };

//   bool isJoined = false; // Track if user has joined the event

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<HomeViewModel>(
//       builder:
//           (context, model, child) => Scaffold(
//             body: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: 275.h,
//                     width: double.infinity,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(20),
//                       child: Image.asset(
//                         AppAssets().loginImage,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   10.verticalSpace,
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 10.w),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "${widget.eventModel!.eventName}" ?? "",
//                               style: style18B.copyWith(),
//                             ),
//                             Spacer(),
//                             Row(
//                               children: [
//                                 Text(
//                                   '06/24',
//                                   style: style14B.copyWith(color: primaryColor),
//                                 ),
//                                 4.horizontalSpace,
//                                 5.verticalSpace,
//                                 Text(
//                                   'Available',
//                                   style: style14B.copyWith(fontSize: 10),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         10.verticalSpace,
//                         Row(
//                           children: [
//                             Text(
//                               '03/23/2025',
//                               style: style14.copyWith(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             4.horizontalSpace,
//                             Container(
//                               height: 10.h,
//                               width: 1.w,
//                               color: blackColor,
//                             ),
//                             4.horizontalSpace,
//                             Text(
//                               '09:00 PM',
//                               style: style14.copyWith(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                             Spacer(),
//                             Container(
//                               height: 27.h,
//                               width: 72,
//                               decoration: BoxDecoration(
//                                 color: primaryColor,
//                                 borderRadius: BorderRadius.circular(99),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   "${widget.eventModel!.category}" ?? "",

//                                   style: style14B.copyWith(color: whiteColor),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         10.verticalSpace,

//                         ///
//                         ///  location
//                         ///
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Icon(Icons.location_on_outlined, size: 15.h),
//                             1.horizontalSpace,
//                             Text(
//                               "${widget.eventModel!.location}" ?? "",
//                               style: style14.copyWith(fontSize: 12),
//                             ),
//                           ],
//                         ),
//                         20.verticalSpacingRadius,
//                         Text('About Event', style: style16B.copyWith()),
//                         10.verticalSpace,
//                         Text(
//                           "${widget.eventModel!.description}" ?? "",
//                           style: style14.copyWith(fontSize: 13),
//                         ),
//                         20.verticalSpace,
//                         Text('Location', style: style16B.copyWith()),
//                         10.verticalSpace,

//                         ///
//                         ///      location --> google map
//                         ///
//                         Container(
//                           height: 180.h,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Text(
//                               'Google Map Placeholder',
//                               style: style14.copyWith(color: Colors.grey),
//                               textAlign: TextAlign.center,
//                             ),
//                             // GoogleMap(
//                             //   initialCameraPosition: _kGooglePlex,
//                             //   markers: _markers,
//                             //   mapType: MapType.normal,
//                             //   zoomControlsEnabled: false,
//                             //   myLocationButtonEnabled: false,
//                             // ),
//                           ),
//                         ),
//                         50.verticalSpace,

//                         ///
//                         ///  last button - conditionally show join button or action buttons
//                         ///
//                         if (!isJoined)
//                           CustomButton(
//                             onTap: () {
//                               setState(() {
//                                 isJoined = true;
//                               });
//                             },
//                             text: 'Join Events',
//                             backgroundColor: primaryColor,
//                           ),
//                         if (isJoined)
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: CustomButton(
//                                   onTap: () {
//                                     if (widget.eventModel!.hostUserId != null &&
//                                         widget
//                                             .eventModel!
//                                             .hostUserId!
//                                             .isNotEmpty) {
//                                       Get.to(
//                                         () => ChatScreen(
//                                           chatTitle:
//                                               widget.eventModel!.hostName ??
//                                               'Host',
//                                           chatImageUrl:
//                                               widget.eventModel!.hostImage ??
//                                               "",
//                                           isGroupChat: false,
//                                         ),
//                                       );
//                                     } else {
//                                       ScaffoldMessenger.of(
//                                         context,
//                                       ).showSnackBar(
//                                         SnackBar(
//                                           content: Text(
//                                             'Host info not available.',
//                                           ),
//                                         ),
//                                       );
//                                     }
//                                   },

//                                   text: 'Join Chat',
//                                   backgroundColor: secondaryColor,
//                                 ),
//                               ),
//                               10.horizontalSpace,
//                               Expanded(
//                                 child: CustomButton(
//                                   onTap: () {
//                                     setState(() {
//                                       isJoined = false;
//                                     });
//                                   },
//                                   text: 'Leave Event',
//                                   backgroundColor: primaryColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         50.verticalSpace,
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//     );
//   }
// }
