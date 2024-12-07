import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
// import 'location_provider.dart';
import 'package:realestate/modules/map/viewmodel/location_provider.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:realestate/shared/utils/responsive_helper/responsive_helper.dart';
import 'package:realestate/shared/widgets/custom_button.dart';
import 'package:realestate/modules/map/view/map_screen1.dart';
import 'package:realestate/modules/map/view/map_screen2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realestate/modules/sell/viewmodel/property_map_provider.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:realestate/modules/sell/view/sell_screen.dart';


class PropertyMap extends StatefulWidget {
  final String uid;
  final String size;
  final String price;
  final String? name;


  final String? imageUrl;
  final LatLng? selectedLocation;
  final String? selectedPlaceName;
  final String? selectedPlaceAddress;

  const PropertyMap({super.key, required this.uid, this.imageUrl,required this.price, required this.size,
    this.selectedLocation,
    this.selectedPlaceAddress,
    this.selectedPlaceName,
    this.name,

  });
  @override
  _PropertyMapState createState() => _PropertyMapState();
}

class _PropertyMapState extends State<PropertyMap> {
  GoogleMapController? _mapController;

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    final propertyMapProvider = Provider.of<PropertyMapProvider>(context, listen: false);
    propertyMapProvider.initializeCurrentLocation();
    if (widget.imageUrl != null) {
      propertyMapProvider.setImageUrl(widget.imageUrl!); // Set the image URL
    }

  }



  @override
  Widget build(BuildContext context) {
    final propertyMapProvider = Provider.of<PropertyMapProvider>(context);
    CustomInfoWindowController _customInfoWindowController = propertyMapProvider.customInfoWindowController;
    return Scaffold(

      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: propertyMapProvider.currentPosition,
              zoom: 14.0,
            ),

            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _customInfoWindowController.googleMapController = controller;
              _mapController?.animateCamera(CameraUpdate.newLatLng(propertyMapProvider.currentPosition));
            },
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: propertyMapProvider.markers,

          ),

  CustomInfoWindow(

                controller: propertyMapProvider.customInfoWindowController,
                height: 200,
                width: 300,
                offset: 35,
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
                String size = widget.size ?? ''; // Access size from the widget
                String price = widget.price ?? '';
                // Access price from the widget
                String imageUrl = widget.imageUrl ?? '';

                propertyMapProvider.updateSelectedPlace(place, name, address,propertyMapProvider,size, // Pass the size here
                    price);
                _mapController?.animateCamera(CameraUpdate.newLatLng(place));

                // Get the current user's UID
                String? uid = FirebaseAuth.instance.currentUser?.uid;

                if (uid != null) {
                  // Log before saving
                  print("Saving location for user: $uid");
                  await propertyMapProvider.saveUserLocation(uid, place,name,address,propertyMapProvider,size, // Pass the size here
                      price,imageUrl);
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
            child: _buildLocationCard(propertyMapProvider),
          ),


          Positioned(
            bottom:20,
            left: 15,
            right: 15,
            child: CustomButton(buttonText: "Choose Your location", color: Color(0xFF8BC83F), textColor: Colors.white,borderRadius: BorderRadius.circular(20),width: double.infinity,height: 65,
              // onPress: (){

              onPress: () {
                if (propertyMapProvider.selectedPlaceName.isNotEmpty) {
                  // Navigate to the next screen with the selected location
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SellScreen(
                        uid: widget.uid, // Pass the UID to MapScreen2
                        selectedLocation: propertyMapProvider.selectedPlaceLatLng!,
                        selectedPlaceName: propertyMapProvider.selectedPlaceName,
                        selectedPlaceAddress: propertyMapProvider.selectedPlaceAddress,
                        size: widget.size  , // Pass the size
                        price: widget.price, // Pass the price
                        imageUrl: widget.imageUrl,
                        name: widget.name,

                        // Pass the image URL

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

Widget _buildLocationCard(PropertyMapProvider provider) {
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
    final propertyMapProvider = Provider.of<PropertyMapProvider>(context);

    return Column(
      children: [
        TextField(

          onChanged: (value) {
            propertyMapProvider.searchPlaces(value);
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
        if (propertyMapProvider.predictions.isNotEmpty)
          Container(
            color: Colors.grey[200],
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: propertyMapProvider.predictions.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(propertyMapProvider.predictions[index].description ?? ""),
                    onTap: () async {
                      final details = await GoogleMapsPlaces(apiKey: "AIzaSyAjWEynDWhuCoW53qCDPn3AJCf1oWcmKrM").getDetailsByPlaceId(propertyMapProvider.predictions[index].placeId!);
                      if (details.isOkay && details.result?.geometry?.location != null) {
                        final location = details.result!.geometry!.location!;
                        onPlaceSelected(
                          LatLng(location.lat, location.lng),
                          details.result!.name,
                          details.result!.formattedAddress ?? '',
                        );

                        // Clear predictions after selection
                        propertyMapProvider.clearPredictions();
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

