import 'package:flutter/material.dart';
import 'package:girl_clan/core/constants/colors.dart';

/// Safe snackbars via [ScaffoldMessenger] — avoids GetX overlay crashes.
class AppMessenger {
  static void show(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : secondaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void popDialog(BuildContext context) {
    if (!context.mounted) return;
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) navigator.pop();
  }
}
