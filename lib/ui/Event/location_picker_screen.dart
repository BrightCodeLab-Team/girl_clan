// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:girl_clan/core/utils/app_messenger.dart';
import 'package:girl_clan/core/utils/app_navigation.dart';

class LocationPickerScreen extends StatefulWidget {
  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLatLng;
  final TextEditingController _searchController = TextEditingController();

  void _showSnackBar(String message) {
    if (!mounted) return;
    AppMessenger.show(context, message, isError: true);
  }

  void _popWithResult(Map<String, dynamic> result) {
    if (!mounted) return;
    AppNavigation.pop(context, result);
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showSnackBar('Location permission is required');
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (!mounted) return;
      setState(() {
        _selectedLatLng = LatLng(position.latitude, position.longitude);
      });
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_selectedLatLng!, 14),
      );
    } catch (e) {
      print(e);
      _showSnackBar('Failed to get current location');
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
        if (!mounted) return;
        setState(() => _selectedLatLng = latLng);
      } else {
        _showSnackBar('Location not found');
      }
    } catch (e) {
      print(e);
      _showSnackBar('Could not find location');
    }
  }

  Future<void> _confirmAndReturn() async {
    if (_selectedLatLng == null) {
      _showSnackBar('Please select a location on map');
      return;
    }

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _selectedLatLng!.latitude,
        _selectedLatLng!.longitude,
      );

      String address;
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
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
          if (place.country != null && place.country!.isNotEmpty) place.country,
        ].join(', ');
      } else {
        address =
            '${_selectedLatLng!.latitude}, ${_selectedLatLng!.longitude}';
      }

      _popWithResult({
        'address': address,
        'lat': _selectedLatLng!.latitude,
        'lng': _selectedLatLng!.longitude,
      });
    } catch (e) {
      print(e);
      _popWithResult({
        'address':
            '${_selectedLatLng!.latitude}, ${_selectedLatLng!.longitude}',
        'lat': _selectedLatLng!.latitude,
        'lng': _selectedLatLng!.longitude,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick Location')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLatLng ?? const LatLng(0, 0),
              zoom: _selectedLatLng != null ? 14 : 2,
            ),
            myLocationEnabled: true,
            onMapCreated: (controller) => _mapController = controller,
            onTap: (latLng) => setState(() => _selectedLatLng = latLng),
            markers:
                _selectedLatLng != null
                    ? {
                      Marker(
                        markerId: const MarkerId('selected'),
                        position: _selectedLatLng!,
                      ),
                    }
                    : {},
          ),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(12),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search here',
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
          Positioned(
            bottom: 40,
            left: 50,
            right: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _confirmAndReturn,
              child: const Text(
                'Add Location',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
