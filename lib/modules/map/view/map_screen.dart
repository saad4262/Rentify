import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
// import 'location_provider.dart';
import 'package:realestate/modules/map/viewmodel/location_provider.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:realestate/shared/widgets/custom_button.dart';
import 'package:realestate/modules/map/view/map_screen1.dart';
import 'package:realestate/modules/map/view/map_screen2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MapScreen extends StatefulWidget {
  final String uid;
  const MapScreen({super.key, required this.uid});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initializeCurrentLocation();
  }



  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(

      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: locationProvider.currentPosition,
              zoom: 14.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _mapController?.animateCamera(CameraUpdate.newLatLng(locationProvider.currentPosition));
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: locationProvider.markers,

          ),
          Positioned(
              top:30,
              left: 15,
              // right: 15,
              child: CircleAvatar(

                backgroundColor: Colors.white,
                  child: InkWell(
                      onTap: (){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapScreen1(uid: widget.uid),
                          ),
                        );

                      },
                      child: Icon(Icons.arrow_back_ios_new)))),
          Positioned(
            top:100,
            left: 15,
            right: 15,
            child: SearchBar(
              onPlaceSelected: (place, name, address) async {
                locationProvider.updateSelectedPlace(place, name, address);
                _mapController?.animateCamera(CameraUpdate.newLatLng(place));

                // Get the current user's UID
                String? uid = FirebaseAuth.instance.currentUser?.uid;

                if (uid != null) {
                  // Log before saving
                  print("Saving location for user: $uid");
                  await locationProvider.saveUserLocation(uid, place,name,address);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("User is not logged in")),
                  );
                }
              },
            ),
          ),
          Positioned(
            bottom: 100,
            left: 15,
            right: 15,
            child: _buildLocationCard(locationProvider),
          ),

          Positioned(
            bottom:20,
            left: 15,
            right: 15,
            child: CustomButton(buttonText: "Choose Your location", color: Color(0xFF8BC83F), textColor: Colors.white,borderRadius: BorderRadius.circular(20),width: double.infinity,height: 65,
              // onPress: (){
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => Login2(),
              //   ),
              // );
              onPress: () {
                if (locationProvider.selectedPlaceName.isNotEmpty) {
                  // Navigate to the next screen with the selected location
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapScreen2(
                        uid: widget.uid, // Pass the UID to MapScreen2
                        selectedLocation: locationProvider.selectedPlaceLatLng!,
                        selectedPlaceName: locationProvider.selectedPlaceName,
                        selectedPlaceAddress: locationProvider.selectedPlaceAddress,
                      ),
                    ),
                  );
                } else {
                  // Handle if no place is selected (optional)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select a location")),
                  );
                }
              },
                ),
          ),    // ,onPress: (){
    // Navigator.pushReplacement(
    // context,
    // MaterialPageRoute(
    // builder: (context) => Login2(),
    // ),
    // );)
    ],
      ),
    );
  }
}

Widget _buildLocationCard(LocationProvider provider) {
  return Card(
    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(

            provider.selectedPlaceName.isNotEmpty
                ? provider.selectedPlaceName
                : 'Current Location',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Color(0xFF234F68)),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Container(
                height: 50,
                child: Image.asset("assets/images/card-icon.png"),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  provider.selectedPlaceAddress.isNotEmpty
                      ? provider.selectedPlaceAddress
                      : provider.currentLocationAddress.isNotEmpty
                      ? provider.currentLocationAddress
                      : 'No address available',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}



class SearchBar extends StatelessWidget {
  final Function(LatLng, String, String) onPlaceSelected;

  const SearchBar({Key? key, required this.onPlaceSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    return Column(
      children: [
        TextField(

          onChanged: (value) {
            locationProvider.searchPlaces(value);
          },
          
          decoration: InputDecoration(
           suffixIcon: Icon(Icons.settings_voice_rounded,color: Colors.grey,),
            prefixIcon: Icon(Icons.search,color: Color(0xFF234F68),),
            hintText: 'Find Location',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        if (locationProvider.predictions.isNotEmpty)
          Container(
            color: Colors.grey[200],
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: locationProvider.predictions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(locationProvider.predictions[index].description ?? ""),
                    onTap: () async {
                      final details = await GoogleMapsPlaces(apiKey: "AIzaSyAjWEynDWhuCoW53qCDPn3AJCf1oWcmKrM").getDetailsByPlaceId(locationProvider.predictions[index].placeId!);
                      if (details.isOkay && details.result?.geometry?.location != null) {
                        final location = details.result!.geometry!.location!;
                        onPlaceSelected(
                          LatLng(location.lat, location.lng),
                          details.result!.name,
                          details.result!.formattedAddress ?? '',
                        );

                        // Clear predictions after selection
                        locationProvider.clearPredictions();
                      } else {
                        print('Error fetching details: ${details.errorMessage}');
                      }
                    }
                );
              },
            ),
          ),
      ],
    );
  }
}
