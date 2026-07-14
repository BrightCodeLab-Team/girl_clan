import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/services/moderation_service.dart';
import 'package:girl_clan/core/utils/app_messenger.dart';
import 'package:girl_clan/locator.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  final _moderation = locator<ModerationService>();
  List<Map<String, String>> _blockedUsers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final users = await _moderation.fetchBlockedUsers();
    if (mounted) {
      setState(() {
        _blockedUsers = users;
        _loading = false;
      });
    }
  }

  Future<void> _unblock(String userId, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Unblock User'),
            content: Text('Unblock $name? Their content may appear again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Unblock'),
              ),
            ],
          ),
    );

    if (confirm != true || !mounted) return;

    final error = await _moderation.unblockUser(userId);
    if (!mounted) return;

    if (error != null) {
      AppMessenger.show(context, error, isError: true);
      return;
    }

    AppMessenger.show(context, '$name unblocked.');
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text('Blocked Users', style: style18B),
        centerTitle: true,
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : _blockedUsers.isEmpty
              ? Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Text(
                    'You have not blocked anyone. Block abusive users from '
                    'chat, events, or groups to hide their content instantly.',
                    style: style14.copyWith(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
              : ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount: _blockedUsers.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final user = _blockedUsers[index];
                  final name = user['name'] ?? 'User';
                  final id = user['id'] ?? '';

                  return ListTile(
                    title: Text(name, style: style14B),
                    subtitle: const Text('Tap to unblock'),
                    trailing: TextButton(
                      onPressed: () => _unblock(id, name),
                      child: const Text('Unblock'),
                    ),
                    onTap: () => _unblock(id, name),
                  );
                },
              ),
    );
  }
}
