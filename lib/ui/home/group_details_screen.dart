// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, deprecated_member_use, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
import 'package:girl_clan/ui/root_screen/root_screen.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class GroupDetailsScreen extends StatefulWidget {
  GroupsModel? groupsModel;
  GroupDetailsScreen({this.groupsModel});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  bool isJoined = false;
  bool isLoading = false;

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
    setState(() => isJoined = joined);
  }

  Future<void> fetchInitialData() async {
    setState(() => isLoading = true);
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
              model.getAllEvent(model.tabs[model.selectedTabIndex]['text']);
              model.getCurrentUserEvents();
              model.groupsData();
              Get.offAll(() => RootScreen());
              return false;
            },
            child: Scaffold(
              body:
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 120.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                                      .isNotEmpty
                                              ? NetworkImage(
                                                widget.groupsModel!.imageUrl!,
                                              )
                                              : AssetImage(
                                                    "$staticAssets/SplashScreenImage.png",
                                                  )
                                                  as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
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
                                Positioned(
                                  top: 40,
                                  right: 20,
                                  child: IconButton(
                                    onPressed: () async {
                                      final groupName =
                                          widget.groupsModel?.title ?? "Group";
                                      final groupDesc =
                                          widget.groupsModel?.description ?? "";
                                      final groupLink =
                                          "https://girlclan.com/group/${widget.groupsModel?.id}";
                                      final shareText =
                                          "$groupName\n\n$groupDesc\n\nJoin here: $groupLink";
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
                            20.verticalSpace,
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.groupsModel?.title ?? '',
                                    style: style18B,
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
                                  20.verticalSpace,
                                  Text('About Group', style: style16B),
                                  10.verticalSpace,
                                  Text(
                                    widget.groupsModel?.description ?? '',
                                    style: style14.copyWith(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

              // ✅ Fixed Bottom Bar
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SafeArea(child: _buildBottomButtons(model)),
              ),
            ),
          ),
    );
  }

  Widget _buildBottomButtons(HomeViewModel model) {
    if (isHost) {
      // 👑 Host Buttons
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            text: "Group Chat",
            backgroundColor: primaryColor,
            onTap: () async {
              try {
                final db = DatabaseServices();
                final groupId = await db.createOrGetGroup(widget.groupsModel!);
                Get.to(
                  () => ChangeNotifierProvider(
                    create:
                        (_) => ChatViewModel(
                          chatTitle: widget.groupsModel?.title ?? '',
                          chatImageUrl: widget.groupsModel?.imageUrl ?? '',
                          isGroupChat: true,
                          groupId: groupId,
                        ),
                    child: ChatScreen(
                      chatTitle: widget.groupsModel?.title ?? '',
                      chatImageUrl: widget.groupsModel?.imageUrl ?? '',
                      isGroupChat: true,
                    ),
                  ),
                );
              } catch (e) {
                Get.snackbar('Error', 'Failed to open group chat: $e');
              }
            },
          ),
          10.verticalSpace,
          model.state == ViewState.busy
              ? Container(
                height: 45.h,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Center(
                  child: CircularProgressIndicator(color: whiteColor),
                ),
              )
              : CustomButton(
                text: "Delete Group",
                backgroundColor: secondaryColor,
                onTap: () => _deleteGroup(model),
              ),
        ],
      );
    } else if (!isJoined) {
      // 👥 Not joined yet
      return CustomButton(
        text: "Join Group",
        backgroundColor: primaryColor,
        onTap: () => handleJoin(model),
      );
    } else {
      // ✅ Already joined
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            text: "Leave Group",
            backgroundColor: secondaryColor,
            onTap: () => handleLeave(model),
          ),
          10.verticalSpace,
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: "Message Host",
                  backgroundColor: const Color(0xff2B2B2B),
                  onTap: () {
                    if (widget.groupsModel?.hostUserId != null) {
                      Get.to(
                        () => ChangeNotifierProvider(
                          create:
                              (_) => ChatViewModel(
                                chatTitle: widget.groupsModel?.hostName ?? '',
                                chatImageUrl:
                                    widget.groupsModel?.hostImage ?? '',
                                isGroupChat: false,
                                receiverId:
                                    widget.groupsModel?.hostUserId ?? '',
                              ),
                          child: ChatScreen(
                            chatTitle: widget.groupsModel?.hostName ?? '',
                            chatImageUrl: widget.groupsModel?.hostImage ?? '',
                            isGroupChat: false,
                          ),
                        ),
                      );
                    } else {
                      Get.snackbar('Error', 'Host info not available');
                    }
                  },
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: CustomButton(
                  text: "Group Chat",
                  backgroundColor: primaryColor,
                  onTap: () async {
                    try {
                      final db = DatabaseServices();
                      final groupId = await db.createOrGetGroup(
                        widget.groupsModel!,
                      );
                      Get.to(
                        () => ChangeNotifierProvider(
                          create:
                              (_) => ChatViewModel(
                                chatTitle: widget.groupsModel?.title ?? '',
                                chatImageUrl:
                                    widget.groupsModel?.imageUrl ?? '',
                                isGroupChat: true,
                                groupId: groupId,
                              ),
                          child: ChatScreen(
                            chatTitle: widget.groupsModel?.title ?? '',
                            chatImageUrl: widget.groupsModel?.imageUrl ?? '',
                            isGroupChat: true,
                          ),
                        ),
                      );
                    } catch (e) {
                      Get.snackbar('Error', 'Failed to open group chat: $e');
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}
