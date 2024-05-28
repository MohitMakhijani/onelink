import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:onelink/Screen/profile/profilePage.dart';

import '../../Theme.dart';

class FollowFollowing extends StatelessWidget {
  final String uid;
  FollowFollowing({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: !AppTheme.light?Colors.black:Colors.white,
      appBar: AppBar(
        foregroundColor: AppTheme.light?Colors.black:Colors.white,
        backgroundColor: Colors.red,
        title: Text(
          'Following',
          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700,color: AppTheme.light?Colors.black:Colors.white),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid) // Fetch the document based on the provided UID
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child:  LoadingAnimationWidget.staggeredDotsWave(
              color: Color.fromARGB(255, 244, 66, 66),
              size:50,
            ));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No user data found.',style: TextStyle(color: AppTheme.light?Colors.black:Colors.white),));
          }

          Map<String, dynamic>? userData = snapshot.data!.data() as Map<String, dynamic>?;
          if (userData == null || !userData.containsKey('following')) {
            return Center(child: Text('No following data found.',style: TextStyle(color: AppTheme.light?Colors.black:Colors.white),));
          }

          List<String> followingNames = [];
          List<String> followingUid = [];
          List<String> followingImg = [];

          List<dynamic> following = userData['following'];
          following.forEach((element) {
            if (element is Map<String, dynamic> && element.containsKey('name')) {
              String name = element['name'] as String? ?? 'Unknown';
              String img = element['profImage'] as String? ?? 'Unknown';
              String uid = element['uid'] as String? ?? 'Unknown';
              followingNames.add(name);
              followingUid.add(uid);
              followingImg.add(img);
            }
          });

          if (followingNames.isEmpty) {
            return Center(child: Text('No users in following.',style: TextStyle(color: AppTheme.light?Colors.black:Colors.white),));
          }

          return ListView.builder(
            itemCount: followingNames.length,
            itemBuilder: (context, index) {
              final name = followingNames[index];
              final img = followingImg[index];
              final uuid = followingUid[index];

              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(uid: uuid),));
                    },
                    leading: CircleAvatar(backgroundImage:CachedNetworkImageProvider(img) ,),
                    title: Text(name,style: TextStyle(color:  AppTheme.light?Colors.black:Colors.white),),
                    // You can add more data to the ListTile as needed
                  ),Divider()
                ],
              );
            },
          );
        },
      ),
    );
  }
}


class FollowFollowing1 extends StatelessWidget {
  final String uid;
  FollowFollowing1({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: !AppTheme.light?Colors.black:Colors.white,
      appBar: AppBar(
        foregroundColor: AppTheme.light?Colors.black:Colors.white,
        backgroundColor: Colors.red,
        title: Text(
          'Followers',
          style: GoogleFonts.aladin(fontSize: 20, fontWeight: FontWeight.w700,color: AppTheme.light?Colors.black:Colors.white),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid) // Fetch the document based on the provided UID
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No user data found.'));
          }

          Map<String, dynamic>? userData = snapshot.data!.data() as Map<String, dynamic>?;
          if (userData == null || !userData.containsKey('followers')) {
            return Center(child: Text('No following data found.'));
          }

          List<String> followingNames = [];
          List<String> followingUid = [];
          List<String> followingImg = [];

          List<dynamic> following = userData['followers'];
          following.forEach((element) {
            if (element is Map<String, dynamic> && element.containsKey('name')) {
              String name = element['name'] as String? ?? 'Unknown';
              String img = element['profImage'] as String? ?? 'Unknown';
              String uid = element['uid'] as String? ?? 'Unknown';
              followingNames.add(name);
              followingUid.add(uid);
              followingImg.add(img);
            }
          });

          if (followingNames.isEmpty) {
            return Center(child: Text('No users in following.',style: TextStyle(color:  AppTheme.light?Colors.black:Colors.white),));
          }

          return ListView.builder(
            itemCount: followingNames.length,
            itemBuilder: (context, index) {
              final name = followingNames[index];
              final img = followingImg[index];
              final uuid = followingUid[index];

              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(uid: uuid),));
                    },
                    leading: CircleAvatar(backgroundImage:CachedNetworkImageProvider(img) ,),
                    title: Text(name,style: GoogleFonts.inter(color: AppTheme.light?Colors.black:Colors.white),),
                    // You can add more data to the ListTile as needed
                  ),Divider()
                ],
              );
            },
          );
        },
      ),
    );
  }
}
