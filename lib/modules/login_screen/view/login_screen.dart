import 'package:flutter/material.dart';
import 'package:realestate/shared/utils/app_images/app_images.dart';
import 'package:realestate/shared/utils/responsive_helper/responsive_helper.dart';
import 'package:realestate/shared/widgets/custom_button.dart';
import 'package:realestate/shared/theme/app_color/app_Colors.dart';
import 'package:realestate/routes/routes_name.dart'; // Ensure correct import
import 'package:realestate/routes/routes.dart'; // Ensure correct import
import 'package:realestate/shared/widgets/Custom_container.dart';
import 'package:realestate/modules/welcome_screen/view/welcome_screen.dart';
import 'package:realestate/modules/welcome_screen/view/welcome_screen3.dart';
import 'package:realestate/modules/welcome_screen/view/welcome_screen4.dart';
import 'package:realestate/modules/login_screen/view/login_screen2.dart';
import 'package:realestate/modules/signup/view/signup_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:realestate/services/auth_service.dart';




class login extends StatelessWidget {
  const login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Column(
        children: [
          // Adjusted the GridView to take up a fixed height
          Container(
            height: MediaQuery.of(context).size.height * 0.55, // Adjust the height as needed
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: ResponsiveHelper.getWidth(context, .1),
                    height: ResponsiveHelper.getHeight(context, .1),
                    child: Image.asset(
                      AppImages().loginimg1,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: ResponsiveHelper.getWidth(context, .1),
                    height: ResponsiveHelper.getHeight(context, .1),
                    child: Image.asset(
                      AppImages().loginimg2,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: ResponsiveHelper.getWidth(context, .1),
                    height: ResponsiveHelper.getHeight(context, .1),
                    child: Image.asset(
                      AppImages().loginimg3,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: ResponsiveHelper.getWidth(context, .1),
                    height: ResponsiveHelper.getHeight(context, .1),
                    child: Image.asset(
                      AppImages().loginimg4,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Ensure RichText is visible after the GridView

             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Align(
                 alignment: AlignmentDirectional.centerStart,
                 child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Ready to ",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      TextSpan(
                        text: "explore?",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF204D6C)), // Change color as needed
                      ),
                    ],
                  ),

                           ),
               ),
             ),
          SizedBox(height: ResponsiveHelper.getHeight(context, .04),),
          CustomButton(buttonText: "Continue with Email", color: Color(0xFF8BC83F), textColor: Colors.white,borderRadius: BorderRadius.circular(10),width: ResponsiveHelper.getWidth(context, .8),onPress: (){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Login2(),
              ),
            );

          },),
          SizedBox(height: ResponsiveHelper.getHeight(context, .05),),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1.0,
                  ),
                ),
                // Center Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'OR',
                    style: TextStyle(fontSize: 16, color: Color(0xFF4A4A4A)),
                  ),
                ),
                // Right Divider
                Expanded(
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1.0,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){
                    AuthService().signInWithGoogle();
                  },
                  child: Container(
                    // color: Colors.grey,

                    height: ResponsiveHelper.getHeight(context, .09),
                    width: ResponsiveHelper.getWidth(context, .4),
                    child: Image.asset(
                      AppImages().googleimg

                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFFE0E0E0)

                    ),
                  ),
                ),

                Container(
                  height: ResponsiveHelper.getHeight(context, .09),
                  width: ResponsiveHelper.getWidth(context, .4),
                  child: Image.asset(
                      AppImages().fbimg
                  ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFFE0E0E0)

                    )
                )
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: InkWell(
              onTap: (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Signup(),
                  ),
                );
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    TextSpan(
                      text: "Register",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF204D6C)), // Change color as needed
                    ),
                  ],
                ),

              ),
            ),
          ),
        ],
      ),

    );
  }
}
