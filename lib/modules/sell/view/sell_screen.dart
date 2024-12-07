
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:realestate/modules/map/view/map_screen.dart';
import 'package:realestate/shared/utils/app_images/app_images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realestate/shared/utils/responsive_helper/responsive_helper.dart';
import 'package:realestate/modules/sell/viewmodel/sell_provider.dart';
import 'package:realestate/modules/signup/viewmodel/info_provider.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:realestate/shared/widgets/custom_button.dart';
import 'package:realestate/shared/widgets/custom_drawer.dart';
import 'package:realestate/modules/login_screen/viewmodel/providerlogin.dart';
import 'package:realestate/shared/widgets/custom_flushbar.dart';
import 'package:realestate/modules/sell/view/property_map_marker.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:realestate/modules/sell/viewmodel/property_map_provider.dart';



class SellScreen extends StatefulWidget {
  final String? uid;
  final String? imageUrl;
  final String? name;
  final String? number;
  final LatLng? selectedLocation;
  final String? selectedPlaceName;
  final String? selectedPlaceAddress;
  final String? size;
  final String? price;
  final String?displayname;
  // final bool isFavorited;


  const SellScreen({
    Key? key,
     this.uid,
    this.imageUrl,
     this.name,
     this.number,
     this.selectedLocation,
     this.selectedPlaceAddress,
     this.selectedPlaceName,
    this.size,
    this.displayname,

    this.price,
    // this.isFavorited = false,


  }) : super(key: key);

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  late CollectionReference firestore;
  // bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Initialize Firestore reference
    firestore = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .collection("sell");
  }
  File? _image;
  // String? _imageUrls ;
  Position? _currentPosition;
  String? _selectedLocation;

  // Form controllers for property data
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _bedroomController = TextEditingController();
  final TextEditingController _contactNumber = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();

  // final firestore = FirebaseFirestore.instance.collection("users").doc(widget.uid).collection("sell");



  String _selectedCategory = 'Residential'; // Default category
  String? _selectedSubcategory; // Holds the selected subcategory
  bool _isFavorite = false;
  String _selectedCategory2 = "Sell";


  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      _selectedLocation = '${position.latitude}, ${position.longitude}';
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Location selected: $_selectedLocation')));
  }


  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer(); // Opens the drawer
  }

  @override
  Widget build(BuildContext context) {
    final sellProvider = Provider.of<SellProviders>(context);
    final subcategories = sellProvider.currentCategories;
    final propertyMapProvider = Provider.of<PropertyMapProvider>(context);


    return Scaffold(
      key: _scaffoldKey, // Key for the scaffold

      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 30),
        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            child: Column(
              children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _openDrawer,
                    child: CircleAvatar(
                      backgroundColor: Color(0xFFF5F4F8),
                      child: FaIcon(FontAwesomeIcons.barsStaggered),
                    ),
                  ),
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
                      SizedBox(width: 8), // Adjusted for clarity
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: widget.imageUrl != null
                              ? NetworkImage(widget.imageUrl!)
                              : AssetImage('assets/images/person1.png'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
                // Category Selection


                SizedBox(height: 10,),

                Text("Sell",style: TextStyle(fontSize: 28, fontFamily: "Schyler", color: Color(0xFF204D6C)),),

                SizedBox(height: 30,),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <String>['Residential', 'Commercial', 'Plot'].map((category) {
                    return GestureDetector(
                      onTap: () {
                        sellProvider.setPropertyType(category);

                        setState(() {
                          _selectedCategory = category; // Update the local variable to reflect the selected category
                          _selectedSubcategory = null; // Reset subcategory when category changes
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: sellProvider.selectedCategory == category ? Color(0xFF1F4C6B) : Color(0xFFF5F4F8),
                          border: Border.all(color: Color(0xFFF5F4F8)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: sellProvider.selectedCategory == category ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),


        SizedBox(height: ResponsiveHelper.getHeight(context, .03),),

                Text('Upload Image',style: TextStyle(fontSize: 18, fontFamily: "family2", color: Color(0xFF204D6C)),
                ),
                SizedBox(height: ResponsiveHelper.getHeight(context, .01),),




                 Consumer<ImagePickerProvider>(
                  builder: (context, imagePickerProvider, child) {
                    return _buildProfileImage(imagePickerProvider);

                  },
                ),


                SizedBox(height: ResponsiveHelper.getHeight(context, .03),),
                Text('Select Property Type',style: TextStyle(fontSize: 18, fontFamily: "family2", color: Color(0xFF204D6C)),
                ),

                // Subcategory Selection
                GridView.builder(
                  itemCount: subcategories.length,
                  shrinkWrap: true, // Prevent GridView from taking infinite height
                  physics: NeverScrollableScrollPhysics(), // Disable scrolling for GridView
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                  ),
                  itemBuilder: (context, index) {
                    final currentCategory = sellProvider.selectedCategory;
                    final subcategory = subcategories[index].name;
                    bool isSelected = false;

                    if (currentCategory == 'Residential') {
                      isSelected = sellProvider.selectedResidentialIndices.contains(index);
                    } else if (currentCategory == 'Commercial') {
                      isSelected = sellProvider.selectedCommercialIndices.contains(index);
                    } else if (currentCategory == 'Plot') {
                      isSelected = sellProvider.selectedPlotCategories.contains(index);
                    }


                    return GestureDetector(
                      onTap: () {
                        sellProvider.toggleSelection(index);
                        setState(() {
                          _selectedSubcategory = subcategory; // Update selected subcategory
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F4F8), // Change background color based on selection
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: isSelected ? Color(0xFF1F4C6B) : Color(0xFFF5F4F8), // Set border color to match background
                            width: 2.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            subcategory,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Property Details Text Fields


                  SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Align(
                      alignment: AlignmentDirectional.topStart,

                      child: Text('Size of your property ?',style: TextStyle(fontSize: 18, fontFamily: "family2", color: Color(0xFF204D6C)),
                      ),
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.getHeight(context, .03)),

                  Container(
                    width: ResponsiveHelper.getWidth(context, .9),
                    child: TextFormField(
                      controller: _sizeController,
                      decoration: InputDecoration(
                        filled: true,

                        fillColor: Color(0xFFE8E8E8),
                        hintText: 'Size of property',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Color(0xFFE8E8E8), width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Color(0xFF1F4C6B), width: 2.0),
                        ),
                        prefixIcon: Icon(Icons.format_size),
                        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                      ),

                    ),
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text('What is asking price ?',style: TextStyle(fontSize: 18, fontFamily: "family2", color: Color(0xFF204D6C)),
                      ),
                    ),
                  ),
                SizedBox(height: ResponsiveHelper.getHeight(context, .03)),

                  Container(
                    width: ResponsiveHelper.getWidth(context, .9),

                    child: TextFormField(
                      controller: _priceController,

                     keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFE8E8E8),
                        hintText: 'Price',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Color(0xFFE8E8E8), width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Color(0xFF1F4C6B), width: 2.0),
                        ),
                        prefixIcon: Icon(Icons.price_change_rounded),
                        suffixText: "Rs",

                        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),

                    child: Align(
                      alignment: AlignmentDirectional.topStart,

                      child: Text('Select your location',style: TextStyle(fontSize: 18, fontFamily: "family2", color: Color(0xFF204D6C)),
                      ),
                    ),
                  ),
                SizedBox(height: ResponsiveHelper.getHeight(context, .03)),

                  Stack(
                      children:[

                           Image.asset(AppImages().map
                                            ),

                        Positioned(
                            bottom:0,
                            child: Container(
                                height: 60,

                                // width: 200,
                                child: InkWell(

                                    onTap: (){
                                      final imagePickerProvider = Provider.of<ImagePickerProvider>(
                                          context, listen: false);
                                      if (imagePickerProvider.imageFile != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PropertyMap(uid: widget.uid ?? '',
                                                  imageUrl: imagePickerProvider
                                                      .imageFile!.path,
                                                  size: _sizeController.text,  // Pass size here
                                                  price: _priceController.text, ),
                                          ),


                                        );
                                      }

                                    },
                                    child: Image.asset(AppImages().blur)))),
                        Positioned(
                            left: 100,
                            bottom: 20,


                            child: InkWell(

                            onTap: (){
                              final imagePickerProvider = Provider.of<ImagePickerProvider>(
                                  context, listen: false);
                                  if (imagePickerProvider.imageFile != null) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PropertyMap(uid: widget.uid ?? '',
                                              imageUrl: imagePickerProvider
                                                  .imageFile!.path,
                                              size: _sizeController.text,  // Pass size here
                                              price: _priceController.text, // Pass price here),
                                      ),
                                      ),
                                    );
                                  }
                                },
                                child: Text("select on map")))

                      ]

                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: ResponsiveHelper.getWidth(context, .9),
                   height: ResponsiveHelper.getHeight(context, .09),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Color(0xFF1F4C6B)),
                            SizedBox(width: 30),
                            propertyMapProvider.selectedPlaceName.isNotEmpty &&
                                propertyMapProvider.selectedPlaceAddress.isNotEmpty                                ? Container(
                              width: 200,
                              child: Text(
                                '${propertyMapProvider.selectedPlaceName} ${propertyMapProvider.selectedPlaceAddress}',
                                maxLines: 2,
                                style: TextStyle(color: Color(0xFF1F4C6B)),
                              ),
                            )
                                : Text(
                              "Location detail",
                              style: TextStyle(color: Color(0xFF1F4C6B)),
                            ),
                          ],
                        ),

                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFFF5F4F8) ,

                    ),

                  ),
                  SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),


                    child: Align(
                      alignment: AlignmentDirectional.topStart,

                      child: Text('Condition of your property ?',style: TextStyle(fontSize: 18, fontFamily: "family2", color: Color(0xFF204D6C)),
                      ),
                    ),
                  ),
                SizedBox(height: ResponsiveHelper.getHeight(context, .03)),

                  Container(
                    width: ResponsiveHelper.getWidth(context, .9),

                    child: TextFormField(
                      controller: _conditionController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFE8E8E8),
                        hintText: 'Condition of your property',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Color(0xFFE8E8E8), width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Color(0xFF1F4C6B), width: 2.0),
                        ),
                        prefixIcon: Icon(Icons.holiday_village),
                        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                      ),

                    ),
                  ),

                  SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Align(
                      alignment: AlignmentDirectional.topStart,

                      child: Text('How many bedrooms ?',style: TextStyle(fontSize: 18, fontFamily: "family2", color: Color(0xFF204D6C)),
                      ),
                    ),
                  ),
                SizedBox(height: ResponsiveHelper.getHeight(context, .03)),

                  Container(
                    width: ResponsiveHelper.getWidth(context, .9),

                    child: TextFormField(
                      controller: _bedroomController,
                      keyboardType: TextInputType.numberWithOptions(),

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFE8E8E8),
                        hintText: 'No of bedrooms',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Color(0xFFE8E8E8), width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Color(0xFF1F4C6B), width: 2.0),
                        ),
                        prefixIcon: Icon(Icons.bed),
                        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                      ),

                    ),
                  ),

                  SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),

                    child: Align(
                      alignment: AlignmentDirectional.topStart,

                      child: Text('Contact Number',style: TextStyle(fontSize: 18, fontFamily: "family2", color: Color(0xFF204D6C)),
                      ),
                    ),
                  ),
                SizedBox(height: ResponsiveHelper.getHeight(context, .03)),

                  Container(
                    width: ResponsiveHelper.getWidth(context, .9),

                    child: TextFormField(
                      controller: _contactNumber,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xFFE8E8E8),
                        hintText: '+92',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Color(0xFFE8E8E8), width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Color(0xFF1F4C6B), width: 2.0),
                        ),
                        prefixIcon: Icon(Icons.call),
                        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                      ),

                    ),
                  ),

                  SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Align(
                      alignment: AlignmentDirectional.topStart,

                      child: Text('Description',style: TextStyle(fontSize: 18, fontFamily: "family2", color: Color(0xFF204D6C)),
                      ),
                    ),
                  ),
                SizedBox(height: ResponsiveHelper.getHeight(context, .03)),

                  Container(
                    width: ResponsiveHelper.getWidth(context, .9),

                    child: TextFormField(
                      maxLines: 5,
                      controller: _descriptionController,

                      decoration: InputDecoration(
                        hintText: "Describe your property in detail ?",
                        hintStyle: TextStyle(fontSize: 14),
                        filled: true,
                        fillColor: Color(0xFFE8E8E8),
                        // labelText: '+92',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Color(0xFFE8E8E8), width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Color(0xFF1F4C6B), width: 2.0),
                        ),
                        // prefixIcon: Icon(Icons.call),
                        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                      ),

                    ),
                  ),



                  SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <String>['Sell', 'Rent'].map((category) {
                    return GestureDetector(
                      onTap: () {
                        sellProvider.setPropertyType2(category);

                        setState(() {
                          _selectedCategory2 = category; // Update the local variable to reflect the selected category
                          _selectedSubcategory = null; // Reset subcategory when category changes
                        });
                      },
                      child: Container(
                        width: ResponsiveHelper.getWidth(context, .4),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(

                          color: sellProvider.selectedCategory2 == category ? Color(0xFF1F4C6B) : Color(0xFFF5F4F8),
                          border: Border.all(color: Color(0xFFF5F4F8)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Align(
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            category,
                            style: TextStyle(
                              color: sellProvider.selectedCategory2 == category ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),


                SizedBox(height: 20),



                Consumer<FormValidationProvider>(
                    builder: (context, provider, child) {
                      print("Rebuilding Login Button, isLoading: ${provider.isLoading}");
                      return
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: CustomButton(
                buttonText: "Upload",
                color: Color(0xFF8BC83F),
                textColor: Colors.white,
                borderRadius: BorderRadius.circular(10),
                width: ResponsiveHelper.getWidth(context, .8),
                isLoading: provider.isLoading,

                onPress:  provider.isLoading // Disable if loading
                    ? null
                    :upLoad


              ),
            );
  }
  ),

              ],
            ),
          ),
        ),
      ),
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

  void upLoad () async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Handle the case where there is no authenticated user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No user is currently logged in")),
      );
      return; // Exit the function or handle as needed
    }

    // final username = user.displayName ?? 'Unknown';
    final authProvider = Provider.of<FormValidationProvider>(
        context, listen: false);
    final propertyMapProvider = Provider.of<PropertyMapProvider>(context, listen: false);

    authProvider.setLoading(true); // Set loading to true

    // Get the ImagePickerProvider instance
    final imagePickerProvider = Provider.of<ImagePickerProvider>(
        context, listen: false);
    String? imageUrl;
    // String? userProfileImageUrl; // Image URL for user's profile
    try {
      // Upload image to Firebase Storage if selected
      if (imagePickerProvider.imageFile != null) {
        final imageFile = File(imagePickerProvider.imageFile!.path);
        String fileName = DateTime
            .now()
            .millisecondsSinceEpoch
            .toString();
        Reference storageRef = FirebaseStorage.instance.ref().child(
            'user_images/$fileName');

        try {
          // Upload the image file
          await storageRef.putFile(imageFile);
          // Get the download URL
          imageUrl = await storageRef.getDownloadURL();
        } catch (e) {
          // Show an error message if the upload fails
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error uploading image: ${e.toString()}")),
          );
          return; // Exit if upload fails
        }
      }

      // Now, save the form data to Firestore
      if (_formKey.currentState!.validate()) {
        try {
          await FirebaseFirestore.instance.collection("posts").add({
            'imageUrl': imageUrl,
            'name': widget.name,
            'number': widget.number,
            'size': _sizeController.text,
            'conditon': _conditionController.text,
            'propertyId': widget.uid, // Use the document ID as the propertyId

            'price': _priceController.text,
            'bedrooms': _bedroomController.text,
            'contactNumber': _contactNumber.text,
            'description': _descriptionController.text,
            'category': _selectedCategory,
            'subcategory': _selectedSubcategory,
            'location': propertyMapProvider.selectedPlaceAddress,
            'location_name':propertyMapProvider.selectedPlaceName,
            'latitude': propertyMapProvider.selectedPlaceLatLng?.latitude, // Add latitude
            'longitude': propertyMapProvider.selectedPlaceLatLng?.longitude, // Add longitude
            'marker_property': '${propertyMapProvider.selectedPlaceLatLng?.latitude},${propertyMapProvider.selectedPlaceLatLng?.longitude}_${DateTime.now().millisecondsSinceEpoch}',
            // Unique marker ID
            'user_id': user.uid, // Store UID for reference
            // isFavorited: doc['isFavorited'] ?? false,
            'isFavorite': false, // Default favorite state is false
            // 'userProfileImageUrl': userProfileImageUrl, // Store the user's profile image URL
            // "imageurl2": widget.imageUrl,
            "username": user.photoURL,
            "tag": _selectedCategory2

          });

          // void _toggleFavorite(Property property) async {
          //   setState(() {
          //     property.toggleFavorite();
          //   });
          //
          //   // Update Firestore when the favorite status changes
          //   FirebaseFirestore.instance.collection('properties').doc(property.id).update({
          //     'isFavorited': property.isFavorited,
          //   });
          // }

          await propertyMapProvider.saveUserLocation(
              widget.uid ?? "",
              propertyMapProvider.selectedPlaceLatLng!,
              widget.name ?? "",
              propertyMapProvider.selectedPlaceAddress,
              propertyMapProvider, // Pass the instance of PropertyMapProvider
              propertyMapProvider.imageUrl ?? "", // Image URL
              _sizeController.text, // Size
              _priceController.text  // Price
          );
          propertyMapProvider.addMarker(
              propertyMapProvider.selectedPlaceLatLng!,
              propertyMapProvider,
              _sizeController.text,
              _priceController.text
          );


          // Show a success message
          CustomFlushbar(message: "Uploaded Successfully",
              color: Colors.green,
              title: "Success").show(context);
        } catch (e) {
          // Show an error message if saving data fails
          CustomFlushbar(message: "Error", color: Colors.red, title: "Error")
              .show(
              context);
        }

      }
    }
    catch (e) {
      // Handle unexpected errors
      CustomFlushbar(
        message: "An unexpected error occurred: ${e.toString()}",
        color: Colors.red,
        title: "Error",
      ).show(context);
    } finally {
      authProvider.setLoading(false); // Set loading to false
    }
  }


  // void clearFields() {
  //
  //
  //   _sizeController.clear();
  //   _conditionController.clear();
  //   _priceController.clear();
  //   _bedroomController.clear();
  //   _contactNumber.clear();
  //   _descriptionController.clear();
  //   _selectedCategory = null; // Reset dropdown selection
  //   _selectedSubcategory = null;
  //   propertyMapProvider.resetLocation(); // Reset location (you'll need to implement this in the provider)
  //   Provider.of<ImagePickerProvider>(context, listen: false).clearImage(); // Clear image
  // }

  Widget _buildProfileImage(ImagePickerProvider imagePickerProvider) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  imagePickerProvider.pickImage();
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: imagePickerProvider.imageFile != null
                      ? FileImage(File(imagePickerProvider.imageFile!.path))
                      : const AssetImage('assets/images/person1.png'),
                ),
              ),
              Positioned(
                top: 65,
                right: 0,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Color(0xFF1F4C6B),
                  child: Icon(Icons.edit, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),

    );
  }


}
