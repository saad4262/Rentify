import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:realestate/modules/sell/viewmodel/sell_provider.dart';
import 'package:realestate/modules/signup/view/type1.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestor e.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:realestate/modules/welcome_screen/view/welcome_screen.dart';
import 'package:realestate/modules/login_screen/view/login_screen.dart';

import 'package:provider/provider.dart';
import 'package:realestate/modules/login_screen/viewmodel/providerlogin.dart';
import 'package:realestate/modules/map/viewmodel/location_provider.dart'; // Import your provider here
import 'package:realestate/modules/map/view/map_screen.dart'; // Ensure your MapScreen is in a separate file
import 'package:realestate/modules/map/view/map_screen1.dart'; // Ensure your MapScreen is in a separate file
import 'package:realestate/modules/signup/view/type2.dart';
import 'package:realestate/modules/signup/viewmodel/type_provider.dart'; // Import your provider file
import 'package:realestate/modules/home/view/home1.dart';
import 'package:realestate/modules/signup/viewmodel/info_provider.dart';
import 'package:realestate/modules/sell/view/sell_screen.dart';
import 'package:realestate/modules/sell/viewmodel/property_map_provider.dart';
import 'package:realestate/modules/sell/view/property_map_marker.dart';

import 'modules/home/viewmodel/home1provider.dart';

import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp( MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => PasswordVisibilityProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => FormValidationProvider(),
      ),
      ChangeNotifierProvider(
        create: (_) => LocationProvider()..startLocationUpdates(),
      ),
      ChangeNotifierProvider(
        create: (_) => CategoryProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => SellProviders(),
      ),
      ChangeNotifierProvider(
        create: (context) => ImagePickerProvider(),

      )
      ,
  ChangeNotifierProvider(
  create: (context) => ImagePickerProvider(),
  child: SellScreen(uid: 'your_uid', name: 'name', number: 'number'),
  ),

      ChangeNotifierProvider(
        create: (context) => PropertyMapProvider()..startLocationUpdates(),
      ),
      ChangeNotifierProvider(create: (_) => FavoriteProvider()), // Register the provider
      ChangeNotifierProvider(
        create: (context) => TabSelectionProvider(),

      ),
      // ChangeNotifierProvider(create: (_) => ChatProvider()), // Register the provider
      ChangeNotifierProvider(
        create: (context) => RatingProvider(),
      ),

      ChangeNotifierProvider(
        create: (context) => ReviewProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => SearchProvider(),
      ),

    ],
    child: MyApp(),
  ),);
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<Widget>(
        future: _checkUserLogin(),
        builder: (context, snapshot) {
          // While the future is loading, you can show a loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CustomLoadingAnimation());
          }

          // If the future completes successfully, return the widget
          if (snapshot.hasData) {
            return snapshot.data!;
          }

          // If the future has an error, handle it here
          return Center(child: Text("Error: ${snapshot.error}"));
        },
      ),
    );
  }

  // Change the return type to Future<Widget> because we're using async
  Future<Widget> _checkUserLogin() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    // Check if a user is logged in
    User? user = auth.currentUser;

    if (user != null) {
      // If user is logged in, fetch user data from Firestore
      return _fetchUserDataAndNavigate(user);
    } else {
      // If no user is logged in, navigate to the welcome screen
      return WelcomeScreen();
    }
  }

  // This method should return a Widget (not Object)
  Future<Widget> _fetchUserDataAndNavigate(User user) async {
    // Fetch user data from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      var infoUser = userData['infoUser'];

      // Get the user data from Firestore
      String name = infoUser['fullName'] ?? "No Name";
      String number = infoUser['phoneNumber'] ?? "No Number";
      String imageUrl = infoUser['imageUrl'] ?? "";

      // Pass the user data to the home1 screen
      return home1(uid: user.uid, name: name, number: number, imageUrl: imageUrl);
    } else {
      // If user data is not found, navigate to login screen
      Fluttertoast.showToast(msg: "User data not found!");
      return WelcomeScreen();  // Or you can navigate to a default screen
    }
  }
}


class ShoeWidget extends StatelessWidget {
  const ShoeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
            width: double.infinity,
            child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ925rJ2StQ_G3Z11SkP5BDHZE08isHL7MbpA&s'),
          ),
          const SizedBox(height: 10),
          const Text(
            'Shoe Details',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(height: 10),
          const Text(
            'Shoe Details description',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.bottomRight,
            child: CircleAvatar(
              backgroundColor: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}


class CustomLoadingAnimation extends StatelessWidget {
  const CustomLoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.staggeredDotsWave(
      color: Colors.white,
      size: 200,

    );
  }
}

