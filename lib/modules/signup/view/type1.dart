import 'package:flutter/material.dart';
import 'package:realestate/modules/signup/view/type2.dart';
import 'package:realestate/shared/utils/app_images/app_images.dart';
import 'package:realestate/shared/utils/responsive_helper/responsive_helper.dart';
import 'package:realestate/shared/widgets/custom_button.dart';
import 'package:realestate/shared/theme/app_color/app_colors.dart';
import 'package:realestate/modules/welcome_screen/view/welcome_screen3.dart';
import 'package:realestate/modules/signup/view/type2.dart';
import 'package:realestate/modules/map/view/map_screen2.dart';
import 'package:realestate/modules/map/viewmodel/location_provider.dart';
import 'package:provider/provider.dart';


class type1 extends StatelessWidget {
  final String uid;
  const type1({super.key,    required this.uid,});



  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: Padding(

        padding: const EdgeInsets.only(left: 8.0,top: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    if (locationProvider.selectedPlaceName.isNotEmpty) {
                      // Navigate to the next screen with the selected location
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapScreen2(
                            uid: uid, // Pass the UID to MapScreen2
                            selectedLocation: locationProvider.selectedPlaceLatLng!,
                            selectedPlaceName: locationProvider.selectedPlaceName,
                            selectedPlaceAddress: locationProvider.selectedPlaceAddress,
                          ),
                        ),
                      );
                    } else {
                      // Handle if no place is selected (optional)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please select a location")),
                      );
                    }
                  },

                  child: CircleAvatar(

                      backgroundColor: Color(0xFFF5F4F8),
                      child: Icon(Icons.arrow_back_ios_new)),
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CustomButton(buttonText: 'skip', color: Color(0xFFF5F4F8), textColor: Color(0xFF1F4C6B ),borderRadius: BorderRadius.circular(30),
                    width: ResponsiveHelper.getWidth(context, .3),height: ResponsiveHelper.getHeight(context, .07),
                  ),
                )
              ],
            ),

            SizedBox(height: ResponsiveHelper.getHeight(context, .06)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Select your preferable ",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    TextSpan(
                      text: "real estate type ",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF204D6C)),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: ResponsiveHelper.getHeight(context, .03)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text("You can edit this later on your account settings."),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          height: ResponsiveHelper.getHeight(context, .63), // Adjusted for better usability
          child: Stack(
            children: [
              GridView.count(
                crossAxisCount: 3,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      width: ResponsiveHelper.getWidth(context, .1),
                      height: ResponsiveHelper.getHeight(context, .1),
                      child: Image.asset(
                        AppImages().image9,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      width: ResponsiveHelper.getWidth(context, .1),
                      height: ResponsiveHelper.getHeight(context, .1),
                      child: Image.asset(
                        AppImages().image10,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      width: ResponsiveHelper.getWidth(context, .1),
                      height: ResponsiveHelper.getHeight(context, .1),
                      child: Image.asset(
                        AppImages().image11,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      width: ResponsiveHelper.getWidth(context, .1),
                      height: ResponsiveHelper.getHeight(context, .1),
                      child: Image.asset(
                        AppImages().image13,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      width: ResponsiveHelper.getWidth(context, .1),
                      height: ResponsiveHelper.getHeight(context, .1),
                      child: Image.asset(
                        AppImages().image14,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      width: ResponsiveHelper.getWidth(context, .1),
                      height: ResponsiveHelper.getHeight(context, .1),
                      child: Image.asset(
                        AppImages().image15,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      width: ResponsiveHelper.getWidth(context, .1),
                      height: ResponsiveHelper.getHeight(context, .1),
                      child: Image.asset(
                        AppImages().image16,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      width: ResponsiveHelper.getWidth(context, .1),
                      height: ResponsiveHelper.getHeight(context, .1),
                      child: Image.asset(
                        AppImages().image17,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      width: ResponsiveHelper.getWidth(context, .1),
                      height: ResponsiveHelper.getHeight(context, .1),
                      child: Image.asset(
                        AppImages().image18,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      width: ResponsiveHelper.getWidth(context, .1),
                      height: ResponsiveHelper.getHeight(context, .1),
                      child: Image.asset(
                        AppImages().image19,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      width: ResponsiveHelper.getWidth(context, .1),
                      height: ResponsiveHelper.getHeight(context, .1),
                      child: Image.asset(
                        AppImages().image20,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      width: ResponsiveHelper.getWidth(context, .1),
                      height: ResponsiveHelper.getHeight(context, .1),
                      child: Image.asset(
                        AppImages().image21,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      width: ResponsiveHelper.getWidth(context, .1),
                      height: ResponsiveHelper.getHeight(context, .1),
                      child: Image.asset(
                        AppImages().image22,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      width: ResponsiveHelper.getWidth(context, .1),
                      height: ResponsiveHelper.getHeight(context, .1),
                      child: Image.asset(
                        AppImages().image23,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      width: ResponsiveHelper.getWidth(context, .1),
                      height: ResponsiveHelper.getHeight(context, .1),
                      child: Image.asset(
                        AppImages().image24,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),


                ],
              ),
              Positioned(
                bottom: ResponsiveHelper.getHeight(context, .06),
                left: ResponsiveHelper.getWidth(context, .15),
                child: CustomButton(
                  buttonText: "Show more",
                  color: AppColors.btnColor,
                  textColor: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  width: ResponsiveHelper.getWidth(context, .7),
                  onPress: () {
                    print("Next button pressed");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => type2(uid:uid),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
