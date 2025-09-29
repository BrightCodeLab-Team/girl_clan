// ignore_for_file: unused_field, use_key_in_widget_constructors, must_be_immutable, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/strings.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/enums/view_state_model.dart';
import 'package:girl_clan/core/model/groups_model.dart';
import 'package:girl_clan/core/services/data_base_services.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/custom_widget/loaders/join_group_loader.dart';
import 'package:girl_clan/custom_widget/loaders/leave_event_loader.dart';
import 'package:girl_clan/ui/chat/new_chat/chat_screen.dart';
import 'package:girl_clan/ui/chat/new_chat/chat_view_model.dart';
import 'package:girl_clan/ui/home/home_view_model.dart';
import 'package:girl_clan/ui/home/map/group_map_screen.dart';
import 'package:girl_clan/ui/root_screen/root_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GroupDetailsScreen extends StatefulWidget {
  GroupsModel? groupsModel;
  GroupDetailsScreen({this.groupsModel});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreennState();
}

class _GroupDetailsScreennState extends State<GroupDetailsScreen> {
  bool isJoined = false;
  bool isLoading = false;

  // Add this getter to check if current user is the group host/admin
  bool get isHost {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser?.uid == widget.groupsModel?.hostUserId;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkIfJoined();
    fetchInitialData();
  }

  void checkIfJoined() async {
    final model = Provider.of<HomeViewModel>(context, listen: false);
    final joined = await model.hasUserJoinedGroup(widget.groupsModel!.id!);
    setState(() {
      isJoined = joined;
    });
  }

  Future<void> fetchInitialData() async {
    setState(() {
      isLoading = true;
    });

    final model = Provider.of<HomeViewModel>(context, listen: false);
    final joined = await model.hasUserJoinedGroup(widget.groupsModel!.id!);

    setState(() {
      isJoined = joined;
      isLoading = false;
    });
  }

  Future<void> handleJoin(HomeViewModel model) async {
    await Get.to(
      () => JoinGroupLoader(
        processCall: () async {
          await model.joinGroup(widget.groupsModel!.id!);
          await fetchInitialData();
          return true;
        },
        eventName: widget.groupsModel?.title ?? '',
        groupsModel: widget.groupsModel!,
      ),
    );
  }

  Future<void> handleLeave(HomeViewModel model) async {
    await Get.to(
      LeaveEventLoader(
        onFinished: () async {
          await model.leaveGroup(widget.groupsModel!.id!);
          await fetchInitialData();
        },
      ),
    );
  }

  Future<void> _deleteGroup(HomeViewModel model) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Group?'),
            content: Text(
              'Are you sure you want to delete this group? This cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Delete', style: TextStyle(color: secondaryColor)),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await model.deleteGroup(widget.groupsModel!.id!);
        model.upComingEvents();
        model.getAllEvent(model.tabs[model.selectedTabIndex]['text']);
        model.getCurrentUserEvents();
        model.groupsData();
        Get.offAll(() => RootScreen());
        Get.snackbar('Success', 'Group deleted successfully');
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete group: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder:
          (context, model, child) => WillPopScope(
            onWillPop: () async {
              model.upComingEvents();
              model.getAllEvent(
                model.tabs[model.selectedTabIndex]['text'],
              ); // Pass "All"
              model.getCurrentUserEvents();
              model.groupsData();
              // Navigate to root screen on back press
              Get.offAll(
                () => RootScreen(),
              ); // 👈 change this to your root screen
              return false; // prevent default back behavior
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
                                      image:
                                          widget.groupsModel!.imageUrl !=
                                                      null &&
                                                  widget
                                                      .groupsModel!
                                                      .imageUrl!
                                                      .isEmpty
                                              ? NetworkImage(
                                                "${widget.groupsModel!.imageUrl}",
                                              )
                                              : AssetImage(
                                                "$staticAssets/SplashScreenImage.png",
                                              ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 30,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      model.upComingEvents();
                                      model.getAllEvent(
                                        model.tabs[model
                                            .selectedTabIndex]['text'],
                                      ); // Pass "All"
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
                                          widget.groupsModel?.title ?? '',
                                          style: style18B,
                                        ),
                                      ),
                                    ],
                                  ),
                                  10.verticalSpace,

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
                                      widget.groupsModel?.category ?? '',
                                      style: style14B.copyWith(
                                        color: whiteColor,
                                      ),
                                    ),
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
                                          widget.groupsModel?.location ?? '',
                                          style: style14.copyWith(fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  20.verticalSpacingRadius,

                                  /// About
                                  Text('About Groups', style: style16B),
                                  10.verticalSpace,
                                  Text(
                                    widget.groupsModel?.description ?? '',
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
                                                            .groupsModel
                                                            ?.locationLat ??
                                                        0,
                                                    widget
                                                            .groupsModel
                                                            ?.locationLng ??
                                                        0,
                                                  ),
                                                  zoom: 12,
                                                ),
                                            zoomControlsEnabled: false,
                                            myLocationEnabled: false,
                                            markers: {
                                              if (widget
                                                          .groupsModel
                                                          ?.locationLat !=
                                                      null &&
                                                  widget
                                                          .groupsModel
                                                          ?.locationLng !=
                                                      null)
                                                Marker(
                                                  markerId: MarkerId('event'),
                                                  position: LatLng(
                                                    widget
                                                        .groupsModel!
                                                        .locationLat!,
                                                    widget
                                                        .groupsModel!
                                                        .locationLng!,
                                                  ),
                                                ),
                                            },
                                            onMapCreated: (_) {},
                                          ),
                                          // 👇 overlay transparent clickable layer
                                          Positioned.fill(
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () {
                                                  print('Map tapped!');
                                                  if (widget
                                                              .groupsModel
                                                              ?.locationLat !=
                                                          null &&
                                                      widget
                                                              .groupsModel
                                                              ?.locationLng !=
                                                          null) {
                                                    Get.to(
                                                      () => GroupMapScreen(
                                                        lat:
                                                            widget
                                                                .groupsModel!
                                                                .locationLat!,
                                                        lng:
                                                            widget
                                                                .groupsModel!
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

                                  30.verticalSpace,

                                  /// Button Section - Updated with host/admin logic
                                  if (isHost)
                                    // Host sees delete and group chat buttons
                                    Column(
                                      children: [
                                        CustomButton(
                                          onTap: () async {
                                            try {
                                              final db = DatabaseServices();
                                              final groupId = await db
                                                  .createOrGetGroup(
                                                    widget.groupsModel!,
                                                  );
                                              Get.to(
                                                () => ChangeNotifierProvider(
                                                  create:
                                                      (_) => ChatViewModel(
                                                        chatTitle:
                                                            widget
                                                                .groupsModel
                                                                ?.title ??
                                                            '',
                                                        chatImageUrl:
                                                            widget
                                                                .groupsModel
                                                                ?.imageUrl ??
                                                            '',
                                                        isGroupChat: true,
                                                        groupId: groupId,
                                                      ),
                                                  child: ChatScreen(
                                                    chatTitle:
                                                        widget
                                                            .groupsModel
                                                            ?.title ??
                                                        '',
                                                    chatImageUrl:
                                                        widget
                                                            .groupsModel
                                                            ?.imageUrl ??
                                                        '',
                                                    isGroupChat: true,
                                                  ),
                                                ),
                                              );
                                            } catch (e) {
                                              Get.snackbar(
                                                'Error',
                                                'Failed to open group chat: $e',
                                              );
                                            }
                                          },
                                          text: 'Group Chat',
                                          backgroundColor: primaryColor,
                                        ),
                                        10.verticalSpace,

                                        model.state == ViewState.busy
                                            ? Container(
                                              height: 45.h,
                                              decoration: BoxDecoration(
                                                color: secondaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(99),
                                              ),
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      color: whiteColor,
                                                    ),
                                              ),
                                            )
                                            : CustomButton(
                                              onTap: () => _deleteGroup(model),
                                              text: 'Close group.',
                                              backgroundColor: secondaryColor,
                                            ),

                                        30.verticalSpace,
                                      ],
                                    )
                                  else if (!isJoined)
                                    // Non-member sees join button
                                    CustomButton(
                                      onTap: () => handleJoin(model),
                                      text: 'Join Group',
                                      backgroundColor: primaryColor,
                                    )
                                  else
                                    // Member sees leave and chat options
                                    Column(
                                      children: [
                                        CustomButton(
                                          onTap: () => handleLeave(model),
                                          text: 'Leave Group',
                                          backgroundColor: secondaryColor,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                            vertical: 10,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: CustomButton(
                                                  onTap: () {
                                                    if (widget
                                                            .groupsModel
                                                            ?.hostUserId !=
                                                        null) {
                                                      Get.to(
                                                        () => ChangeNotifierProvider(
                                                          create:
                                                              (
                                                                _,
                                                              ) => ChatViewModel(
                                                                chatTitle:
                                                                    widget
                                                                        .groupsModel
                                                                        ?.hostName ??
                                                                    '',
                                                                chatImageUrl:
                                                                    widget
                                                                        .groupsModel
                                                                        ?.hostImage ??
                                                                    '',
                                                                isGroupChat:
                                                                    false,
                                                                receiverId:
                                                                    widget
                                                                        .groupsModel
                                                                        ?.hostUserId ??
                                                                    '',
                                                              ),
                                                          child: ChatScreen(
                                                            chatTitle:
                                                                widget
                                                                    .groupsModel
                                                                    ?.hostName ??
                                                                '',
                                                            chatImageUrl:
                                                                widget
                                                                    .groupsModel
                                                                    ?.hostImage ??
                                                                '',
                                                            isGroupChat: false,
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      Get.snackbar(
                                                        'Error',
                                                        'Host info not available',
                                                      );
                                                    }
                                                  },
                                                  text: 'Message Host',
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
                                                      final db =
                                                          DatabaseServices();
                                                      final groupId = await db
                                                          .createOrGetGroup(
                                                            widget.groupsModel!,
                                                          );
                                                      Get.to(
                                                        () => ChangeNotifierProvider(
                                                          create:
                                                              (
                                                                _,
                                                              ) => ChatViewModel(
                                                                chatTitle:
                                                                    widget
                                                                        .groupsModel
                                                                        ?.title ??
                                                                    '',
                                                                chatImageUrl:
                                                                    widget
                                                                        .groupsModel
                                                                        ?.imageUrl ??
                                                                    '',
                                                                isGroupChat:
                                                                    true,
                                                                groupId:
                                                                    groupId,
                                                              ),
                                                          child: ChatScreen(
                                                            chatTitle:
                                                                widget
                                                                    .groupsModel
                                                                    ?.title ??
                                                                '',
                                                            chatImageUrl:
                                                                widget
                                                                    .groupsModel
                                                                    ?.imageUrl ??
                                                                '',
                                                            isGroupChat: true,
                                                          ),
                                                        ),
                                                      );
                                                    } catch (e) {
                                                      Get.snackbar(
                                                        'Error',
                                                        'Failed to open group chat: $e',
                                                      );
                                                    }
                                                  },
                                                  text: 'Group Chat',
                                                  backgroundColor: primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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
