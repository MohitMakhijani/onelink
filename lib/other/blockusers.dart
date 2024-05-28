import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onelink/Screen/profile/profilePage.dart';
import 'package:onelink/Theme.dart';

class BlockListScreen extends StatefulWidget {
  const BlockListScreen({super.key});

  @override
  State<BlockListScreen> createState() => _BlockListScreenState();
}

class _BlockListScreenState extends State<BlockListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Future<List<Map<String, dynamic>>> _blockedUsers;

  @override
  void initState() {
    super.initState();
    _blockedUsers = _fetchBlockedUsers();
  }

  Future<List<Map<String, dynamic>>> _fetchBlockedUsers() async {
    List<Map<String, dynamic>> blockedUsers = [];

    try {
      // Fetch the current user's document
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(_auth.currentUser!.uid).get();

      if (userDoc.exists) {
        // Get the blockUsers array
        List<dynamic> blockedUserUids = userDoc['blockUsers'];

        // Fetch each blocked user's data
        for (String uid in blockedUserUids) {
          DocumentSnapshot blockedUserDoc = await _firestore.collection('users').doc(uid).get();

          if (blockedUserDoc.exists) {
            // Assuming your user documents have a 'name' field
            blockedUsers.add({
              'uid': uid,
              'name': blockedUserDoc['name'], // Adjust this field if necessary
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching blocked users: $e');
    }

    return blockedUsers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Block List",
          style: GoogleFonts.inter(
            fontSize: 15.sp,
            color: AppTheme.light ? Colors.black : Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _blockedUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching blocked users'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No blocked users found'));
          } else {
            List<Map<String, dynamic>> blockedUsers = snapshot.data!;
            return ListView.builder(
              itemCount: blockedUsers.length,
              itemBuilder: (context, index) {
                var user = blockedUsers[index];
                return ListTile(
                  leading: CircleAvatar(radius: 26.r,backgroundImage: CachedNetworkImageProvider(user['profilePicture']??"")),
                  title: Text(user['name'],),
                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder:  (context) => ProfileScreen(uid: user['uid']))),
                );
              },
            );
          }
        },
      ),
    );
  }
}
