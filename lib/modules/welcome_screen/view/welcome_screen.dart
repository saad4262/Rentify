import 'package:flutter/material.dart';
import 'package:realestate/modules/welcome_screen/view/welcome_screen2.dart';
import 'package:realestate/shared/utils/app_images/app_images.dart';
import 'package:realestate/shared/utils/responsive_helper/responsive_helper.dart';
import 'package:realestate/shared/widgets/custom_button.dart';
import 'package:realestate/shared/theme/app_color/app_Colors.dart';
import 'package:realestate/shared/widgets/Custom_container.dart';
import 'package:realestate/routes/routes_name.dart';
import 'package:realestate/routes/routes.dart';
import 'package:realestate/modules/welcome_screen/view/welcome_screen3.dart';
import 'package:realestate/modules/welcome_screen/view/welcome_screen4.dart';



class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            AppImages().bgImage,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF234F68).withOpacity(1 ),
                  Color(0xFF21628A).withOpacity(0.2),
                ],
                stops: [0.0, 10.0],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              SizedBox(height:MediaQuery.of(context).size.height*.3,),

              Center(
                child: Image.asset(
                    AppImages().logo,
                  ),
              ),
              Text("Rentify",style: TextStyle(color: AppColors.whiteColor,fontSize: 34,fontWeight: FontWeight.bold),),
              SizedBox(height: ResponsiveHelper.getHeight(context, .2),),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomContainer(color: AppColors.whiteColor),
                  SizedBox(width: ResponsiveHelper.getWidth(context, .003),),
                  CustomContainer(color: AppColors.lightWhiteColor,onPress: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WelcomeScreen2(),
                      ),
                    );
                  },),
                  SizedBox(width: ResponsiveHelper.getWidth(context, .003),),

                  CustomContainer(color: AppColors.lightWhiteColor,onPress: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WelcomeScreen3(),
                      ),
                    );
                  },),
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


              CustomButton(buttonText: "let's start", color: AppColors.btnColor, textColor: AppColors.whiteColor,borderRadius: BorderRadius.circular(10),width: ResponsiveHelper.getWidth(context, .5),
                onPress:() {
                print("object");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WelcomeScreen2(),
                  ),
                );        },),
              SizedBox(height: ResponsiveHelper.getHeight(context, .03),),

              Padding(
                  padding:  EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Terms & Conditions',
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
              ),



            ],
          ),
        ],
      ),
    );
  }
}
