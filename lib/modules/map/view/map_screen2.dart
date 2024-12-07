
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
// import 'location_provider.dart';
import 'package:realestate/modules/map/viewmodel/location_provider.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:realestate/modules/signup/view/type1.dart';
import 'package:realestate/shared/widgets/custom_button.dart';
import 'package:realestate/shared/utils/responsive_helper/responsive_helper.dart';
import 'package:realestate/shared/utils/app_images/app_images.dart';
import 'package:realestate/modules/map/view/map_screen.dart';
import 'package:realestate/modules/signup/view/type1.dart';
import 'package:realestate/modules/map/viewmodel/location_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class MapScreen2 extends StatelessWidget {
  final LatLng selectedLocation;
  final String selectedPlaceName;
  final String selectedPlaceAddress;
  final String uid;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

   MapScreen2({

    Key? key,
     required this.uid,
    required this.selectedLocation,
    required this.selectedPlaceName,
    required this.selectedPlaceAddress,}): super(key: key);

  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0,top: 30),
        child: Column(

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(

                    backgroundColor: Color(0xFFF5F4F8),
                    child: Icon(Icons.arrow_back_ios_new)),

                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CustomButton(buttonText: 'skip', color: Color(0xFFF5F4F8), textColor: Color(0xFF1F4C6B ),borderRadius: BorderRadius.circular(30),
                    width: ResponsiveHelper.getWidth(context, .3),height: ResponsiveHelper.getHeight(context, .07),),
                )
              ],
            ),
            SizedBox(height: ResponsiveHelper.getHeight(context, .04),),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Add your ",
                        style: TextStyle(fontSize: 28, color: Color(0xFF204D6C)),
                      ),

                      TextSpan(
                        text: "Location",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF204D6C)), // Change color as needed
                      ),
                    ],
                  ),

                ),
              ),
            ),
            SizedBox(height: ResponsiveHelper.getHeight(context, .02),),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Text(
                    "You can edit this later on  your account setting.",
                    style: TextStyle(
                        color: Color(0xFF1F4C6B ),fontSize: 12),)),
            ),
            SizedBox(height: ResponsiveHelper.getHeight(context, .04),),

            Stack(
                children:[ Image.asset(AppImages().map

                ),
                  Positioned(
                      bottom:0,
                      child: Container(
                          height: ResponsiveHelper.getHeight(context, .06),
                          child: InkWell(
                              onTap: (){
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapScreen(uid: uid),
                                  ),
                                );

                              },
                              child: Image.asset(AppImages().blur)))),
                  Positioned(
                      left: 100,
                      bottom: 10,


                      child: InkWell(
                          onTap: (){
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapScreen(uid: uid),
                              ),
                            );

                          },
                          child: Text("select on map")))
                ]

            ),

            SizedBox(height: ResponsiveHelper.getHeight(context, .04),),

            Container(
              width: ResponsiveHelper.getWidth(context, .9),
              height: ResponsiveHelper.getHeight(context, .1),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on,color:Color(0xFF1F4C6B ) ,),
                      SizedBox(width: ResponsiveHelper.getWidth(context, .03),),

                      Container(
                        width: 200,
                        child: Text(selectedPlaceName+selectedPlaceAddress,        maxLines: 2,

                            style: TextStyle(color: Color(0xFF1F4C6B )),),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios)
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color(0xFFF5F4F8) ,

              ),

            ),

            SizedBox(height: ResponsiveHelper.getHeight(context, .08),),

            CustomButton(buttonText: "Next", color: Color(0xFF8BC83F), textColor: Colors.white,borderRadius: BorderRadius.circular(15),width: ResponsiveHelper.getWidth(context, .8),height: ResponsiveHelper.getHeight(context, .08),
              onPress: () async {
                try {
                  await FirebaseFirestore.instance.collection('users').doc(uid).update({
                    'location': {
                      'latitude': selectedLocation.latitude,
                      'longitude': selectedLocation.longitude,
                      'name': selectedPlaceName,
                      'address': selectedPlaceAddress,
                    },
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => type1(uid:uid)), // Navigate to the next screen
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error saving location: ${e.toString()}")),
                  );
                }
              },              // onPress: (){
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => Login2(),
              //   ),
              // );

            ),
          ],
        ),
      ),
    );
  }

// Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Selected Location'),
  //     ),
  //     body: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 'Place Name:',
  //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
  //               ),
  //               SizedBox(height: 5),
  //               Text(selectedPlaceName),
  //               SizedBox(height: 15),
  //               Text(
  //                 'Address:',
  //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
  //               ),
  //               SizedBox(height: 5),
  //               Text(selectedPlaceAddress),
  //             ],
  //           ),
  //         ),
  //         // Expanded(
  //         //   child: GoogleMap(
  //         //     initialCameraPosition: CameraPosition(
  //         //       target: selectedLocation,
  //         //       zoom: 14.0,
  //         //     ),
  //         //     markers: {
  //         //       Marker(
  //         //         markerId: MarkerId('selected_location'),
  //         //         position: selectedLocation,
  //         //         infoWindow: InfoWindow(
  //         //           title: selectedPlaceName,
  //         //           snippet: selectedPlaceAddress,
  //         //         ),
  //         //       ),
  //         //     },
  //         //   ),
  //         // ),
  //       ],
  //     ),
  //   );
  // }
}