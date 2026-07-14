import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:girl_clan/custom_widget/open_in_maps_actions.dart';

class GroupMapScreen extends StatelessWidget {
  final double lat;
  final double lng;
  final String? label;

  const GroupMapScreen({
    super.key,
    required this.lat,
    required this.lng,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Location'),
        actions: [
          IconButton(
            tooltip: 'Open in Apple Maps',
            icon: const Icon(Icons.open_in_new),
            onPressed: () => showLocationOptionsSheet(
              context: context,
              latitude: lat,
              longitude: lng,
              label: label,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(lat, lng),
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('group_location'),
                  position: LatLng(lat, lng),
                ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: OpenInMapsActions(
              latitude: lat,
              longitude: lng,
              label: label,
            ),
          ),
        ],
      ),
    );
  }
}
