import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:realestate/modules/home/viewmodel/home1provider.dart';
import '../../../shared/widgets/custom_bottomnavbar.dart';
import '../viewmodel/home1provider.dart';

class FavoriteProperties extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(


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

                        // Navigator.popUntil(context, ModalRoute.withName('/home1')); // Example
                      }, // Open drawer on tap
                      child: CircleAvatar(
                        backgroundColor: Color(0xFFF5F4F8),
                        child: Icon(Icons.arrow_back_ios_new_outlined),
                      ),
                    ),
                    SizedBox(width: 50,),
                    Text("My Wishlist",style: TextStyle(fontSize: 28, fontFamily: "Schyler", color: Color(0xFF204D6C)),)


                  ],
                ),



              ],


            ),
          ),

          Expanded(
            child: Consumer<FavoriteProvider>(
              builder: (context, favoriteProvider, child) {
                return favoriteProvider.favorites.isEmpty
                    ? Center(child: Text('No favorite properties.'))
                    : ListView.builder(
                  itemCount: favoriteProvider.favorites.length,
                  itemBuilder: (context, index) {
                    final propertyId = favoriteProvider.favorites.keys.toList()[index];
                    final propertyData = favoriteProvider.favorites[propertyId];

                    // Ensure that propertyData is not null before accessing its keys
                    if (propertyData == null) {
                      return ListTile(
                        title: Text('No data available'),
                      );
                    }

                    // Safely access the properties of propertyData
                    final propertySize = propertyData['size'] ?? 'N/A';
                    final propertyLocation = propertyData['location_name'] ?? 'N/A';
                    final propertyImageUrl = propertyData['imageUrl'] ?? ''; // Assuming imageUrl is in propertyData

                    return Card(
                      elevation: 5, // Add elevation for a shadow effect
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Circular border radius
                      ),
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Margin around the card
                      child: ListTile(
                        contentPadding: EdgeInsets.all(8.0), // Padding inside the ListTile
                        leading: propertyImageUrl.isNotEmpty
                            ? CircleAvatar(
                          radius: 25, // Circle Avatar size
                          backgroundImage: NetworkImage(propertyImageUrl),
                          backgroundColor: Colors.transparent,
                        )
                            : CircleAvatar(
                          radius: 25, // Default circle avatar size
                          backgroundColor: Colors.grey[200], // Default background color
                          child: Icon(Icons.image, size: 30, color: Colors.grey), // Default icon
                        ),
                        title: Text(
                          propertySize,
                          style: TextStyle(fontWeight: FontWeight.bold), // Add bold text style
                        ),
                        subtitle: Text(
                          propertyLocation,
                          style: TextStyle(color: Colors.grey), // Subtle color for subtitle
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            favoriteProvider.toggleFavorite(propertyId, propertyData);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

        ],

      ),
        // bottomNavigationBar:DockingBar(uid: uid,name: widget.name, number: widget.number,) // Pass the current index from the state

    );
  }
}
