import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationProvider with ChangeNotifier {
  LatLng _currentPosition = const LatLng(
      37.7749, -122.4194); // Default position
  Set<Marker> _markers = {};
  String _currentLocationAddress = '';
  String _selectedPlaceName = 'Selected Location';
  String _selectedPlaceAddress = '';
  List<Prediction> _predictions = [];
  LatLng? _selectedPlaceLatLng; // Add this field to store the selected place's LatLng
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  final GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: "AIzaSyAjWEynDWhuCoW53qCDPn3AJCf1oWcmKrM"); // Add your API key

  LatLng get currentPosition => _currentPosition;

  Set<Marker> get markers => _markers;

  String get currentLocationAddress => _currentLocationAddress;

  String get selectedPlaceName => _selectedPlaceName;

  String get selectedPlaceAddress => _selectedPlaceAddress;

  List<Prediction> get predictions => _predictions;

  LatLng? get selectedPlaceLatLng => _selectedPlaceLatLng; // Add this getter


  StreamSubscription<Position>? _positionStreamSubscription;

  Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied. Please enable it in settings.');
        return;
      }
    }
  }

  void initializeCurrentLocation() async {
    await requestLocationPermission();
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _currentPosition = LatLng(position.latitude, position.longitude);
      await _getCurrentLocationName(position.latitude, position.longitude);
      startLocationUpdates();
      notifyListeners();
    } catch (e) {
      print('Could not get current position: $e');
    }
  }

  void startLocationUpdates() {
    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _getCurrentLocationName(position.latitude, position.longitude);
          _updateCurrentLocationMarker();
          notifyListeners();
        });
  }

  Future<void> _getCurrentLocationName(double latitude,
      double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        _currentLocationAddress = '${placemark.locality}, ${placemark.country}';
      } else {
        _currentLocationAddress = 'No location found';
      }
    } catch (e) {
      print('Error fetching location name: $e');
      _currentLocationAddress = 'Error fetching location';
    }
    notifyListeners();
  }

  void _updateCurrentLocationMarker() {
    _markers.removeWhere((marker) =>
    marker.markerId.value == 'current_location');
    _markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: _currentPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Current Location'),
      ),
    );
  }

  void addMarker(LatLng location) {
    final markerId = MarkerId(location.toString());
    _markers.add(Marker(
      markerId: markerId,
      position: location,
      infoWindow: InfoWindow(title: 'Selected Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    ));
    notifyListeners();
  }

  void updateSelectedPlace(LatLng place, String name, String address) {
    _selectedPlaceName = name;
    _selectedPlaceAddress = address;
    _selectedPlaceLatLng = place; // Store the selected LatLng

    addMarker(place);
    notifyListeners();
  }

  Future<void> searchPlaces(String query) async {
    if (query.isNotEmpty) {
      final response = await _places.autocomplete(query);
      if (response.isOkay) {
        _predictions = response.predictions;
      } else {
        print('Error fetching predictions: ${response.errorMessage}');
      }
    } else {
      _predictions = [];
    }
    notifyListeners();
  }


  void clearPredictions() {
    _predictions = [];
    notifyListeners(); // Ensure listeners are notified to update the UI
  }

  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }


  Future<void> saveUserLocation(String uid, LatLng place, String name, String address) async {
    final locationData = {
      'latitude': place.latitude,
      'longitude': place.longitude,
      'name': name,
      'address': address,
      'timestamp': FieldValue.serverTimestamp(), // Optional
    };

    try {
      await _firestore.collection('user_locations').doc(uid).set(locationData);
      print('Location saved for user: $uid');
    } catch (e) {
      print('Error saving location: $e');
    }
  }

}
