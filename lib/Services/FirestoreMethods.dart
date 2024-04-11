
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      // Get the current user's name and profile photo URL
      DocumentSnapshot currentUserSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserUid)
          .get();

      // Get the target user's name and profile photo URL
      DocumentSnapshot targetUserSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUserUid)
          .get();

      if (currentUserSnapshot.exists && targetUserSnapshot.exists) {
        Map<String, dynamic> currentUserData = currentUserSnapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> targetUserData = targetUserSnapshot.data() as Map<String, dynamic>;

        // Check if the current user is already in the target user's followers list
        bool isCurrentUserFollowing = targetUserData['followers'].any((follower) => follower['uid'] == currentUserUid);

        if (!isCurrentUserFollowing) {
          // Update the followers list of the target user and add the current user's details
          await FirebaseFirestore.instance.collection('users').doc(targetUserUid).update({
            'followers': FieldValue.arrayUnion([{
              'uid': currentUserUid,
              'name': currentUserData['name'],
              'profilePhotoUrl': currentUserData['profilePhotoUrl'],
            }])
          });
        } else {
          // If already following, remove the current user's details from the target user's followers list
          await FirebaseFirestore.instance.collection('users').doc(targetUserUid).update({
            'followers': FieldValue.arrayRemove([{
              'uid': currentUserUid,
              'name': currentUserData['name'],
              'profilePhotoUrl': currentUserData['profilePhotoUrl'],
            }])
          });
        }

        // Check if the target user is already in the current user's following list
        bool isTargetUserFollowed = currentUserData['following'].any((followed) => followed['uid'] == targetUserUid);

        if (!isTargetUserFollowed) {
          // Update the following list of the current user and add the target user's details
          await FirebaseFirestore.instance.collection('users').doc(currentUserUid).update({
            'following': FieldValue.arrayUnion([{
              'uid': targetUserUid,
              'name': targetUserData['name'],
              'profilePhotoUrl': targetUserData['profilePhotoUrl'],
            }])
          });
        } else {
          // If already followed, remove the target user's details from the current user's following list
          await FirebaseFirestore.instance.collection('users').doc(currentUserUid).update({
            'following': FieldValue.arrayRemove([{
              'uid': targetUserUid,
              'name': targetUserData['name'],
              'profilePhotoUrl': targetUserData['profilePhotoUrl'],
            }])
          });
        }
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error: $e');
    }
  }



  Future<void> createFollowersAndFollowingArrays() async {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    try {
      // Create an array of followers for the current user
      await FirebaseFirestore.instance.collection('users')
          .doc(currentUserUid)
          .set({
        'followers': [], // Initialize with an empty array
      }, SetOptions(merge: true)); // Merge with existing document if it exists

      // Create an array of following for the current user
      await FirebaseFirestore.instance.collection('users')
          .doc(currentUserUid)
          .set({
        'following': [], // Initialize with an empty array
      }, SetOptions(merge: true)); // Merge with existing document if it exists

      print('Followers and following arrays created successfully.');
    } catch (e) {
      print('Error creating followers and following arrays: $e');
    }
  }
  Future<void> createUser({
    required String userId,
    required BuildContext context,
    required String name,
    required String email,
    required String bio,
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
      bio: bio,
        // Set followers
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(user.toMap());

      createFollowersAndFollowingArrays();

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
