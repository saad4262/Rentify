import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
// import 'location_provider.dart';
import 'package:realestate/modules/map/viewmodel/location_provider.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:realestate/shared/widgets/custom_button.dart';
import 'package:realestate/shared/utils/responsive_helper/responsive_helper.dart';
import 'package:realestate/shared/utils/app_images/app_images.dart';
import 'package:realestate/modules/map/view/map_screen.dart';


class MapScreen1 extends StatelessWidget {
  final String uid;

  MapScreen1({required this.uid});
  @override
  Widget build(BuildContext context) {
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
                child: InkWell(
                    // onTap: (){
                    //   Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => MapScreen1(),
                    //     ),
                    //   );
                    //
                    // },

                    child: Icon(Icons.arrow_back_ios_new))),

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
                      builder: (context) => MapScreen(uid:uid),
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

        Text("Location detail",style: TextStyle(color: Color(0xFF1F4C6B )),),
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
              // onPress: (){
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
}
