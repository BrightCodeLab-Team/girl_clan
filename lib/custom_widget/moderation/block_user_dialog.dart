import 'package:flutter/material.dart';
import 'package:girl_clan/core/services/moderation_service.dart';
import 'package:girl_clan/core/utils/app_messenger.dart';
import 'package:girl_clan/locator.dart';

/// Confirms and blocks a user; removes their content from the user's feed instantly.
Future<bool> confirmAndBlockUser(
  BuildContext context, {
  required String userId,
  required String userLabel,
  String? details,
  VoidCallback? onBlocked,
}) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder:
        (dCtx) => AlertDialog(
          title: const Text('Block User'),
          content: Text(
            'Block $userLabel? Their events, groups, and messages will be '
            'hidden from your feed immediately. Our moderation team will be notified.',
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

  if (confirm != true || !context.mounted) return false;

  final error = await locator<ModerationService>().blockUser(
    userId,
    reason: 'User blocked',
    details: details,
  );

  if (!context.mounted) return false;

  if (error != null) {
    AppMessenger.show(context, error, isError: true);
    return false;
  }

  AppMessenger.show(context, 'User blocked. Content removed from your feed.');
  onBlocked?.call();
  return true;
}
