// ignore_for_file: unused_field, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationPickerScreen extends StatefulWidget {
  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLatLng;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Get.snackbar("Permission Denied", "Location permission is required");
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
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_selectedLatLng!, 14),
      );
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Failed to get current location");
    }
  }

  Future<void> _searchAndMove(String query) async {
    if (query.trim().isEmpty) return;
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        LatLng latLng = LatLng(
          locations.first.latitude,
          locations.first.longitude,
        );
        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14));
        setState(() => _selectedLatLng = latLng);
      } else {
        Get.snackbar("Not Found", "Location not found");
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Could not find location");
    }
  }

  void _confirmAndReturn() async {
    if (_selectedLatLng != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _selectedLatLng!.latitude,
          _selectedLatLng!.longitude,
        );
        String address;
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;

          // Compose full address
          address = [
            if (place.name != null && place.name!.isNotEmpty) place.name,
            if (place.subLocality != null && place.subLocality!.isNotEmpty)
              place.subLocality,
            if (place.locality != null && place.locality!.isNotEmpty)
              place.locality,
            if (place.administrativeArea != null &&
                place.administrativeArea!.isNotEmpty)
              place.administrativeArea,
            if (place.postalCode != null && place.postalCode!.isNotEmpty)
              place.postalCode,
            if (place.country != null && place.country!.isNotEmpty)
              place.country,
          ].join(', ');
        } else {
          // fallback
          address =
              "${_selectedLatLng!.latitude}, ${_selectedLatLng!.longitude}";
        }

        Get.back(
          result: {
            'address': address,
            'lat': _selectedLatLng!.latitude,
            'lng': _selectedLatLng!.longitude,
          },
        );
      } catch (e) {
        print(e);
        Get.back(
          result: {
            'address':
                "${_selectedLatLng!.latitude}, ${_selectedLatLng!.longitude}",
            'lat': _selectedLatLng!.latitude,
            'lng': _selectedLatLng!.longitude,
          },
        );
      }
    } else {
      Get.snackbar("Error", "Please select a location on map");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pick Location')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLatLng ?? LatLng(0, 0),
              zoom: _selectedLatLng != null ? 14 : 2,
            ),
            myLocationEnabled: true,
            onMapCreated: (controller) => _mapController = controller,
            onTap: (latLng) => setState(() => _selectedLatLng = latLng),
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

          // 🔍 Search bar
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
                onSubmitted: _searchAndMove,
              ),
            ),
          ),

          // ✅ Select button
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
              onPressed: _confirmAndReturn,
              child: Text(
                "Add Location",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
