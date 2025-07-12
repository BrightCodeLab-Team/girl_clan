// ignore_for_file: unused_field, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLatLng;
  String? _selectedAddress;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // get user current location at start
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Get.snackbar(
          "Permission Denied",
          "Location permission is required to show map",
        );
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _selectedLatLng = LatLng(position.latitude, position.longitude);
      });
      _mapController?.animateCamera(CameraUpdate.newLatLng(_selectedLatLng!));
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Failed to get current location");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _selectedLatLng == null
              ? GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(0, 0), // or any default
                  zoom: 2,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                },
              )
              : GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _selectedLatLng!,
                  zoom: 12,
                ),
                myLocationEnabled: true,
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                onTap: (latLng) {
                  setState(() {
                    _selectedLatLng = latLng;
                  });
                },
                markers:
                    _selectedLatLng != null
                        ? {
                          Marker(
                            markerId: MarkerId("selected"),
                            position: _selectedLatLng!,
                          ),
                        }
                        : {},
              ),

          // Search bar
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search here",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                ),
                onSubmitted: (value) async {
                  if (value.trim().isEmpty) return;

                  try {
                    List<Location> locations = await locationFromAddress(value);
                    if (locations.isNotEmpty) {
                      LatLng newLatLng = LatLng(
                        locations.first.latitude,
                        locations.first.longitude,
                      );

                      _mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(newLatLng, 14),
                      );

                      setState(() {
                        _selectedLatLng = newLatLng;
                      });
                    } else {
                      Get.snackbar("Not Found", "Location not found");
                    }
                  } catch (e) {
                    print(e);
                    Get.snackbar("Error", "Could not find location");
                  }
                },
              ),
            ),
          ),

          // Add Location button
          Positioned(
            bottom: 40,
            left: 50,
            right: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Add Location",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              onPressed: () async {
                if (_selectedLatLng != null) {
                  try {
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                      _selectedLatLng!.latitude,
                      _selectedLatLng!.longitude,
                    );

                    String address =
                        placemarks.isNotEmpty
                            ? "${placemarks.first.name}, ${placemarks.first.locality}, ${placemarks.first.country}"
                            : "${_selectedLatLng!.latitude}, ${_selectedLatLng!.longitude}";

                    Get.back(result: address); // pass address string back
                  } catch (e) {
                    Get.back(
                      result:
                          "${_selectedLatLng!.latitude}, ${_selectedLatLng!.longitude}",
                    );
                  }
                } else {
                  Get.snackbar("Error", "Please select a location on map");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
