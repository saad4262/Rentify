import 'dart:io';
import 'package:flutter/material.dart';
import 'package:realestate/modules/home/view/home1.dart';
import 'package:realestate/modules/signup/view/type2.dart';
import 'package:realestate/shared/utils/responsive_helper/responsive_helper.dart';
import 'package:realestate/shared/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realestate/modules/signup/viewmodel/info_provider.dart';


class info1 extends StatefulWidget {
  final String uid;


  const info1({super.key, required this.uid});

  @override
  State<info1> createState() => _info1State();
}

class _info1State extends State<info1> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final firestore = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ImagePickerProvider(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 30),
            child: Consumer<ImagePickerProvider>(
              builder: (context, imagePickerProvider, child) {
                return Column(
                  children: [
                    _buildHeader(context),
                    SizedBox(height: ResponsiveHelper.getHeight(context, .06)),
                    _buildTitle(),
                    SizedBox(height: ResponsiveHelper.getHeight(context, .03)),
                    _buildSubtitle(),
                    _buildProfileImage(imagePickerProvider),
                    _buildFormFields(),
                    SizedBox(height: ResponsiveHelper.getHeight(context, .05)),
                    if (imagePickerProvider.isLoading)
                      CircularProgressIndicator(),

                    _buildFinishButton(imagePickerProvider),                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => type2(uid: widget.uid)),
            );
          },
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF5F4F8),
            child: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: CustomButton(
            buttonText: 'Skip',
            color: const Color(0xFFF5F4F8),
            textColor: const Color(0xFF1F4C6B),
            borderRadius: BorderRadius.circular(30),
            width: ResponsiveHelper.getWidth(context, .3),
            height: ResponsiveHelper.getHeight(context, .07),
            onPress: () {
              // Handle skip action
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Fill your ",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            TextSpan(
              text: "information below",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF204D6C)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: const Text("You can edit this later on your account settings."),
    );
  }

  void _showSuccessBottomSheet(BuildContext context, String? imageUrl,String? name, String? number) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Stack(
                children: [
                Image.asset("assets/images/shape2.png") ,
                  Positioned(
                    top: 30,
                    left: 30,
                    child:
                  Image.asset("assets/images/shape1.png") ,

                  ),

                ],
              ),
              RichText(
                textAlign: TextAlign.center,

                text: TextSpan(

                  children: [
                    TextSpan(
                      text: "Account  ",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    TextSpan(
                      text: "successfully created!",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF204D6C)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              CustomButton(
                buttonText: "Finish",
                color: Color(0xFF8BC83F),
                textColor: Colors.white,
                borderRadius: BorderRadius.circular(10),
                width: ResponsiveHelper.getWidth(context, .5),
                onPress: () {
                  Navigator.pop(context); // Close the bottom sheet
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => home1(uid: widget.uid,imageUrl: imageUrl,name:  _nameController.text.trim(),number:_numberController.text.trim())),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

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

  Widget _buildFormFields() {
    return Column(
      children: [
        _buildTextField(_nameController, 'Full Name', Icons.person),
        _buildTextField(_numberController, 'Phone Number', Icons.call),
        _buildTextField(_emailController, 'Email', Icons.email),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFE8E8E8),
          labelText: label,
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
          prefixIcon: Icon(icon),
          contentPadding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
        ),
      ),
    );
  }

  Widget _buildFinishButton(ImagePickerProvider imagePickerProvider) {
    return CustomButton(
      buttonText: "Finish",
      color: Color(0xFF8BC83F),
      textColor: Colors.white,
      borderRadius: BorderRadius.circular(10),
      width: ResponsiveHelper.getWidth(context, .8),
      onPress: imagePickerProvider.isLoading ? null : () async { // Disable button if loading
        imagePickerProvider.setLoading(true); // Start loading

        String? imageUrl;

        // Upload image to Firebase Storage if selected
        if (imagePickerProvider.imageFile != null) {
          final imageFile = File(imagePickerProvider.imageFile!.path); // Convert XFile to File
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          Reference storageRef = FirebaseStorage.instance.ref().child('user_images/$fileName');

          try {
            await storageRef.putFile(imageFile); // Use the converted File
            imageUrl = await storageRef.getDownloadURL();
          } catch (e) {
            Flushbar(
              message: "Error uploading image: ${e.toString()}",
              duration: Duration(seconds: 3),
            ).show(context);
            imagePickerProvider.setLoading(false); // Stop loading
            return; // Exit if upload fails
          }
        }

        // Save user data to Firestore using the uid
        try {
          await firestore.doc(widget.uid).set({
            'infoUser': {
              'fullName': _nameController.text.trim(),
              'email': _emailController.text.trim(),
              'phoneNumber': _numberController.text.trim(),
              'imageUrl': imageUrl, // Store the image URL here
            },
          }, SetOptions(merge: true));
          _showSuccessBottomSheet(context,imageUrl, _nameController.text.trim(), _numberController.text.trim());
        } catch (e) {
          Flushbar(
            message: "Error saving user data: ${e.toString()}",
            duration: Duration(seconds: 3),
          ).show(context);
        } finally {
          imagePickerProvider.setLoading(false); // Stop loading
        }
      },
    );
  }
}