// ignore_for_file: unused_field, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/model/event_model.dart';
import 'package:girl_clan/core/services/data_base_services.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/custom_widget/loaders/join_event_loader.dart';
import 'package:girl_clan/custom_widget/loaders/leave_event_loader.dart';
import 'package:girl_clan/ui/chat/new_chat/chat_screen.dart';
import 'package:girl_clan/ui/chat/new_chat/chat_view_model.dart';
import 'package:girl_clan/ui/home/home_view_model.dart';
import 'package:provider/provider.dart';

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

    // loader screen pe jao aur process waha chalega
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
        // onClose: () async {
        //   await fetchInitialData();
        //   Get.back(); // ✅ just go back
        // },
      ),
    );
  }

  Future<void> handleLeave(HomeViewModel model) async {
    await Get.to(
      LeaveEventLoader(
        onFinished: () async {
          await model.leaveEvent(widget.eventModel!.id!);
          await model.updateSeatCount(widget.eventModel!.id!, bookedSeats - 1);
          await fetchInitialData(); // refresh data
        },
      ),
    );
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
                          Stack(
                            children: [
                              SizedBox(
                                height: 275.h,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  ),
                                  child: Image.network(
                                    widget.eventModel!.imageUrl ??
                                        "https://as2.ftcdn.net/jpg/01/24/14/21/1000_F_124142194_1n6MwMGUm9LQOSoa63jBfLlW0E2KNi7E.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios_new,
                                    size: 30,
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
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomButton(
                                              onTap: () {
                                                if (widget
                                                            .eventModel!
                                                            .hostUserId !=
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
                                              text: 'Message to Host',
                                              backgroundColor: Color(
                                                0xff2B2B2B,
                                              ),
                                            ),
                                          ),
                                          10.horizontalSpace,
                                          Expanded(
                                            child: CustomButton(
                                              onTap: () async {
                                                try {
                                                  final db = DatabaseServices();

                                                  final groupId = await db
                                                      .createOrGetGroupForEvent(
                                                        widget.eventModel!,
                                                      );

                                                  print(
                                                    'Joined group with id: $groupId',
                                                  );

                                                  Get.to(
                                                    () => ChangeNotifierProvider(
                                                      create:
                                                          (_) => ChatViewModel(
                                                            chatTitle:
                                                                widget
                                                                    .eventModel
                                                                    ?.eventName ??
                                                                '',
                                                            chatImageUrl:
                                                                widget
                                                                    .eventModel
                                                                    ?.imageUrl ??
                                                                '',
                                                            isGroupChat: true,
                                                            groupId: groupId,
                                                          ),
                                                      child: ChatScreen(
                                                        chatTitle:
                                                            widget
                                                                .eventModel
                                                                ?.eventName ??
                                                            '',
                                                        chatImageUrl:
                                                            widget
                                                                .eventModel
                                                                ?.imageUrl ??
                                                            '',
                                                        isGroupChat: true,
                                                      ),
                                                    ),
                                                  );
                                                } catch (e) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Failed to join group: $e',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },

                                              text: 'Join Group',
                                              backgroundColor: primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),

                                      20.verticalSpace,
                                      CustomButton(
                                        onTap: () => handleLeave(model),
                                        text: 'Leave Event',
                                        backgroundColor: secondaryColor,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          50.verticalSpace,
                        ],
                      ),
                    ),
          ),
    );
  }
}
