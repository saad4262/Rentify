import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:realestate/shared/utils/responsive_helper/responsive_helper.dart';

import '../viewmodel/home1provider.dart';
import 'chatlistpage.dart';
import 'home1.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'message.dart';
// import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';



class PropertyDetails extends StatefulWidget {
  final String imageUrl;
  final String location;
  final String username;
  final String userimage;
  final String condition;
  final String details;
  final String size;
  final String price;
  final String number;
  final String? propertyid;
  final String uid;
  final String uid2;
  final String tag;










  const PropertyDetails({
    Key? key,
    required this.imageUrl,
    this.propertyid,
    required this.uid,

    required this.price,
    required this.number,
    required this.tag,



    required this.location,
    required this.username,
    required this.userimage,
    required this.condition,
    required this.details,
    required this.size,
    required this.uid2,
  }) : super(key: key);

  @override
  State<PropertyDetails> createState() => _PropertyDetailsState();
}

class _PropertyDetailsState extends State<PropertyDetails> {

   // late String _numberCtrl;
  final TextEditingController _controller = TextEditingController();
  double _rating = 0.0; // Holds the selected rating
  // final ratingProvider = Provider.of<RatingProvider>(context); // Access RatingProvider
  bool _showAllReviews = false;  // This variable controls whether to show all reviews or just two

  // Sample review data
  final List<Map<String, dynamic>> reviews = [
    {
      "name": "Ramisha",
      "image": "assets/images/ramisha.jpg",
      "rating": 5,
      "text": "Great property! Exactly as described."
    },
    {
      "name": "Muhammad Asif",
      "image": "assets/images/r5.jpg",
      "rating": 4,
      "text": "Good value for the price, would recommend."
    },
    {
      "name": "Uzair Ahmed",
      "image": "assets/images/r1.jpg",
      "rating": 1,
      "text": "Value for money!!!."
    },
    {
      "name": "Zohaib Anwar",
      "image": "assets/images/r6.jpg",
      "rating": 4,
      "text": "Good value for the price, would recommend."
    },
  ];

  @override
  void initState() {
    super.initState();
    // FlutterPhoneDirectCaller.callNumber(widget.number);
  }


  void openWhatsApp(String phoneNumber) async {
    final String whatsappUrl = "https://wa.me/$phoneNumber"; // WhatsApp URL Scheme
    final Uri whatsappUri = Uri.parse(whatsappUrl);

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      print("Could not launch WhatsApp with phone number: $phoneNumber");
    }
  }

  void makePhoneCall(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      // Show an error message or handle the case when the number is empty
      print("Phone number is invalid.");
    } else {
      // Ensure the number is in a valid format, adding a '+' for international numbers if necessary
      String formattedPhoneNumber = phoneNumber.startsWith('+') ? phoneNumber : '+$phoneNumber';

      final Uri phoneUri = Uri(scheme: 'tel', path: formattedPhoneNumber);
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        print("Could not launch phone number: $formattedPhoneNumber");
      }
    }
  }


  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Displays an error message using SnackBar.
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Full-screen image starting from the top
                Container(
                  height: ResponsiveHelper.getHeight(context, 0.4),
                  width: double.infinity,
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover, // Ensures the image covers the entire area
                  ),
                ),
                // Top Row with Back and Filter buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 30, right: 8, bottom: 8),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black, size: 18),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 8, right: 30, bottom: 8),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: Icon(Icons.filter_center_focus, color: Colors.black, size: 18),
                            onPressed: () {
                              // Add your filter functionality here
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Property Info Below Image
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.price,
                        style: TextStyle(fontSize: 28, fontFamily: "Schyler", color: Color(0xFF204D6C)),

                      ),
                      // SizedBox(height: 8),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(widget.userimage,), // User Image
                          ),
                          SizedBox(width: 10),
                          Text(
                            widget.username,

                            style: TextStyle(fontSize: 18, fontFamily: "Schyler", color: Color(0xFF204D6C)),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  // Size
                  Row(

                    children: [
                      Text(
                        "Size :",
                        style: TextStyle(fontSize: 16, fontFamily: "family2",fontWeight: FontWeight.bold,color: Color(0xFF204D6C)),
                      ),
                      SizedBox(width: ResponsiveHelper.getWidth(context, .03),),
                      Text(
                        widget.size,
                        style: TextStyle(fontSize: 16, fontFamily: "family2",color: Color(0XFF53587A)),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Condition
                  Row(

                    children: [
                      Text(
                        "Condition :",
                        style: TextStyle(fontSize: 16, fontFamily: "family2",fontWeight: FontWeight.bold,color: Color(0xFF204D6C)),
                      ),
                      SizedBox(width: ResponsiveHelper.getWidth(context, .03),),
                      Text(
                        widget.condition,
                        style: TextStyle(fontSize: 16, fontFamily: "family2",color: Color(0XFF53587A)),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Property Details
                  Row(

                    children: [
                      Text(
                        "Contact Number :",
                        style: TextStyle(fontSize: 16, fontFamily: "family2",fontWeight: FontWeight.bold,color: Color(0xFF204D6C)),
                      ),
                      SizedBox(width: ResponsiveHelper.getWidth(context, .03),),
                      Text(
                        widget.number,
                        style: TextStyle(fontSize: 16, fontFamily: "family2",color: Color(0XFF53587A)),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),

                  Row(

                    children: [
                      Text(
                        "Type :",
                        style: TextStyle(fontSize: 16, fontFamily: "family2",fontWeight: FontWeight.bold,color: Color(0xFF204D6C)),
                      ),
                      SizedBox(width: ResponsiveHelper.getWidth(context, .03),),
                      Text(
                        widget.tag,
                        style: TextStyle(fontSize: 16, fontFamily: "family2",color: Color(0XFF53587A)),
                      ),
                    ],
                  ),


                  SizedBox(height: 16),

                  Row(
                    children: [
                      CircleAvatar(

                          backgroundColor:Color(0xFF204D6C),
                          radius: 15,
                          child: Icon(Icons.location_pin,color: Colors.white,size: 15,)),
                      SizedBox(width: ResponsiveHelper.getWidth(context, .03),),
                      Text(
                        widget.location,
                        style: TextStyle(fontSize: 16, fontFamily: "family2",color: Color(0XFF53587A)),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  Row(

                    children: [
                      Text(
                        "Details :",
                        style: TextStyle(fontSize: 16, fontFamily: "family2",fontWeight: FontWeight.bold,color: Color(0xFF204D6C)),
                      ),
                      SizedBox(width: ResponsiveHelper.getWidth(context, .03),),
                      Text(
                        widget.details,
                        style: TextStyle(fontSize: 16, fontFamily: "family2",color: Color(0XFF53587A)),
                      ),
                    ],
                  ),


                ],
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FloatingActionButton.extended(
                      onPressed: () {
                        // Add your message functionality here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              propertyId: widget.number,
                              propertyOwnerId: widget.uid2,
                             userimage: widget.userimage,
                              propertyOwnerName: widget.username,
                            ),
                          ),
                        );
                      },
                      label: Text('Message',style: TextStyle(fontFamily: "family2"),),
                      icon: FaIcon(FontAwesomeIcons.solidCommentDots),
                      backgroundColor: Color(0xFF8BC83F),
                    ),
                    FloatingActionButton.extended(

                      onPressed: () {
                        FlutterPhoneDirectCaller.callNumber(widget.number);

                      },
                      label: Text('Call',style: TextStyle(fontFamily: "family2")),
                      icon: Icon(Icons.phone),
                      backgroundColor: Color(0xFF234F68),
                    ),
                  ],
                ),
              ),
            ),


             Card(
                elevation: 0,

                margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                color: Color(0XFFF4FAEC),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage("assets/images/icon2.png"),
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "HLWN40",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Color(0XFF252B5C)),
                              ),
                              Text(
                                "Use this coupon to get 40% off ",
                                style: TextStyle(fontSize: 10, color: Color(0xFF53587A)),
                              ),

                            ],
                          ),
                        ],
                      ),

                    ],
                  ),

              ),
            ),


            Padding(

              padding: const EdgeInsets.only(left: 16.0),
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  "Reviews",
                  style: TextStyle(fontSize: 28, fontFamily: "Schyler", color: Color(0xFF204D6C)),

                ),
              ),
            ),
            SizedBox(height: 16),


            Consumer<ReviewProvider>(
    builder: (context, reviewProvider, child) {
    return             Column(
      children: [
        // Review 1
        for (int i = 0; i < (reviews.length <= 2 || reviewProvider.showAllReviews ? reviews.length : 2); i++)
          Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(reviews[i]["image"]),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reviews[i]["name"],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Row(
                            children: List.generate(
                              5,
                                  (index) => Icon(
                                index < reviews[i]["rating"]
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.yellow,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    reviews[i]["text"],
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ),
        // Show "Show More" button when there are more than 2 reviews
        if (reviews.length > 2 && !reviewProvider.showAllReviews)
          Padding(

            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: InkWell(
              onTap: () {
                reviewProvider.toggleShowAllReviews();  // Toggle the state using the provider
              },
              child: Align(
                alignment: Alignment.bottomRight,  // Center the text horizontally

                child: Text(
                  "Show More",  // The text displayed on the button
                  style: TextStyle(
                    fontSize: 14,

                    color: Color(0xFF204D6C),
                    fontFamily: "family2"// Customize the color as needed
                  ),
                ),
              ),
            )
          ),
        // Show "Show Less" button when all reviews are shown
        if (reviewProvider.showAllReviews)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
      onTap: () {
      reviewProvider.toggleShowAllReviews();  // Toggle the state using the provider
      },
      child: Align(
        alignment: Alignment.bottomRight,  // Center the text horizontally
        child: Text(
        "Show Less",  // The text displayed on the button
        style: TextStyle(
        fontSize: 16,
      color: Color(0xFF204D6C),
      fontFamily: "family2"        ),
        ),
      ),
      )
          ),
      // Repeat similar cards for other reviews
      ],
    );



    }),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text Field to enter the information (opens the keyboard when clicked)
                  Container(
                    height: ResponsiveHelper.getHeight(context, .1),
                    child: TextFormField(

                      controller: _controller,
                      // autofocus: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        // labelText: 'Enter your feedback or message',
                        hintText: 'Enter your feedback or message...',
                        filled: true,
                        fillColor: Color(0xFFE8E8E8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Color(0xFF1F4C6B), width: 2.0),
                        ),
                      ),
                      maxLines: 3, // Allow multiline input
                    ),
                  ),
                  SizedBox(height: 20),



                  Consumer<RatingProvider>(
                    builder: (context, ratingProvider, child) {
                      return Center(
                        child: RatingBar.builder(
                          initialRating: ratingProvider.rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize:20,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            ratingProvider.rating = rating; // Update rating using provider
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),
            // SingleChildScrollView(

            Padding(

              padding: const EdgeInsets.only(left: 16.0),
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  "Top Villas",
                  style: TextStyle(fontSize: 28, fontFamily: "Schyler", color: Color(0xFF204D6C)),

                ),
              ),
            ),
            SizedBox(height: 10),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 250, // Adjust height as needed
                child: GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, // Single row for horizontal scrolling
                    childAspectRatio: .8, // Adjust card aspect ratio for horizontal layout
                  ),
                  itemCount: 4, // Example static count
                  itemBuilder: (context, index) {
                    // Lists of data for each property
                    final propertySizes = ['1200 sq ft', '1500 sq ft', '1000 sq ft', '900 sq ft'];
                    final propertyPrices = ['\$200,000', '\$250,000', '\$180,000', '\$150,000'];
                    final propertyAddresses = [
                      '123 Main St, Cityville',
                      '456 Elm St, Townsville',
                      '789 Pine St, Suburbia',
                      '101 Maple St, Villageland'
                    ];
                    final conditions = ['Excellent', 'Good', 'Fair', 'New'];
                    final userNames = ['Nihal ', 'Ahmed ', 'Ali ', 'Nubaid '];
                    final userImages = [
                      'assets/images/nihal.jpg',
                      'assets/images/ahmed.jpg',
                      'assets/images/r3.jpg',
                      'assets/images/r4.jpg'
                    ];
                    final propertyImages = [
                      'assets/images/detail1.jpg',
                      'assets/images/detail2.jpg',
                      'assets/images/detail3.jpg',
                      'assets/images/detail4.webp'
                    ];

                    return GestureDetector(
                      onTap: () {
                        // Handle tap
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 4,
                          child: Row(
                            children: [
                              // Left: Image (75% width)
                              Expanded(
                                flex: 65, // 75% width
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    child: Image.asset(
                                      propertyImages[index], // Use index to select the image
                                      fit: BoxFit.cover,
                                      height: 200,
                                    ),
                                  ),
                                ),
                              ),

                              // Right: Details (25% width)
                              Expanded(
                                flex: 35, // 25% width
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Property Price
                                      Text(
                                        propertyPrices[index],
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF234F68),
                                        ),
                                      ),
                                      SizedBox(height: 8),

                                      // Property Size
                                      Text(
                                        propertySizes[index],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF252B5C),
                                        ),
                                      ),
                                      SizedBox(height: 8),

                                      // Property Address
                                      Row(
                                        children: [
                                          Icon(Icons.location_pin, size: 15, color: Colors.grey),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              propertyAddresses[index],
                                              style: TextStyle(fontSize: 12, color: Colors.grey),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),


                                      SizedBox(height: 8),

                                      // Property Condition
                                      Text(
                                        conditions[index],
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Spacer(),

                                      // User Info
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 12,
                                            backgroundImage: AssetImage(userImages[index]),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            userNames[index],
                                            style: TextStyle(fontSize: 10, color: Colors.black),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: TextField(
            //     // controller: _numberCtrl,
            //     decoration: const InputDecoration(labelText: "Phone Number"),
            //     keyboardType: TextInputType.number,
            //   ),
            // ),
            // ElevatedButton(
            //   child: const Text("Test Call"),
            //   onPressed: () async {
            //     FlutterPhoneDirectCaller.callNumber(_numberCtrl);
            //   },
            // )
            // // Spacer(),
            // Floating Action Buttons at the bottom
          ],
        ),

      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FloatingActionButton(
          onPressed: () {
            openWhatsApp("03174433711"); // Pass the number to open WhatsApp
          },
          // label: Text('WhatsApp'),
          hoverElevation: 5,
          child: FaIcon(FontAwesomeIcons.whatsapp),

          backgroundColor: Color(0xFF25D366), // WhatsApp Green Color
        ),
      ),
    );

  }
}


