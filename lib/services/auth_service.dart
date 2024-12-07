import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? guser = await GoogleSignIn().signIn();

    if (guser == null) return null; // The user canceled the sign-in

    final GoogleSignInAuthentication gAuth = await guser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    UserCredential userCredential = await _auth.signInWithCredential(credential);

    // Store user details in Firestore
    await _storeUserDetails(userCredential.user);

    return userCredential.user;
  }

  Future<void> _storeUserDetails(User? user) async {
    if (user != null) {
      // Check if the user is already in Firestore
      DocumentReference userRef = _firestore.collection('users').doc(user.uid);
      DocumentSnapshot doc = await userRef.get();

      if (!doc.exists) {
        // If the user doesn't exist, create a new document
        await userRef.set({
          'uid': user.uid,
          'displayName': user.displayName,
          'email': user.email,
          'photoUrl': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>?;
    }
    return null;
  }
}
