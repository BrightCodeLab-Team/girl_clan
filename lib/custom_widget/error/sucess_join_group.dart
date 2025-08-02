// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, deprecated_member_use

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/model/groups_model.dart';
import 'package:girl_clan/core/services/data_base_services.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';
import 'package:girl_clan/ui/chat/new_chat/chat_screen.dart';
import 'package:girl_clan/ui/chat/new_chat/chat_view_model.dart';
import 'package:girl_clan/ui/home/group_details_screen.dart';
import 'package:provider/provider.dart';

class SucessJoinGroup extends StatefulWidget {
  String? subtitle;
  String? title;
  String? image;
  final GroupsModel groupsModel;

  SucessJoinGroup({
    required this.subtitle,
    required this.image,
    required this.title,
    // required this.onClose,
    required this.groupsModel,
  });

  @override
  State<SucessJoinGroup> createState() => _SucessJoinGrouptate();
}

class _SucessJoinGrouptate extends State<SucessJoinGroup> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press same as your back icon
        Get.offAll(() => GroupDetailsScreen(groupsModel: widget.groupsModel));
        return false; // Prevent default back behavior
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SafeArea(
          child: Center(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      Get.offAll(
                        () =>
                            GroupDetailsScreen(groupsModel: widget.groupsModel),
                      );
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 25,
                      color: primaryColor,
                    ),
                  ),
                ),
                // 🎉 Confetti
                ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: true,
                  emissionFrequency: 0.05,
                  numberOfParticles: 50,
                  maxBlastForce: 30,
                  minBlastForce: 10,
                  gravity: 0.3,
                ),

                // Main content
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "${widget.image}",
                        width: 250,
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '${widget.title}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: blackColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.subtitle}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: blackColor),
                      ),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                onTap: () {
                                  if (widget.groupsModel.hostUserId != null &&
                                      widget
                                          .groupsModel
                                          .hostUserId!
                                          .isNotEmpty) {
                                    Get.to(
                                      () => ChangeNotifierProvider(
                                        create:
                                            (_) => ChatViewModel(
                                              chatTitle:
                                                  widget.groupsModel.hostName ??
                                                  '',
                                              chatImageUrl:
                                                  widget
                                                      .groupsModel
                                                      .hostImage ??
                                                  '',
                                              isGroupChat: false,
                                              receiverId:
                                                  widget
                                                      .groupsModel
                                                      .hostUserId ??
                                                  '',
                                            ),
                                        child: ChatScreen(
                                          chatTitle:
                                              widget.groupsModel.hostName ?? '',
                                          chatImageUrl:
                                              widget.groupsModel.hostImage ??
                                              '',
                                          isGroupChat: false,
                                        ),
                                      ),
                                    );

                                    print(
                                      "user hostUserName: ${widget.groupsModel.hostName}",
                                    );

                                    print(
                                      "user hostUserId: ${widget.groupsModel.hostUserId}",
                                    );

                                    print("user id: ${widget.groupsModel.id}");
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
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
                            ),
                            10.horizontalSpace,
                            Expanded(
                              child: CustomButton(
                                onTap: () async {
                                  try {
                                    final db = DatabaseServices();

                                    final groupId = await db.createOrGetGroup(
                                      widget.groupsModel,
                                    );

                                    print('Joined group with id: $groupId');

                                    Get.to(
                                      () => ChangeNotifierProvider(
                                        create:
                                            (_) => ChatViewModel(
                                              chatTitle:
                                                  widget.groupsModel.title ??
                                                  '',
                                              chatImageUrl:
                                                  widget.groupsModel.imageUrl ??
                                                  '',
                                              isGroupChat: true,
                                              groupId: groupId,
                                            ),
                                        child: ChatScreen(
                                          chatTitle:
                                              widget.groupsModel.title ?? '',
                                          chatImageUrl:
                                              widget.groupsModel.imageUrl ?? '',
                                          isGroupChat: true,
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Failed to join group: $e',
                                        ),
                                      ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
