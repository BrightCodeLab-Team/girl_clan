import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:girl_clan/core/constants/colors.dart';
import 'package:girl_clan/core/constants/text_style.dart';
import 'package:girl_clan/core/utils/app_messenger.dart';
import 'package:girl_clan/core/utils/map_launcher.dart';
import 'package:girl_clan/custom_widget/custom_button.dart';

class OpenInMapsActions extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String? label;

  const OpenInMapsActions({
    super.key,
    required this.latitude,
    required this.longitude,
    this.label,
  });

  Future<void> _openAppleMaps(BuildContext context) async {
    final opened = await MapLauncher.openAppleMaps(
      latitude: latitude,
      longitude: longitude,
      label: label,
    );
    if (!context.mounted) return;
    if (!opened) {
      AppMessenger.show(
        context,
        'Could not open Apple Maps',
        isError: true,
      );
    }
  }

  Future<void> _openGoogleMaps(BuildContext context) async {
    final opened = await MapLauncher.openGoogleMaps(
      latitude: latitude,
      longitude: longitude,
      label: label,
    );
    if (!context.mounted) return;
    if (!opened) {
      AppMessenger.show(
        context,
        'Could not open Google Maps',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (MapLauncher.isApplePlatform) {
      return CustomButton(
        onTap: () => _openAppleMaps(context),
        backgroundColor: primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, color: whiteColor, size: 18.sp),
            8.horizontalSpace,
            Text('Open in Apple Maps', style: style14B.copyWith(color: whiteColor)),
          ],
        ),
      );
    }

    return CustomButton(
      onTap: () => _openGoogleMaps(context),
      backgroundColor: primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map_outlined, color: whiteColor, size: 18.sp),
          8.horizontalSpace,
          Text('Open in Google Maps', style: style14B.copyWith(color: whiteColor)),
        ],
      ),
    );
  }
}

Future<void> showLocationOptionsSheet({
  required BuildContext context,
  required double latitude,
  required double longitude,
  String? label,
  VoidCallback? onViewInApp,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onViewInApp != null)
                ListTile(
                  leading: const Icon(Icons.map_outlined),
                  title: const Text('View on map'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    onViewInApp();
                  },
                ),
              if (MapLauncher.isApplePlatform)
                ListTile(
                  leading: const Icon(Icons.apple),
                  title: const Text('Open in Apple Maps'),
                  onTap: () async {
                    Navigator.pop(sheetContext);
                    final opened = await MapLauncher.openAppleMaps(
                      latitude: latitude,
                      longitude: longitude,
                      label: label,
                    );
                    if (!context.mounted) return;
                    if (!opened) {
                      AppMessenger.show(
                        context,
                        'Could not open Apple Maps',
                        isError: true,
                      );
                    }
                  },
                ),
              ListTile(
                leading: const Icon(Icons.public),
                title: const Text('Open in Google Maps'),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  final opened = await MapLauncher.openGoogleMaps(
                    latitude: latitude,
                    longitude: longitude,
                    label: label,
                  );
                  if (!context.mounted) return;
                  if (!opened) {
                    AppMessenger.show(
                      context,
                      'Could not open Google Maps',
                      isError: true,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
