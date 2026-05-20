// event_map_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventMapScreen extends StatelessWidget {
  final double lat;
  final double lng;

  EventMapScreen({required this.lat, required this.lng});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Event Location")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, lng),
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: MarkerId("event_location"),
            position: LatLng(lat, lng),
          ),
        },
      ),
    );
  }
}
