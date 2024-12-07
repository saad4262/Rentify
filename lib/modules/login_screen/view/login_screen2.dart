import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:provider/provider.dart';
import 'package:realestate/shared/utils/app_images/app_images.dart';
import 'package:realestate/shared/utils/responsive_helper/responsive_helper.dart';
import 'package:realestate/modules/login_screen/viewmodel/providerlogin.dart';
import 'package:realestate/modules/signup/view/signup_screen.dart';
import 'package:realestate/shared/widgets/custom_button.dart'; // Ensure this import is correct
import 'package:realestate/modules/map/view/map_screen1.dart';
import 'package:realestate/modules/home/view/home1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:realestate/shared/widgets/custom_flushbar.dart'; // Ensure this import is correct




class Login2 extends StatefulWidget {
  const Login2({super.key});

  @override
  State<Login2> createState() => _Login2State();
}

class _Login2State extends State<Login2> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Key to manage the form state

  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false; // Add this line



  void loginfunc() async {
    final authProvider = Provider.of<FormValidationProvider>(context, listen: false);
    authProvider.setLoading(true); // Set loading to true
    try {
      print("Email: ${_emailController.text}");
      print("Password: ${_passwordController.text}");

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        print("User Data: $userData"); // Debug statement

        // Access the infoUser field
        var infoUser = userData['infoUser'];

        // Make sure infoUser is not null and contains the expected fields
        String name = infoUser['fullName'] ?? "No Name"; // Adjusted to match your structure
        String number = infoUser['phoneNumber'] ?? "No Number";
        String imageUrl = infoUser['imageUrl'] ?? "";

        // Navigate to home1 screen with uid, name, number, and imageUrl
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => home1(
              uid: userCredential.user!.uid,
              name: name,
              number: number,
              imageUrl: imageUrl,
              // propertyData: propertyData,  // Pass propertyData here
            ),
          ),
        );

        CustomFlushbar(message:"Login Successfull",color : Colors.green,title:"Success").show(context);

      } else {
        CustomFlushbar(message:"User not exist",color : Colors.red,title:"Error").show(context);

      }
    } catch (e) {
      // Check if the caught error is a FirebaseAuthException
      if (e is FirebaseAuthException) {
        String message;
        if (e.code == 'user-not-found') {
          CustomFlushbar(message:"Wrong Email",color : Colors.red,title:"Error").show(context);
        } else if (e.code == 'wrong-password') {
          CustomFlushbar(message:"Wrong Password",color : Colors.red,title:"Error").show(context);
        } else {
          CustomFlushbar(message:"Wrong Email or Password",color : Colors.red,title:"Error").show(context);
        }


      } else {
        // Handle other types of exceptions (optional)
        CustomFlushbar(message:"An unexpected error occurred.",color : Colors.red,title:"Error").show(context);

      }

    }finally {
      authProvider.setLoading(false); // Set loading to true

    }

  }


  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      // Perform login action
      loginfunc();

         // Close the bottom sheet



    } else {
      CustomFlushbar(message:"Server Error",color : Colors.red,title:"Error").show(context);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset(
                height: ResponsiveHelper.getHeight(context, .2),
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
                          text: "Let's ",
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        TextSpan(
                          text: "Sign In",
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF204D6C)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveHelper.getHeight(context, .01)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Consumer<FormValidationProvider>(
                    builder: (context, provider, child) {
                      print("Email TextField Rebuilt");
                     return TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email';
                          }
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
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
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                        ),
                      );
                    },
                ),
              ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Consumer<PasswordVisibilityProvider>(
                    builder: (context, provider, child) {
                      print("Password TextField Rebuilt");
                      return TextFormField(
                        controller: _passwordController,
                        obscureText: provider.isObscure,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          }
                          return null;
                        },
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
                            icon: Icon(
                              provider.isObscure ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              provider.toggleVisibility();
                            },
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0, top: 10),
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text("Forget Password?"),
                ),
              ),
              SizedBox(height: ResponsiveHelper.getHeight(context, .02)),

    Consumer<FormValidationProvider>(
    builder: (context, provider, child) {
      print("Rebuilding Login Button, isLoading: ${provider.isLoading}");
      return CustomButton(

        buttonText: "Login",

        color: Color(0xFF8BC83F),
        textColor: Colors.white,
        borderRadius: BorderRadius.circular(10),
        width: ResponsiveHelper.getWidth(context, .8),
        isLoading: provider.isLoading,
        onPress: provider.isLoading // Disable if loading
            ? null
            :_validateAndSubmit, // Validate and submit
      );

    }
    ),
              SizedBox(height: ResponsiveHelper.getHeight(context, .07)),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'OR',
                        style: TextStyle(fontSize: 16, color: Color(0xFF4A4A4A)),
                      ),
                    ),
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
                    Container(
                      height: ResponsiveHelper.getHeight(context, .08),
                      width: ResponsiveHelper.getWidth(context, .4),
                      child: Image.asset(AppImages().googleimg),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                    Container(
                      height: ResponsiveHelper.getHeight(context, .08),
                      width: ResponsiveHelper.getWidth(context, .4),
                      child: Image.asset(AppImages().fbimg),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: InkWell(
                  onTap: () {
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
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF204D6C)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// class AuthWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         // Check if the auth state is loading
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator(); // Show loading while checking auth state
//         }
//         // Check if there's an error during the state check
//         else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//         // If the user is logged in (snapshot.hasData)
//         else if (snapshot.hasData) {
//           // User is logged in, navigate to Home screen
//           return home1(uid: snapshot.data!.uid, name: '', number: '',);
//         }
//         // If the user is not logged in
//         else {
//           // User is not logged in, navigate to Login screen
//           return Login2();
//         }
//       },
//     );
//   }
// }

