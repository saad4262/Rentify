import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:realestate/modules/home/view/property_details.dart';
import 'package:realestate/modules/login_screen/view/login_screen.dart';
import 'package:realestate/modules/login_screen/view/login_screen2.dart';
import 'package:realestate/modules/sell/viewmodel/property_map_provider.dart';
import 'package:realestate/modules/signup/view/type2.dart';
import 'package:realestate/shared/utils/responsive_helper/responsive_helper.dart';
import 'package:realestate/shared/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realestate/modules/signup/viewmodel/info_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:realestate/modules/sell/view/sell_screen.dart';
import 'package:realestate/shared/widgets/custom_drawer.dart';
import 'package:realestate/modules/signup/viewmodel/type_provider.dart'; // Import your provider file
import 'package:realestate/modules/sell/viewmodel/property_map_provider.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../shared/widgets/custom_bottomnavbar.dart';
import '../viewmodel/home1provider.dart';

import 'message.dart';import 'favorite.dart'; // Import your provider file
import 'package:intl/intl.dart'; // Import this for date formatting
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class home1 extends StatefulWidget {
  final String uid;
  final String? imageUrl;
  final String name;
  final String number;
  final String? location_name;
  final String? username;
  final String? condition;
  final String? details;
  final String? propertyid;
  final String? tag;



  // final bool isFavorited;
  // final Map<String, dynamic>? propertyData;
  // final String? propertyId; // Property document ID for Firestore


  const home1({
    super.key,
    required this.uid,
    this.imageUrl,
    this.propertyid,
    this.location_name,
     this.username,
    this.condition,
    this.details,

    this.tag,


    required this.name,
    required this.number,
  });

  // void toggleFavorite() {
  //   isFavorited = !isFavorited;
  // }

  @override
  State<home1> createState() => _home1State();
}

class _home1State extends State<home1> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  final TextEditingController _controller = TextEditingController();
  int _selectedIndex = 0;
  // String _searchQuery = '';  // Variable to store search query

  int _selectedIndex2 = 0;


  // late bool _isFavorite;

  // void _updateSearchQuery() {
  //   setState(() {
  //     _searchQuery = _controller.text;
  //   });
  // }





  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    requestMicrophonePermission();
    // _controller.addListener(_updateSearchQuery);

    // Provider.of<PropertyMapProvider>(context, listen: false).fetchProperties(widget.uid);
    // _propertiesStream = getPropertiesStream(widget.uid);
  }
  ValueNotifier<int> _selectedIndexNotifier2 = ValueNotifier<int>(0);

  void _onTabSelected2(int index) {
    setState(() {
      _selectedIndex2 = index;
    });
    // Update the ValueNotifier
    _selectedIndexNotifier2.value = index;
  }

  Future<void> requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
      status = await Permission.microphone.status;
    }
  }




  void _startListening() async {
    if (await _speech.initialize()) {
      setState(() {
        _isListening = true;
      });
      _speech.listen(
        onResult: (result) {
          setState(() {
            _controller.text = result.recognizedWords;
          });
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Speech recognition not available on this device")),
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  List<Widget> get _pages => [

  Consumer<SearchProvider>(
  builder: (context, searchProvider, child) {
    String searchQuery = searchProvider.searchQuery;
    // Determine the query based on the searchQuery value
    Stream<QuerySnapshot> stream;

    if (searchQuery.isEmpty) {
      // If searchQuery is empty, fetch all properties
      stream = FirebaseFirestore.instance.collection("posts").snapshots();
    } else {
      // If searchQuery is not empty, filter by the search query
      stream = FirebaseFirestore.instance
          .collection("posts")
          .where('size', isEqualTo: searchQuery) // Adjust filter condition based on your field
          .snapshots();
    }

  return Center(
         child:   StreamBuilder<QuerySnapshot>(
    stream: stream,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(child: Text('No properties found.'));
      } else {
        final properties = snapshot.data!.docs;

        return GridView.builder(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: .70,
            crossAxisCount: 2,
          ),
          itemCount: properties.length,
          itemBuilder: (context, index) {
            final propertyData = properties[index].data() as Map<String, dynamic>;
            final propertySize = propertyData['size'] ?? 'N/A';
            final propertyPrice = propertyData['price'] ?? 'N/A';
            final propertyAdress = propertyData['location_name'] ?? 'N/A';
            final condition = propertyData['conditon'] ?? 'N/A';
            final details = propertyData['description'] ?? 'N/A';
            final number = propertyData['contactNumber'] ?? 'N/A';
            final tag = propertyData['tag'] ?? 'N/A';



            final propertyImageUrl = propertyData['imageUrl'];
            final userimage = propertyData['imageurl2'];
            final userId = propertyData['user_id'] ?? "N/A";  // Get user_id from the property data

            final propertyId = properties[index].id;

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("users")  // Assuming users are stored in 'users' collection
                  .doc(userId)  // Using user_id to fetch user data
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (userSnapshot.hasError) {
                  return Center(child: Text('Error fetching user data: ${userSnapshot.error}'));
                } else if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                  return Center(child: Text('User not found.'));
                } else {
                  final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                  final fullName = userData['infoUser']?['fullName'] ?? 'N/A';  // Extract fullName from infoUser map
                  final userimage = userData['infoUser']?['imageUrl'] ?? 'N/A';  // Extract fullName from infoUser map


                  return Consumer<FavoriteProvider>(
                    builder: (context, favoriteProvider, child) {
                      bool _isFavorite = favoriteProvider.isFavorite(propertyId);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>
                                  PropertyDetails(imageUrl: propertyImageUrl,price:propertyPrice,size: propertySize,location: propertyAdress,userimage: userimage,username: fullName,condition: condition,details: details,number: number,uid: widget.uid,uid2:userId,tag: tag),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(2, 1.0); // Start from the bottom of the screen
                                const end = Offset.zero; // End at the current position
                                const curve = Curves.easeInOut; // Smooth easing animation

                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 4,
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      height: 180,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: propertyImageUrl != null
                                            ? Image.network(
                                          propertyImageUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        )
                                            : Container(
                                          color: Colors.grey,
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 8,
                                      top: 5,
                                      height: 35,
                                      child: GestureDetector(
                                        onTap: () {
                                          favoriteProvider.toggleFavorite(propertyId, propertyData);
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: _isFavorite
                                              ? Color(0XFF8BC83F)
                                              : Colors.white,
                                          child: Icon(
                                            _isFavorite
                                                ? Icons.favorite
                                                : Icons.favorite_border_outlined,
                                            color: _isFavorite ? Colors.white : Colors.red,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 10,
                                      bottom: 5,
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF234F68),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          propertyPrice,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          propertySize,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF252B5C),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(

                                          padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adjust padding inside the container
                                          decoration: BoxDecoration(
                                            color: tag.toLowerCase() == 'sell' ? Colors.green : Colors.red,
                                            border: Border.all(color: tag.toLowerCase() == 'sell' ? Colors.green : Colors.red, width: 2), // Red border
                                            borderRadius: BorderRadius.circular(10), // Circular border with radius 10
                                          ),
                                          child: Text(
                                            tag,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                // color: Color(0xFF252B5C),
                                                color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ),
                                    )

                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            children: [
                                              Text(fullName),
                                              SizedBox(width: 5,),// Display fullName instead of username
                                              Padding(
                                                padding: const EdgeInsets.only(right: 8.0),
                                                child: CircleAvatar(
                                                  radius: 10,
                                                  backgroundImage: userimage != null && userimage.isNotEmpty
                                                      ? NetworkImage(userimage)
                                                      : AssetImage('assets/images/person1.png') as ImageProvider,
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Row(
                                          children: [
                                            Icon(Icons.location_pin, size: 15),
                                            Text(
                                              propertyAdress,
                                              style: TextStyle(fontSize: 7),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            );
          },
        );
      }
    },
  )
  );

  }
      ),


    // Residential Page
    Center(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .where("category", isEqualTo: "Residential") // Filter by category
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No properties found.'));
          } else {
            final properties = snapshot.data!.docs;

            return GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: .70,
                crossAxisCount: 2,
              ),
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final propertyData = properties[index].data() as Map<String, dynamic>;
                final propertySize = propertyData['size'] ?? 'N/A';
                final propertyPrice = propertyData['price'] ?? 'N/A';
                final propertyAdress = propertyData['location_name'] ?? 'N/A';
                final propertyImageUrl = propertyData['imageUrl'];
                final userId = propertyData['user_id'] ?? "N/A";  // Get user_id from the property data
                final propertyId = properties[index].id;

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("users")  // Assuming users are stored in 'users' collection
                      .doc(userId)  // Using user_id to fetch user data
                      .get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (userSnapshot.hasError) {
                      return Center(child: Text('Error fetching user data: ${userSnapshot.error}'));
                    } else if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                      return Center(child: Text('User not found.'));
                    } else {
                      final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                      final fullName = userData['infoUser']?['fullName'] ?? 'N/A';
                      final userImage = userData['infoUser']?['imageUrl'] ?? 'N/A';

                      return Consumer<FavoriteProvider>(
                        builder: (context, favoriteProvider, child) {
                          bool _isFavorite = favoriteProvider.isFavorite(propertyId);

                          return GestureDetector(
                            onTap: () {
                              favoriteProvider.toggleFavorite(propertyId, propertyData);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 4,
                                child: Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Container(
                                          height: 180,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: propertyImageUrl != null
                                                ? Image.network(
                                              propertyImageUrl,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            )
                                                : Container(
                                              color: Colors.grey,
                                              width: double.infinity,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 8,
                                          top: 5,
                                          height: 35,
                                          child: CircleAvatar(
                                            backgroundColor: _isFavorite
                                                ? Color(0XFF8BC83F)
                                                : Colors.white,
                                            child: Icon(
                                              _isFavorite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border_outlined,
                                              color: _isFavorite ? Colors.white : Colors.red,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 10,
                                          bottom: 5,
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF234F68),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              propertyPrice,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          propertySize,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF252B5C),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Row(
                                              children: [
                                                Text(fullName),
                                                SizedBox(width: 5,),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 8.0),
                                                  child: CircleAvatar(
                                                    radius: 10,
                                                    backgroundImage: userImage != null && userImage.isNotEmpty
                                                        ? NetworkImage(userImage)
                                                        : AssetImage('assets/images/person1.png') as ImageProvider,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Row(
                                              children: [
                                                Icon(Icons.location_pin, size: 15),
                                                Text(
                                                  propertyAdress,
                                                  style: TextStyle(fontSize: 8),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    ),

    // Commercial Page
    Center(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .where("category", isEqualTo: "Commercial") // Filter by category
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No properties found.'));
          } else {
            final properties = snapshot.data!.docs;

            return GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: .70,
                crossAxisCount: 2,
              ),
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final propertyData = properties[index].data() as Map<String, dynamic>;
                final propertySize = propertyData['size'] ?? 'N/A';
                final propertyPrice = propertyData['price'] ?? 'N/A';
                final propertyAdress = propertyData['location_name'] ?? 'N/A';
                final propertyImageUrl = propertyData['imageUrl'];
                final userId = propertyData['user_id'] ?? "N/A";  // Get user_id from the property data
                final propertyId = properties[index].id;

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("users")  // Assuming users are stored in 'users' collection
                      .doc(userId)  // Using user_id to fetch user data
                      .get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (userSnapshot.hasError) {
                      return Center(child: Text('Error fetching user data: ${userSnapshot.error}'));
                    } else if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                      return Center(child: Text('User not found.'));
                    } else {
                      final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                      final fullName = userData['infoUser']?['fullName'] ?? 'N/A';
                      final userImage = userData['infoUser']?['imageUrl'] ?? 'N/A';

                      return Consumer<FavoriteProvider>(
                        builder: (context, favoriteProvider, child) {
                          bool _isFavorite = favoriteProvider.isFavorite(propertyId);

                          return GestureDetector(
                            onTap: () {
                              favoriteProvider.toggleFavorite(propertyId, propertyData);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 4,
                                child: Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Container(
                                          height: 180,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: propertyImageUrl != null
                                                ? Image.network(
                                              propertyImageUrl,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            )
                                                : Container(
                                              color: Colors.grey,
                                              width: double.infinity,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 8,
                                          top: 5,
                                          height: 35,
                                          child: CircleAvatar(
                                            backgroundColor: _isFavorite
                                                ? Color(0XFF8BC83F)
                                                : Colors.white,
                                            child: Icon(
                                              _isFavorite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border_outlined,
                                              color: _isFavorite ? Colors.white : Colors.red,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 10,
                                          bottom: 5,
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF234F68),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              propertyPrice,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          propertySize,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF252B5C),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Row(
                                              children: [
                                                Text(fullName),
                                                SizedBox(width: 5,),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 8.0),
                                                  child: CircleAvatar(
                                                    radius: 10,
                                                    backgroundImage: userImage != null && userImage.isNotEmpty
                                                        ? NetworkImage(userImage)
                                                        : AssetImage('assets/images/person1.png') as ImageProvider,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Row(
                                              children: [
                                                Icon(Icons.location_pin, size: 15),
                                                Text(
                                                  propertyAdress,
                                                  style: TextStyle(fontSize: 8),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    ),

    // Plot Page
    Center(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .where("category", isEqualTo: "Plot") // Filter by category
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No properties found.'));
          } else {
            final properties = snapshot.data!.docs;

            return GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: .70,
                crossAxisCount: 2,
              ),
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final propertyData = properties[index].data() as Map<String, dynamic>;
                final propertySize = propertyData['size'] ?? 'N/A';
                final propertyPrice = propertyData['price'] ?? 'N/A';
                final propertyAdress = propertyData['location_name'] ?? 'N/A';
                final propertyImageUrl = propertyData['imageUrl'];
                final userId = propertyData['user_id'] ?? "N/A";  // Get user_id from the property data
                final propertyId = properties[index].id;

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("users")  // Assuming users are stored in 'users' collection
                      .doc(userId)  // Using user_id to fetch user data
                      .get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (userSnapshot.hasError) {
                      return Center(child: Text('Error fetching user data: ${userSnapshot.error}'));
                    } else if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                      return Center(child: Text('User not found.'));
                    } else {
                      final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                      final fullName = userData['infoUser']?['fullName'] ?? 'N/A';
                      final userImage = userData['infoUser']?['imageUrl'] ?? 'N/A';

                      return Consumer<FavoriteProvider>(
                        builder: (context, favoriteProvider, child) {
                          bool _isFavorite = favoriteProvider.isFavorite(propertyId);

                          return GestureDetector(
                            onTap: () {
                              favoriteProvider.toggleFavorite(propertyId, propertyData);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 4,
                                child: Column(
                                  children: [
                                    Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Container(
                                          height: 180,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: propertyImageUrl != null
                                                ? Image.network(
                                              propertyImageUrl,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            )
                                                : Container(
                                              color: Colors.grey,
                                              width: double.infinity,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 8,
                                          top: 5,
                                          height: 35,
                                          child: CircleAvatar(
                                            backgroundColor: _isFavorite
                                                ? Color(0XFF8BC83F)
                                                : Colors.white,
                                            child: Icon(
                                              _isFavorite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border_outlined,
                                              color: _isFavorite ? Colors.white : Colors.red,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 10,
                                          bottom: 5,
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF234F68),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              propertyPrice,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          propertySize,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF252B5C),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Row(
                                              children: [
                                                Text(fullName),
                                                SizedBox(width: 5,),
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 8.0),
                                                  child: CircleAvatar(
                                                    radius: 10,
                                                    backgroundImage: userImage != null && userImage.isNotEmpty
                                                        ? NetworkImage(userImage)
                                                        : AssetImage('assets/images/person1.png') as ImageProvider,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Row(
                                              children: [
                                                Icon(Icons.location_pin, size: 15),
                                                Text(
                                                  propertyAdress,
                                                  style: TextStyle(fontSize: 7),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    ),
  ];


  @override
  void dispose() {
    _controller.dispose();
    _selectedIndexNotifier2.dispose();
    super.dispose();
  }





  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer(); // Opens the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Key for the scaffold
      body: Consumer<TabSelectionProvider>(
        builder: (context, tabSelectionProvider, _) {
          // Switch based on the selected index to show the correct content
          switch (tabSelectionProvider.selectedIndex) {
            case 0:
              return Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 30),
          child: Column(
          children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          GestureDetector(
          onTap: _openDrawer, // Open drawer on tap
          child: CircleAvatar(
          backgroundColor: Color(0xFFF5F4F8),
          child: FaIcon(FontAwesomeIcons.barsStaggered),
          ),
          ),
          // Notification and Profile Icon
          Row(
          children: [
          Stack(
          children: [
          Container(
          decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.green, width: 2),
          ),
          child: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white,
          child: Icon(Icons.notifications_none, color: Colors.black),
          ),
          ),
          Positioned(
          top: 15,
          right: 18,
          child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
          ),
          ),
          ),
          ],
          ),
          SizedBox(width: ResponsiveHelper.getWidth(context, .03)),
          Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: CircleAvatar(
          radius: 25,
          backgroundImage: widget.imageUrl != null
          ? NetworkImage(widget.imageUrl!)
              : AssetImage('assets/images/person1.png') as ImageProvider,
          ),
          ),
          ],
          ),
          ],
          ),
          // Welcome Text
          Align(
          alignment: AlignmentDirectional.topStart,
          child: Padding(
          padding: const EdgeInsets.only(top: 26.0, left: 16),
          child: RichText(
          text: TextSpan(
          children: [
          TextSpan(
          text: "Hey, ",
          style: TextStyle(fontSize: 28, fontFamily: "family2", color: Color(0xFF204D6C)),
          ),
          TextSpan(
          text: " ${widget.name} ! ",
          style: TextStyle(fontSize: 28, fontFamily: "Schyler", color: Color(0xFF204D6C)),
          ),
          ],
          ),
          ),
          ),
          ),
          Align(
          alignment: AlignmentDirectional.topStart,
          child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16),
          child: Text(
          "Let's Start Exploring",
          style: TextStyle(fontSize: 28, fontFamily: "family2", color: Color(0xFF204D6C)),
          ),
          ),
          ),
          SizedBox(height: ResponsiveHelper.getWidth(context, .03)),
          // Search Bar
          Container(
          width: ResponsiveHelper.getWidth(context, .9),
          child: TextField(
            onChanged: (value){
              context.read<SearchProvider>().updateSearchQuery(value);
            },
          controller: _controller,
          decoration: InputDecoration(
          fillColor: Color(0xFFF5F4F8),
          filled: true,
          prefixIcon: Icon(Icons.search, color: Color(0xFF204D6C)),
          suffixIcon: IconButton(
          icon: Icon(_isListening ? Icons.mic : Icons.mic_none, color: Colors.grey),
          onPressed: _isListening ? _stopListening : _startListening,
          ),
          border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFFF5F4F8)),
          ),
          enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFFF5F4F8)),
          ),
          focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFFF5F4F8)),
          ),
          hintText: 'Search House, Apartment, etc',
          hintStyle: TextStyle(color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
          ),
          ),
          ),
          SizedBox(height: ResponsiveHelper.getHeight(context, .02)),
          // Custom Tab Bar
          SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _buildCustomTab("All", 0),
          ),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _buildCustomTab("Residential", 1),
          ),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _buildCustomTab("Commercial", 2),
          ),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _buildCustomTab("Plot", 3),
          ),

          ],
          ),
          ),
          SizedBox(height: 10,),
          Align(
          alignment: AlignmentDirectional.topStart,
          child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16),
          child: Text(
          "Explore Nearby Estates",
          style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold, fontFamily: "family2", color: Color(0xFF204D6C)),
          ),
          ),
          ),
          Expanded(
          child: _pages[_selectedIndex],
          ),


          ],
          ),

          ); // Show Home data
            case 1:
              // return FutureBuilder<DocumentSnapshot>(
              //   future: FirebaseFirestore.instance
              //       .collection("users") // Assuming users are stored in 'users' collection
              //       .doc(widget.uid) // Using user_id to fetch user data
              //       .get(),
              //   builder: (context, userSnapshot) {
              //     if (userSnapshot.connectionState == ConnectionState.waiting) {
              //       return Center(child: CircularProgressIndicator());
              //     } else if (userSnapshot.hasError) {
              //       return Center(child: Text('Error fetching user data: ${userSnapshot.error}'));
              //     } else if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              //       return Center(child: Text('User not found.'));
              //     } else {
              //       // Extract user data from the snapshot
              //       final userData = userSnapshot.data!.data() as Map<String, dynamic>;
              //       final fullName = userData['infoUser']?['fullName'] ?? 'N/A';
              //       final userImage = userData['infoUser']?['imageUrl'] ?? 'N/A';
              //
              //       // Navigate to ChatListPage with the required data
              //       return ChatListPage(
              //         propertyId: widget.number, // Use the property ID
              //         userimage: userImage, // Pass the fetched user image
              //         propertyOwnerId: widget.uid, // Use the fetched user ID
              //         propertyOwnerName: fullName, // Pass the fetched full name
              //       );
              //     }
              //   },
              // );

              return ChatListPage(
                        propertyId: widget.number, // Use the property ID
                        // userimage: userImage, // Pass the fetched user image
                        propertyOwnerId: widget.uid, // Use the fetched user ID
                        // propertyOwnerName: fullName, // Pass the fetched full name
                      );


            case 2:
              return FavoriteProperties();
            case 3:
              return EditableProfileScreen(uid: widget.uid); // Show Profile data
            default:
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _openDrawer, // Open drawer on tap
                          child: CircleAvatar(
                            backgroundColor: Color(0xFFF5F4F8),
                            child: Icon(Icons.menu),
                          ),
                        ),
                        // Notification and Profile Icon
                        Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.green, width: 2),
                                  ),
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.notifications_none, color: Colors.black),
                                  ),
                                ),
                                Positioned(
                                  top: 15,
                                  right: 18,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: ResponsiveHelper.getWidth(context, .03)),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage: widget.imageUrl != null
                                    ? NetworkImage(widget.imageUrl!)
                                    : AssetImage('assets/images/person1.png') as ImageProvider,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Welcome Text
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 26.0, left: 16),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Hey, ",
                                style: TextStyle(fontSize: 28, fontFamily: "family2", color: Color(0xFF204D6C)),
                              ),
                              TextSpan(
                                text: " ${widget.name} ! ",
                                style: TextStyle(fontSize: 28, fontFamily: "Schyler", color: Color(0xFF204D6C)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 16),
                        child: Text(
                          "Let's Start Exploring",
                          style: TextStyle(fontSize: 28, fontFamily: "family2", color: Color(0xFF204D6C)),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.getWidth(context, .03)),
                    // Search Bar
                    Container(
                      width: ResponsiveHelper.getWidth(context, .9),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          fillColor: Color(0xFFF5F4F8),
                          filled: true,
                          prefixIcon: Icon(Icons.search, color: Color(0xFF204D6C)),
                          suffixIcon: IconButton(
                            icon: Icon(_isListening ? Icons.mic : Icons.mic_none, color: Colors.grey),
                            onPressed: _isListening ? _stopListening : _startListening,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xFFF5F4F8)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xFFF5F4F8)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xFFF5F4F8)),
                          ),
                          hintText: 'Search House, Apartment, etc',
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.getHeight(context, .02)),
                    // Custom Tab Bar
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: _buildCustomTab("All", 0),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: _buildCustomTab("Residential", 1),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: _buildCustomTab("Commercial", 2),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: _buildCustomTab("Plot", 3),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0, left: 16),
                        child: Text(
                          "Explore Nearby Estates",
                          style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold, fontFamily: "family2", color: Color(0xFF204D6C)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _pages[_selectedIndex],
                    ),


                  ],
                ),

              ); // Default to Home content
          }
        },
      ),
      bottomNavigationBar: DockingBar(
        onTabSelected: (index) {
          // Optionally perform other actions when tab is selected
        },
      ),


      // Drawer
      drawer: CustomDrawer(
        imageUrl: widget.imageUrl,
        name: widget.name,
        number: widget.number,
        uid: widget.uid,
        onDrawerItemTap: () {
          // Handle any additional logic here if needed
        },
      ),

    );
  }

  Widget _buildCustomTab(String title, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFF204D6C) : Color(0xFFF5F4F8),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isSelected ? Color(0xFF204D6C) : Color(0xFFF5F4F8),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.white : Color(0xFF204D6C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ChatListPage extends StatefulWidget {
  // final ChatPage chatPage;
  //
  // ChatListPage({ required this.chatPage});

  final String propertyId;
  final String propertyOwnerId;
  // final String propertyOwnerName;
  // final String userimage;
  // final String? number;
  // final String? uid2;
  // final String? username1;


  ChatListPage({
    required this.propertyId,
    // required this.userimage,
    required this.propertyOwnerId,
    // required this.propertyOwnerName,
    // this.number,
    // this.uid2,
    // this.username1

  });

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Chats'),
      // ),

      body: Column(

        children: [

          Padding(
            padding: const EdgeInsets.only(top: 40.0,left: 8,right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap:(){
                        // Navigator.pop(context);
                      }, // Open drawer on tap
                      child: CircleAvatar(
                        backgroundColor: Color(0xFFF5F4F8),
                        child: Icon(Icons.arrow_back_ios_new_outlined),
                      ),
                    ),
                    SizedBox(width: 100,),
                    Text("Chats",style: TextStyle(fontSize: 28, fontFamily: "Schyler", color: Color(0xFF204D6C)),)


                  ],
                ),



              ],


            ),
          ),

    // import 'package:intl/intl.dart'; // Import this for date formatting

    Expanded(
    child: StreamBuilder<QuerySnapshot>(
    stream: _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('chats')
        .snapshots(),
    builder: (context, snapshot) {
    if (!snapshot.hasData) {
    return Center(child: CircularProgressIndicator());
    }

    var chatDocs = snapshot.data!.docs;

    if (chatDocs.isEmpty) {
    return Center(child: Text('No Chats Available.'));
    }

    return ListView.builder(
    itemCount: chatDocs.length,
    itemBuilder: (context, index) {
    var chatDoc = chatDocs[index];
    String chatId = chatDoc.id;  // This is the chat UID
    List<String> users = List.from(chatDoc['users']);

    // Filter out the current user from the chat list
    String otherUserId = users.firstWhere(
    (userId) => userId != currentUser?.uid,
    orElse: () => '');

    return FutureBuilder<DocumentSnapshot>(
      future: _firestore.collection('users').doc(otherUserId).get(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData ) {
          return ListTile(
            title: CircularProgressIndicator()
          );
        }

        if (!userSnapshot.data!.exists ) {
          return ListTile(
              title: Text(""),
          );
        }

        var userData = userSnapshot.data!;
        var infoUser = userData['infoUser'];

        if (infoUser == null) {
          return ListTile(
            title: Text('User info not available'),
          );
        }

        String fullName = infoUser['fullName'] ?? 'Unknown User';
        String imageUrl = infoUser['imageUrl'] ?? '';

        return StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('users')
              .doc(currentUser?.uid)
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .orderBy('timestamp', descending: true)
              .limit(1)
              .snapshots(),
          builder: (context, messageSnapshot) {
            if (!messageSnapshot.hasData) {
              return ListTile(
                title: CircularProgressIndicator(),
              );
            }

            var messageDoc = messageSnapshot.data!.docs.isNotEmpty
                ? messageSnapshot.data!.docs[0]
                : null;
            String lastMessage = messageDoc != null ? messageDoc['message'] ?? 'No message' : 'No message';

            Timestamp timestamp = messageDoc != null ? messageDoc['timestamp'] : Timestamp.now();
            String formattedTime = DateFormat('hh:mm a').format(timestamp.toDate());

            return ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : AssetImage('assets/default_profile.png') as ImageProvider,
              ),
              title: Text(fullName, style: TextStyle(fontSize: 16, fontFamily: "family2")),
              subtitle: Text(lastMessage),
              trailing: Text(
                formattedTime,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      propertyId: widget.propertyId,
                      propertyOwnerId: otherUserId,
                      userimage: imageUrl,
                      propertyOwnerName: fullName,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );

    },
    );
    },
    ),
    ),
        ],
      ),
    );
  }
}





class EditableProfileScreen extends StatefulWidget {
  final String uid;

  const EditableProfileScreen({super.key, required this.uid});

  @override
  State<EditableProfileScreen> createState() => _EditableProfileScreenState();
}

class _EditableProfileScreenState extends State<EditableProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _numberController = TextEditingController();
  String? _imageUrl;
  final _firestore = FirebaseFirestore.instance.collection("users");

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot doc = await _firestore.doc(widget.uid).get();
      if (doc.exists) {
        Map<String, dynamic>? userData = doc.data() as Map<String, dynamic>?;
        if (userData?['infoUser'] != null) {
          _nameController.text = userData!['infoUser']['fullName'] ?? '';
          _emailController.text = userData['infoUser']['email'] ?? '';
          _numberController.text = userData['infoUser']['phoneNumber'] ?? '';
          String? imageUrl = userData['infoUser']['imageUrl'] ?? '';

          // Ensure the imageUrl is correctly set and call setState
          setState(() {
            _imageUrl = imageUrl;
          });
        }
      }
    } catch (e) {
      Flushbar(
        message: "Error fetching user data: ${e.toString()}",
        duration: Duration(seconds: 3),
      ).show(context);
    }
  }

  Future<void> _updateUserData(File? imageFile) async {
    setState(() {
      _isLoading = true;
    });

    try {
      String? newImageUrl = _imageUrl;

      // Upload new image if selected
      if (imageFile != null) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef = FirebaseStorage.instance.ref().child('user_images/$fileName');
        await storageRef.putFile(imageFile);
        newImageUrl = await storageRef.getDownloadURL();
      }

      // Update Firestore data
      await _firestore.doc(widget.uid).set({
        'infoUser': {
          'fullName': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phoneNumber': _numberController.text.trim(),
          'imageUrl': newImageUrl,
        },
      }, SetOptions(merge: true));

      Flushbar(
        message: "Profile updated successfully!",
        duration: Duration(seconds: 3),
      ).show(context);
    } catch (e) {
      Flushbar(
        message: "Error updating profile: ${e.toString()}",
        duration: Duration(seconds: 3),
      ).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _updateUserData(File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Edit Profile"),
      // ),
      body: SingleChildScrollView(
        child: Column(

          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0,left: 8,right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap:(){
                          // Navigator.pop(context);
                        }, // Open drawer on tap
                        child: CircleAvatar(
                          backgroundColor: Color(0xFFF5F4F8),
                          child: Icon(Icons.arrow_back_ios_new_outlined),
                        ),
                      ),
                      SizedBox(width: 90,),
                      Text("Profile",style: TextStyle(fontSize: 28, fontFamily: "Schyler", color: Color(0xFF204D6C)),)


                    ],
                  ),



                ],


              ),
            ),
            SizedBox(height: ResponsiveHelper.getHeight(context, .08),),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Profile Image
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageUrl != null
                          ? NetworkImage(_imageUrl!) as ImageProvider
                          : AssetImage('assets/images/person1.png'),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.edit, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Text Fields
                  _buildTextField(_nameController, "Full Name", Icons.person),
                  _buildTextField(_emailController, "Email", Icons.email),
                  _buildTextField(_numberController, "Phone Number", Icons.phone),
                  SizedBox(height: 20),
                  // Save Button
                  _isLoading
                      ? CircularProgressIndicator()
                      : CustomButton(
                    buttonText: "Save Changes",
                    color: Colors.green,
                    textColor: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    width: ResponsiveHelper.getWidth(context, .8),
                    onPress: () => _updateUserData(null),
                  ),

                  SizedBox(height: ResponsiveHelper.getHeight(context, .03),),
                  CustomButton(
                    buttonText: "Logout",
                    color: Colors.red,
                    textColor: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    width: ResponsiveHelper.getWidth(context, .8),
                    onPress: () => Navigator.push(context,MaterialPageRoute(builder: (context)=> login() )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}


class RotatingCircularProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: RotationTransition(
          turns: AlwaysStoppedAnimation(45 / 360),
          child: CircularProgressIndicator(
            strokeWidth: 8.0,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF204D6C)),
          ),
        ),
      ),
    );
  }
}




// class CustomLoadingAnimation extends StatelessWidget {
//   const CustomLoadingAnimation({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return LoadingAnimationWidget.staggeredDotsWave(
//       color: Colors.white,
//       size: 200,
//     );
//   }
// }


