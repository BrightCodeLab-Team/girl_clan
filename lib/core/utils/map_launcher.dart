import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:url_launcher/url_launcher.dart';

class MapLauncher {
  static bool get isApplePlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  static Future<bool> openAppleMaps({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    final query =
        label != null && label.trim().isNotEmpty
            ? '&q=${Uri.encodeComponent(label.trim())}'
            : '';
    final uri = Uri.parse(
      'https://maps.apple.com/?ll=$latitude,$longitude$query',
    );

    return _launchExternal(uri);
  }

  static Future<bool> openGoogleMaps({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    final query =
        label != null && label.trim().isNotEmpty
            ? Uri.encodeComponent(label.trim())
            : '$latitude,$longitude';
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query',
    );

    return _launchExternal(uri);
  }

  static Future<bool> _launchExternal(Uri uri) async {
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
