import 'package:flutter/material.dart';
import 'package:realestate/shared/utils/app_images/app_images.dart';
import 'package:realestate/shared/utils/responsive_helper/responsive_helper.dart';
import 'package:realestate/shared/widgets/custom_button.dart';
import 'package:realestate/shared/theme/app_color/app_Colors.dart';
import 'package:realestate/routes/routes_name.dart'; // Ensure correct import
import 'package:realestate/routes/routes.dart'; // Ensure correct import
import 'package:realestate/shared/widgets/Custom_container.dart';
import 'package:realestate/modules/welcome_screen/view/welcome_screen.dart';
import 'package:realestate/modules/welcome_screen/view/welcome_screen2.dart';

import 'package:realestate/modules/welcome_screen/view/welcome_screen4.dart';





class WelcomeScreen3 extends StatelessWidget {
  const WelcomeScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Image.asset(
          AppImages().logo,
          height: 100,

        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: CustomButton(buttonText: "skip", color: Color(0xFFF5F4F8), textColor: Colors.black,borderRadius: BorderRadius.circular(30),width: ResponsiveHelper.getWidth(context, .3),),
          )
        ],
      ),
      body: Column(
        children: [

          SizedBox(height: ResponsiveHelper.getHeight(context, .1),),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Fast sell your property in just  ",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  TextSpan(
                    text: "one click",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF204D6C)), // Change color as needed
                  ),

                ],
              ),
            ),
          ),

          SizedBox(height: ResponsiveHelper.getHeight(context, .03),),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text("Explore homes that fit your life.Discover spaces designed for you."),
          ),
          // SizedBox(height: ResponsiveHelper.getHeight(context, .1),),

          // Stack(
          //   children: [
          //     Image.asset(
          //       height: ResponsiveHelper.getHeight(context, .5),
          //       width: ResponsiveHelper.getWidth(context, 2),
          //       AppImages().bg2
          //     )
          //   ],
          // ),

        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          height: ResponsiveHelper.getHeight(context, .6), // 50% of the screen height
          child: Stack(
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Center(
                  child: Image.asset(
                    AppImages().bg3,

                    height: ResponsiveHelper.getHeight(context, .6),
                    width: ResponsiveHelper.getWidth(context, .95),
                    fit: BoxFit.cover,

                  ),
                ),
              ),
              Positioned(
                  bottom: ResponsiveHelper.getHeight(context, .07),
                  left: ResponsiveHelper.getWidth(context, .08),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WelcomeScreen2(), // Target screen
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 25.0, // Adjust the size of the circle here
                          backgroundColor: Colors.white, // Circle background color
                          child: Icon(
                            Icons.arrow_back, // Back arrow icon
                            color: Colors.black, // Icon color
                            size: 20.0, // Size of the icon
                          ),
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.getWidth(context, .05),),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomContainer(color: AppColors.whiteColor, onPress: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WelcomeScreen(),
                                  ),
                                );
                              }, ),
                              SizedBox(width: ResponsiveHelper.getWidth(context, .003),),
                              CustomContainer(color: AppColors.whiteColor,onPress: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WelcomeScreen2(),
                                  ),
                                );
                              },),
                              SizedBox(width: ResponsiveHelper.getWidth(context, .003),),

                              CustomContainer(color: AppColors.whiteColor),
                              SizedBox(width: ResponsiveHelper.getWidth(context, .003),),

                              CustomContainer(color: AppColors.lightWhiteColor,onPress: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WelcomeScreen4(),
                                  ),
                                );
                              },),
                            ],
                          ),
                          SizedBox(height: ResponsiveHelper.getHeight(context, .03),),



                          // mainAxisAlignment: MainAxisAlignment.start,


                          CustomButton(buttonText: "Next", color: AppColors.btnColor, textColor: AppColors.whiteColor,borderRadius: BorderRadius.circular(10),width: ResponsiveHelper.getWidth(context, .5),
                            onPress:() {
                              print("object");
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WelcomeScreen4(),
                                ),
                              );        },),


                        ],
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),

    );
  }
}
