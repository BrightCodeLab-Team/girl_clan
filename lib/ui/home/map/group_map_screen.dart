// event_map_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GroupMapScreen extends StatelessWidget {
  final double lat;
  final double lng;

  GroupMapScreen({required this.lat, required this.lng});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Group Location")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, lng),
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: MarkerId("group_location"),
            position: LatLng(lat, lng),
          ),
        },
      ),
    );
  }
}
