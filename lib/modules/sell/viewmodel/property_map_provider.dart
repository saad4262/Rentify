import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'dart:io';



class PropertyMapProvider with ChangeNotifier {
  CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();
  LatLng _currentPosition = const LatLng(
      37.7749, -122.4194); // Default position
  Set<Marker> _markers = {};
  String _currentLocationAddress = '';
  String _selectedPlaceName = 'Selected Location';
  String _selectedPlaceAddress = '';
  List<Prediction> _predictions = [];
  LatLng? _selectedPlaceLatLng; // Add this field to store the selected place's LatLng
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String imagePath = 'assets/images/house.png';

  String? _imageUrl; // Add this field

  Uint8List? markerImage;

  List<Property> _properties = [];

  List<Property> get properties => _properties;

  final GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: "AIzaSyAjWEynDWhuCoW53qCDPn3AJCf1oWcmKrM"); // Add your API key

  LatLng get currentPosition => _currentPosition;

  CustomInfoWindowController get customInfoWindowController => _customInfoWindowController;
  Set<Marker> get markers => _markers;

  String get currentLocationAddress => _currentLocationAddress;

  String get selectedPlaceName => _selectedPlaceName;

  String get selectedPlaceAddress => _selectedPlaceAddress;

  List<Prediction> get predictions => _predictions;

  String? get imageUrl => _imageUrl; // Getter for the image URL
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

  void setImageUrl(String url) {
    _imageUrl = url;
    notifyListeners(); // Notify listeners of the change
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
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

  void addMarker(LatLng location,PropertyMapProvider propertyMapProvider, String size, String price) async {
    final Uint8List markerIcon = await getBytesFromAsset(imagePath, 100);
    final String uniqueId = '${location.latitude},${location.longitude}_${DateTime.now().millisecondsSinceEpoch}';
    final markerId = MarkerId(uniqueId);
    _markers.add(Marker(
      markerId: markerId,
      position: location,
      icon: BitmapDescriptor.fromBytes(markerIcon),
      onTap: () {
        print("Marker tapped at $location");
        // Remove the default info window by not setting it in the Marker
        _customInfoWindowController.addInfoWindow!(
          _buildCustomInfoWindowContent(location,imageUrl,propertyMapProvider,size,price),
          location, // Use the actual marker location here
        );
      },
    ));

    notifyListeners();
  }

  void updateSelectedPlace(LatLng place, String name, String address,PropertyMapProvider propertyMapProvider, String size, String price) {
    _selectedPlaceName = name;
    _selectedPlaceAddress = address;
    _selectedPlaceLatLng = place; // Store the selected LatLng

    addMarker(place,propertyMapProvider,size,price);
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

  Stream<List<Property>> getPropertiesStream(String uid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("sell")
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Property.fromFirestore(doc))
        .toList());
  }






  Future<void> saveUserLocation(String uid , LatLng place, String name, String address,PropertyMapProvider propertyMapProvider,String imageurls, String size, String price) async {
    final locationData = {
      'latitude': place.latitude,
      'longitude': place.longitude,
      'name': name,
      'address': address,
      'propertyMapProvider': propertyMapProvider,
      'size': size,
      'price': price,
      "image":imageurls,
      'timestamp': FieldValue.serverTimestamp(),
    };

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('sell')
          .doc(uid) // or use .add(locationData) if you want Firestore to auto-generate an ID
          .set(locationData);
      print('Location saved for user: $uid');
    } catch (e) {
      print('Error saving location: $e');
    }
  }

  Widget _buildCustomInfoWindowContent(LatLng location, String? imageUrl,PropertyMapProvider propertyMapProvider, String size, String price) {
    return Container(

      width: 300,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 300,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageUrl != null
                    ? FileImage(File(imageUrl!)) // Use FileImage for local files
                    : const AssetImage("assets/images/bg2.png") as ImageProvider, // Fallback asset image
                fit: BoxFit.cover, // Adjust as needed
                filterQuality: FilterQuality.high,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              // color: Colors.red, // This color won't show if the image is present
            ),
          ),
           Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    size,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Spacer(),
                Text(
                  price,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
           Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),

            child: Row(

              children: [
                Icon(Icons.location_on),
                Text(
                  propertyMapProvider.selectedPlaceAddress.isNotEmpty
                      ? propertyMapProvider._selectedPlaceName
                      : 'Address not available',              style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );



  }

}

class Property {
  final String uid;
  final String size;
  final String price;
  final String? imageUrl;

  Property({
    required this.size,
    required this.price,
    required this.uid,


    this.imageUrl,
  });

  factory Property.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>; // Extract the Map from DocumentSnapshot

    return Property(
      uid: data ['uid'] ?? '',
      size: data['size'] ?? '',
      price: data['price'] ?? '',
      imageUrl: data['imageUrl'], // Handle optional imageUrl
    );
  }
}



