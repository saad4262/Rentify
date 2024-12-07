import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realestate/modules/login_screen/view/login_screen2.dart';
import 'package:realestate/shared/utils/app_images/app_images.dart';
import 'package:realestate/shared/utils/responsive_helper/responsive_helper.dart';
import 'package:realestate/shared/widgets/custom_button.dart';
import 'package:realestate/shared/theme/app_color/app_Colors.dart';
import 'package:realestate/modules/login_screen/viewmodel/providerlogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:realestate/modules/login_screen/view/login_screen2.dart';
import 'package:realestate/modules/map/view/map_screen1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realestate/shared/widgets/custom_flushbar.dart';
import 'package:realestate/modules/login_screen/viewmodel/providerlogin.dart';




class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance


  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  height: ResponsiveHelper.getHeight(context, .25),
                  AppImages().loginimg5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Create your ",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          TextSpan(
                            text: "account",
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF204D6C)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveHelper.getHeight(context, .04)),
                // Email Text Field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFE8E8E8),
                      labelText: 'Email',
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
                      prefixIcon: Icon(Icons.email),
                      contentPadding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegExp.hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                ),
                // Password Text Field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<PasswordVisibilityProvider>(
                    builder: (context, provider, child) {
                      return TextFormField(
                        controller: _passwordController,
                        obscureText: provider.isObscure,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFE8E8E8),
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0xFFE8E8E8)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0xFFE8E8E8), width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0xFF1F4C6B), width: 2.0),
                          ),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(provider.isObscure ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              provider.toggleVisibility(); // Toggle visibility
                            },
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                ),
                // Confirm Password Text Field
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<PasswordVisibilityProvider>(
                    builder: (context, provider, child) {
                      return TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: provider.isObscure,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFE8E8E8),
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0xFFE8E8E8)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0xFFE8E8E8), width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0xFF1F4C6B), width: 2.0),
                          ),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(provider.isObscure ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              provider.toggleVisibility(); // Toggle visibility
                            },
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: ResponsiveHelper.getHeight(context, .02)),
                Padding(
                  padding: const EdgeInsets.only(right: 20, bottom: 16),
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login2(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            TextSpan(
                              text: "Login",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF204D6C)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    Consumer<FormValidationProvider>(
    builder: (context, provider, child) {
      return CustomButton(
        buttonText: "Register",
        color: Color(0xFF8BC83F),
        textColor: Colors.white,
        borderRadius: BorderRadius.circular(10),
        width: ResponsiveHelper.getWidth(context, .8),
        isLoading: provider.isLoading,

        onPress: provider.isLoading // Disable if loading
            ? null : () async {
          final authProvider = Provider.of<FormValidationProvider>(
              context, listen: false);
          authProvider.setLoading(true); // Set loading to true

          try {
            if (_formKey.currentState!.validate()) {
              // Create user
              UserCredential userCredential = await _auth
                  .createUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
              );

              // Get user ID
              String uid = userCredential.user!.uid;

              // Store user data in Firestore
              await _firestore.collection('users').doc(uid).set({
                'email': _emailController.text.trim(),
                'imageUrl': 'path/to/image.png',
                // Ensure this field is included
                'locations': [],
                // Initialize with an empty list or default values
                'createdAt': FieldValue.serverTimestamp(),
              });

              // Show success message
              CustomFlushbar(message: "Account Successfully Create ",
                  color: Colors.green,
                  title: "Success").show(context);


              // Navigate to the next screen
              if (mounted) { // Ensure the widget is still mounted
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen1(uid: uid),
                  ),
                );
              }
            }
          } catch (e) {
            print("Error: $e");
            CustomFlushbar(
              message: "Error creating account: ${e.toString()}",
              color: Colors.red,
              title: "Error",
            ).show(context);
          } finally {
            authProvider.setLoading(false); // Reset loading state
          }
        },

      );
    }
    ),
                SizedBox(height: ResponsiveHelper.getHeight(context, .07)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
