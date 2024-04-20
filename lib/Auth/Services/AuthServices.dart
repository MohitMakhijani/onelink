import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onelink/Screens/profile/SetUpProfile/setupProfilePage.dart';

import '../../Models/UserModel.dart';
import '../../Screens/Home/BottomNavPage.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUserToFirestore(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.userId).set(
        user.toMap(), // Convert UserModel to Map
      );
    } catch (error) {
      print('Error adding user to Firestore: $error');
    }
  }
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<void> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleSignInAccount =
    await _googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential userCredential =
      await _auth.signInWithCredential(credential);
      // If the user is new, add their data to the Firestore Users collection
      if (userCredential.additionalUserInfo!.isNewUser) {
        // Create UserModel object
        UserModel user = UserModel(
          userId: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? 'Unknown',
          email: userCredential.user!.email ?? '',
          profilePhotoUrl: userCredential.user!.photoURL ?? '',
          dateOfBirth: DateTime.now(), // Set default value or fetch from user profile
          postCount: 0, // Set default value
          phoneNumber: '', // Set default value
          uuid: FirebaseAuth.instance.currentUser!.uid, bio: '', LinkedIn: '', // Set default value
        );
        await UserService().addUserToFirestore(user);
      }
      // Navigate to the homepage upon successful sign-in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SetUpProfile(),
        ),
      );
    }
  } catch (error) {
    print("Error signing in with Google: $error");
  }
}
