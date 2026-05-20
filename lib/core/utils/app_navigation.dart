import 'package:flutter/material.dart';

/// Safe navigation helpers that do not trigger GetX snackbar teardown.
class AppNavigation {
  static void pop<T>(BuildContext context, [T? result]) {
    if (!context.mounted) return;
    Navigator.of(context).pop(result);
  }

  static void popRoot<T>(BuildContext context, [T? result]) {
    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pop(result);
  }
}
