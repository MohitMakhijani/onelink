import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onelink/Models/feed_postUi.dart';
import 'package:onelink/Screens/profile/editProfile.dart';
import 'package:onelink/Services/FirestoreMethods.dart';
import '../../Widgets/FolowButton.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .where('uuid', isEqualTo: widget.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (userSnap.docs.isNotEmpty) {
        var userDataDoc = userSnap.docs.first;
        userData = userDataDoc.data();
        followers = userData['followers'].length;
        following = userData['following'].length;
        isFollowing = userData['followers']
            .contains(FirebaseAuth.instance.currentUser!.uid);
        postLen = postSnap.docs.length;
        setState(() {});
      } else {
        showSnackBar(context, 'User data not found.');
      }
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor, // Use your defined primary color
        title: Text(
          "@${userData['name'] ?? ''}",
          style: GoogleFonts.aladin(color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(
                      userData['profilePhotoUrl'] ?? '',
                    ),
                    radius: 40,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildStatColumn(postLen, "posts"),
                    buildStatColumn(followers, "followers"),
                    buildStatColumn(following, "following"),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FirebaseAuth.instance.currentUser!.uid == widget.uid
                        ? FollowButton(
                      text: 'Edit Profile',
                      backgroundColor: Colors.blue,
                      textColor: primaryColor,
                      borderColor: Colors.grey,
                      function: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(),
                          ),
                        );
                      },
                    )
                        : isFollowing
                        ? FollowButton(
                      text: 'Unfollow',
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      borderColor: Colors.grey,
                      function: () async {
                        FireStoreMethods().followUser(
                          widget.uid,
                          userData['uuid'],
                        );
                      },
                    )
                        : FollowButton(
                      text: 'Follow',
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      borderColor: Colors.blue,
                      function: () async {
                        FireStoreMethods().followUser(
                          FirebaseAuth.instance.currentUser!.uid,
                          userData['uuid'],
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  userData['username'] ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  userData['email'] ?? '',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          Divider(),
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('posts')
                .where('uid', isEqualTo: userData['uuid'])
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              return GridView.builder(
                shrinkWrap: true,
                itemCount: (snapshot.data! as dynamic).docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 1.5,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];

                  return FadeInImage(
                    fadeInDuration: Duration(milliseconds: 100),
                    filterQuality: FilterQuality.high,
                    placeholder: AssetImage('Assets/images/onboarding1.png'),
                    image: CachedNetworkImageProvider(
                      snap['postUrl'] ?? '',
                    ),
                    fit: BoxFit.cover,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
