// ignore_for_file: unused_field, use_key_in_widget_constructors, must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/core/model/event_model.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/custom_widget/loaders/join_event_loader.dart';
import 'package:girl_clan/custom_widget/loaders/leave_event_loader.dart';
import 'package:girl_clan/ui/chat/new_chat/chat_screen.dart';
import 'package:girl_clan/ui/chat/new_chat/chat_view_model.dart';
import 'package:girl_clan/ui/home/home_view_model.dart';
import 'package:girl_clan/ui/home/map/event_map_screen.dart';
import 'package:girl_clan/ui/root_screen/root_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class EventsDetailsScreen extends StatefulWidget {
  EventModel? eventModel;
  EventsDetailsScreen({this.eventModel});

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

  bool get isHost {
    if (widget.eventModel?.hostUserId == null) return false;
    final model = Provider.of<HomeViewModel>(context, listen: false);
    return model.currentUser.currentUser?.uid == widget.eventModel!.hostUserId;
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
    Get.to(
      () => JoiningEventLoaderScreen(
        processCall: () async {
          await model.joinEvent(widget.eventModel!.id!);
          await model.updateSeatCount(widget.eventModel!.id!, bookedSeats + 1);
          await fetchInitialData();
          return true;
        },
        eventName: '${widget.eventModel!.eventName}',
        eventTime: '${widget.eventModel!.startTime}',
        eventModel: widget.eventModel!,
        bookedSeats: bookedSeats,
        totalSeats: totalSeats,
      ),
    );
  }

  Future<void> handleLeave(HomeViewModel model) async {
    await Get.to(
      LeaveEventLoader(
        onFinished: () async {
          await model.leaveEvent(widget.eventModel!.id!);
          await model.updateSeatCount(widget.eventModel!.id!, bookedSeats - 1);
          await fetchInitialData();
        },
      ),
    );
  }

  Future<void> _endEvent(HomeViewModel model) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('End Event?'),
            content: Text(
              'Are you sure you want to end this event? This cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'End Event',
                  style: TextStyle(color: secondaryColor),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await model.endEvent(widget.eventModel!.id!);
        model.upComingEvents();
        model.getAllEvent(model.tabs[model.selectedTabIndex]['text']);
        model.getCurrentUserEvents();
        Get.offAll(() => RootScreen());
      } catch (e) {
        Get.snackbar('Error', 'Failed to end event: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final int availableSeats = totalSeats - bookedSeats;

    return Consumer<HomeViewModel>(
      builder:
          (context, model, child) => WillPopScope(
            onWillPop: () async {
              model.upComingEvents();
              model.getAllEvent(model.tabs[model.selectedTabIndex]['text']);
              model.getCurrentUserEvents();
              Get.offAll(() => RootScreen());
              return false;
            },
            child: Scaffold(
              body:
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Event Image
                            Stack(
                              children: [
                                Container(
                                  height: 275.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        "${widget.eventModel!.imageUrl}",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // Back Button
                                Positioned(
                                  top: 30,
                                  left: 16,
                                  child: IconButton(
                                    onPressed: () {
                                      model.upComingEvents();
                                      model.getAllEvent(
                                        model.tabs[model
                                            .selectedTabIndex]['text'],
                                      );
                                      model.getCurrentUserEvents();
                                      Get.offAll(RootScreen());
                                    },
                                    icon: Icon(
                                      Icons.arrow_back_ios_new,
                                      size: 30,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                // Share Button
                                Positioned(
                                  top: 40,
                                  right: 20,
                                  child: IconButton(
                                    onPressed: () async {
                                      final eventName =
                                          widget.eventModel?.eventName ??
                                          "Event";
                                      final eventDesc =
                                          widget.eventModel?.description ?? "";
                                      final eventLink =
                                          "https://girlclan.com/event/${widget.eventModel?.id}";
                                      // Replace with your real website link if you have one

                                      final shareText =
                                          "$eventName\n\n$eventDesc\n\nJoin here: $eventLink";

                                      await Share.share(shareText);
                                    },
                                    icon: Icon(
                                      Icons.share,
                                      size: 28,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ],
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
                                            "$availableSeats Available",
                                            style: style14B.copyWith(
                                              fontSize: 10,
                                              color: primaryColor,
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
                                        "${widget.eventModel?.date}" ?? '',
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
                                          borderRadius: BorderRadius.circular(
                                            99,
                                          ),
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
                                      Flexible(
                                        child: Text(
                                          widget.eventModel?.location ?? '',
                                          style: style14.copyWith(fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
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
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      height: 180.h,
                                      width: double.infinity,
                                      child: Stack(
                                        children: [
                                          GoogleMap(
                                            initialCameraPosition:
                                                CameraPosition(
                                                  target: LatLng(
                                                    widget
                                                            .eventModel
                                                            ?.locationLat ??
                                                        0,
                                                    widget
                                                            .eventModel
                                                            ?.locationLng ??
                                                        0,
                                                  ),
                                                  zoom: 12,
                                                ),
                                            zoomControlsEnabled: false,
                                            myLocationEnabled: false,
                                            markers: {
                                              if (widget
                                                          .eventModel
                                                          ?.locationLat !=
                                                      null &&
                                                  widget
                                                          .eventModel
                                                          ?.locationLng !=
                                                      null)
                                                Marker(
                                                  markerId: MarkerId('event'),
                                                  position: LatLng(
                                                    widget
                                                        .eventModel!
                                                        .locationLat!,
                                                    widget
                                                        .eventModel!
                                                        .locationLng!,
                                                  ),
                                                ),
                                            },
                                            onMapCreated: (_) {},
                                          ),
                                          Positioned.fill(
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () {
                                                  if (widget
                                                              .eventModel
                                                              ?.locationLat !=
                                                          null &&
                                                      widget
                                                              .eventModel
                                                              ?.locationLng !=
                                                          null) {
                                                    Get.to(
                                                      () => EventMapScreen(
                                                        lat:
                                                            widget
                                                                .eventModel!
                                                                .locationLat!,
                                                        lng:
                                                            widget
                                                                .eventModel!
                                                                .locationLng!,
                                                      ),
                                                    );
                                                  } else {
                                                    Get.snackbar(
                                                      "Location",
                                                      "Location not available",
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  50.verticalSpace,

                                  /// Button Section - Updated based on host status
                                  if (isHost)
                                    // Host sees only End Event button
                                    model.state == ViewState.busy
                                        ? Container(
                                          height: 45.h,
                                          decoration: BoxDecoration(
                                            color: secondaryColor,
                                            borderRadius: BorderRadius.circular(
                                              99,
                                            ),
                                          ),
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: whiteColor,
                                            ),
                                          ),
                                        )
                                        : CustomButton(
                                          onTap: () => _endEvent(model),
                                          text: 'End Event',
                                          backgroundColor: secondaryColor,
                                        )
                                  else if (!isJoined &&
                                      bookedSeats < totalSeats)
                                    // Regular user can join if seats available
                                    CustomButton(
                                      onTap: () => handleJoin(model),
                                      text: 'Join Event',
                                      backgroundColor: primaryColor,
                                    )
                                  else if (!isJoined &&
                                      bookedSeats >= totalSeats)
                                    // Event is full
                                    CustomButton(
                                      onTap: () {},
                                      text: 'All seats are booked!',
                                      backgroundColor: secondaryColor,
                                    )
                                  else
                                    // User has joined - show leave button
                                    Column(
                                      children: [
                                        20.verticalSpace,
                                        CustomButton(
                                          onTap: () => handleLeave(model),
                                          text: 'Leave Event',
                                          backgroundColor: secondaryColor,
                                        ),
                                      ],
                                    ),

                                  20.verticalSpace,
                                  if (!isHost) // Only show message host button for non-hosts
                                    CustomButton(
                                      onTap: () {
                                        if (widget.eventModel!.hostUserId !=
                                                null &&
                                            widget
                                                .eventModel!
                                                .hostUserId!
                                                .isNotEmpty) {
                                          Get.to(
                                            () => ChangeNotifierProvider(
                                              create:
                                                  (_) => ChatViewModel(
                                                    chatTitle:
                                                        widget
                                                            .eventModel!
                                                            .hostName ??
                                                        '',
                                                    chatImageUrl:
                                                        widget
                                                            .eventModel!
                                                            .hostImage ??
                                                        '',
                                                    isGroupChat: false,
                                                    receiverId:
                                                        widget
                                                            .eventModel!
                                                            .hostUserId ??
                                                        '',
                                                  ),
                                              child: ChatScreen(
                                                chatTitle:
                                                    widget
                                                        .eventModel!
                                                        .hostName ??
                                                    '',
                                                chatImageUrl:
                                                    widget
                                                        .eventModel!
                                                        .hostImage ??
                                                    '',
                                                isGroupChat: false,
                                              ),
                                            ),
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
                                      text: 'Message Host',
                                      backgroundColor: Color(0xff2B2B2B),
                                    ),
                                  50.verticalSpace,
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
            ),
          ),
    );
  }
}
