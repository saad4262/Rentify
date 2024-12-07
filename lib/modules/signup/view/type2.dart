import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realestate/modules/signup/viewmodel/type_provider.dart'; // Import your provider file
import 'package:realestate/shared/utils/responsive_helper/responsive_helper.dart';
import 'package:realestate/shared/widgets/custom_button.dart';
import 'package:realestate/shared/theme/app_color/app_colors.dart';
import 'package:realestate/modules/welcome_screen/view/welcome_screen3.dart';
import 'package:realestate/modules/signup/view/type1.dart';
import 'package:realestate/modules/signup/view/info1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class type2 extends StatefulWidget {
  final String uid;
  const type2({super.key,  required this.uid,
  });

  @override
  State<type2> createState() => _type2State();
}

class _type2State extends State<type2> {


  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

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
                    child: Icon(Icons.arrow_back_ios_new)),

                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CustomButton(buttonText: 'skip', color: Color(0xFFF5F4F8), textColor: Color(0xFF1F4C6B ),borderRadius: BorderRadius.circular(30),
                    width: ResponsiveHelper.getWidth(context, .3),height: ResponsiveHelper.getHeight(context, .07),
                      onPress: (){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => type1(uid:widget.uid),
                          ),
                        );
                      }
                  ),
                )
              ],
            ),

            SizedBox(height: ResponsiveHelper.getHeight(context, .07)),
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
      bottomNavigationBar: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0.0),
          child: Container(
            height: ResponsiveHelper.getHeight(context, .65),
            child: Stack(
              children: [
                Consumer<CategoryProvider>(
                  builder: (context, categoryProvider, child) {
                    return GridView.builder(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: .85,
                        crossAxisCount: 2,
                      ),
                      itemCount: categoryProvider.categoriesList.length,
                      itemBuilder: (context, index) {
                        final category = categoryProvider.categoriesList[index];
                        return GestureDetector(
                          onTap: () => categoryProvider.toggleSelection(index),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 4,
                              color: categoryProvider.selectedImages[index]
                                  ? Color(0xFF1F4C6B)
                                  : Colors.white,
                              child: Column(
                                children: [
                                  Container(
                                    height: ResponsiveHelper.getHeight(context, .2),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          height: ResponsiveHelper.getHeight(context, .19),
                                          width: ResponsiveHelper.getWidth(context, .4),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: SizedBox(
                                              width: double.infinity,
                                              height: ResponsiveHelper.getHeight(context, .2),
                                              child: Image.asset(
                                                category.imagePath,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (categoryProvider.selectedImages[index])
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 24,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    category.name,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: categoryProvider.selectedImages[index] ? Colors.white : Colors.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
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
                    onPress: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        String uid = user.uid;
                        List<String> selectedCategories = categoryProvider.getSelectedCategories();
                        try {
                          await FirebaseFirestore.instance.collection('users').doc(uid).set({
                            'selectedRealEstateTypes': selectedCategories,
                          }, SetOptions(merge: true));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => info1(uid: widget.uid,)),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error saving types: ${e.toString()}")),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("User is not logged in")),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),    );
  }
}
