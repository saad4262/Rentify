import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:realestate/modules/home/view/home1.dart';
import 'package:realestate/modules/login_screen/view/login_screen.dart';
import 'package:realestate/modules/rent/view/rent_screen.dart';
import 'package:realestate/modules/sell/view/sell_screen.dart';
import 'package:realestate/modules/home/view/home1.dart';
import '../../modules/home/view/favorite1.dart';

class CustomDrawer extends StatelessWidget {
  final String? uid;
  final String? imageUrl;
  final String? name;
  final String? number;
  final Function? onDrawerItemTap;

  const CustomDrawer({
    Key? key,
     this.uid,
    this.imageUrl,
     this.name,
     this.number,
     this.onDrawerItemTap,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(color: Color(0xFF234F68)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(imageUrl ?? 'assets/images/person1.png'),
                ),
                SizedBox(height: 10),
                Text(
                  name ?? '',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "family2"),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _drawerItem(context, Icons.home, 'Home', () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => home1( uid: uid!, imageUrl: imageUrl, name: name ?? '', number: number ?? ''
            )));          }),

          _drawerItem(context, Icons.apartment, 'Rent', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RentScreen( uid: uid,
              name: name,
              number: number,
              imageUrl: imageUrl,
            )));
          }),
          _drawerItem(context, Icons.sell, 'Sell', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SellScreen( uid: uid,
              name: name,
              number: number,
              imageUrl: imageUrl,
            )));
          }),
          _drawerItem(context, Icons.favorite, 'Wishlist', () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FavoriteProperties1(uid: uid,
              name: name,
              number: number,
              imageUrl: imageUrl,)));
          }),
          _drawerItem(context, Icons.settings, 'Settings', () {
            Navigator.pop(context);
          }),
          _drawerItem(context, Icons.logout, 'Logout', () async {
            await FirebaseAuth.instance.signOut();

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => login()));
          }),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, Function onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: TextStyle(fontFamily: "family2")),
        onTap: () => onTap(),
      ),
    );
  }
}
