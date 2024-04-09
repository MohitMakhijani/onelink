
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../Models/PostModel.dart';
import '../Models/UserModel.dart';
import '../Screens/Home/BottomNavPage.dart';
import 'StorageMEthods.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
      await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }


  // Post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String currentUserUid, String targetUserUid) async {
    try {
      // Create a query to fetch the target user's document
      QuerySnapshot targetUserQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uuid', isEqualTo: targetUserUid)
          .limit(1) // Limit to 1 document (assuming 'uuid' is unique)
          .get();

      if (targetUserQuerySnapshot.docs.isNotEmpty) {
        DocumentSnapshot targetUserDoc = targetUserQuerySnapshot.docs.first;
        List<dynamic> followers = targetUserDoc.get('followers');

        // Check if the current user is already in the followers list of the target user
        if (!followers.contains(currentUserUid)) {
          // Update followers list of target user and following list of current user
          await FirebaseFirestore.instance.collection('users').doc(
              targetUserUid).update({
            'followers': FieldValue.arrayUnion([currentUserUid])
          });

          await FirebaseFirestore.instance.collection('users').doc(
              currentUserUid).update({
            'following': FieldValue.arrayUnion([targetUserUid])
          });
        } else {
          // If already following, unfollow by removing from both followers and following lists
          await FirebaseFirestore.instance.collection('users').doc(
              targetUserUid).update({
            'followers': FieldValue.arrayRemove([currentUserUid])
          });

          await FirebaseFirestore.instance.collection('users').doc(
              currentUserUid).update({
            'following': FieldValue.arrayRemove([targetUserUid])
          });
        }
      } else {
        print('Target user not found with UID: $targetUserUid');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> createUser({
    required String userId,
    required BuildContext context,
    required String name,
    required String email,
    required String EventCount,
    required String JobCount,
    required List<String> following,
    required List<String> followers,
    required String profilePhotoUrl,
    required DateTime dateOfBirth,
    required int postCount,
    required String phoneNumber,
    Uint8List? imageBytes,
  }) async {
    try {
      // Check if user already exists with the provided email
      QuerySnapshot existingUsersWithEmail = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (existingUsersWithEmail.docs.isNotEmpty) {
        // User already exists with the provided email, handle this case
        print('User with email $email already exists.');
        // You might want to return here or show an error message to the user
        return;
      }

      // Check if user already exists with the provided UID
      DocumentSnapshot existingUserWithUid = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (existingUserWithUid.exists) {
        // User already exists with the provided UID, handle this case
        print('User with UID $userId already exists.');
        // You might want to return here or show an error message to the user
        return;
      }

      String imageUrl = profilePhotoUrl; // Default to profilePhotoUrl

      if (imageBytes != null) {
        // Upload image to Firebase Storage
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('$userId.jpg');
        UploadTask uploadTask = ref.putData(imageBytes);
        TaskSnapshot taskSnapshot = await uploadTask;
        imageUrl = await taskSnapshot.ref.getDownloadURL();
      }

      var user = UserModel(
        userId: userId,
        name: name,
        email: email,
        profilePhotoUrl: imageUrl,
        // Use imageUrl as profilePhotoUrl
        dateOfBirth: dateOfBirth,
        postCount: postCount,
        phoneNumber: phoneNumber,
        uuid: userId,
        EventCount: EventCount,
        JobCount: JobCount,
        following: following,
        // Set following
        followers: followers,
        // Set followers
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(user.toMap());

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    } catch (e) {
      print('Error creating user: $e');
      // Handle error here, e.g., show an error dialog to the user
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Error'),
              content: Text('Failed to create user. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            ),
      );
    }
  }
}
