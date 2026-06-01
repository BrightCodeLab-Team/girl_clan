import 'package:flutter/material.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/services/moderation_service.dart';
import 'package:girl_clan/core/utils/app_messenger.dart';
import 'package:girl_clan/locator.dart';

const List<String> kReportReasons = [
  'Harassment',
  'Spam',
  'Hate Speech',
  'Inappropriate Content',
  'Fake Profile',
  'Other',
];

void showReportContentSheet(
  BuildContext context, {
  required String contentType,
  required String contentId,
  String? reportedUserId,
  String title = 'Report',
  String? blockUserId,
  String? blockUserLabel,
  VoidCallback? onBlocked,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      String selectedReason = kReportReasons.first;
      final detailsController = TextEditingController();
      final moderation = locator<ModerationService>();

      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: style18B),
                const SizedBox(height: 8),
                Text(
                  'Select a reason. Our team reviews all reports.',
                  style: style12.copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedReason,
                  decoration: const InputDecoration(
                    labelText: 'Reason',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      kReportReasons
                          .map(
                            (r) => DropdownMenuItem(value: r, child: Text(r)),
                          )
                          .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => selectedReason = v);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: detailsController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Additional details (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    onPressed: () async {
                      final error = await moderation.submitReport(
                        contentType: contentType,
                        contentId: contentId,
                        reason: selectedReason,
                        reportedUserId: reportedUserId,
                        details: detailsController.text,
                      );
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      if (error != null) {
                        AppMessenger.show(ctx, error, isError: true);
                      } else {
                        AppMessenger.show(ctx, 'Report submitted. Thank you.');
                      }
                    },
                    child: Text('Submit Report', style: style14.copyWith(color: whiteColor)),
                  ),
                ),
                if (blockUserId != null && blockUserLabel != null) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (dCtx) => AlertDialog(
                                title: const Text('Block User'),
                                content: Text(
                                  'Block $blockUserLabel? You will no longer see their messages or profile in chats.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(dCtx, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(dCtx, true),
                                    child: const Text(
                                      'Block',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                        );
                        if (confirm != true || !context.mounted) return;

                        final error = await moderation.blockUser(blockUserId);
                        if (!context.mounted) return;
                        Navigator.pop(context);
                        if (error != null) {
                          AppMessenger.show(ctx, error, isError: true);
                        } else {
                          AppMessenger.show(ctx, 'User blocked.');
                          onBlocked?.call();
                        }
                      },
                      child: const Text('Block User'),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      );
    },
  );
}
