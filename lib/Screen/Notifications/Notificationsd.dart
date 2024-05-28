import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:onelink/Theme.dart';
import 'package:shimmer/shimmer.dart';

import '../profile/profilePage.dart'; // Import the shimmer package

class Notifications extends StatelessWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.light ? Colors.white : Colors.black,
      appBar: AppBar(
        foregroundColor: !AppTheme.light ? Colors.white : Colors.black,
        backgroundColor: AppTheme.light ? Colors.white : Colors.black,
        centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Notifications',
              style: GoogleFonts.inter(
                fontSize: 19.sp,
                color: !AppTheme.light ? Colors.white : Colors.black,
              ),
            ),
            Divider(
              color: !AppTheme.light ? Colors.white : Colors.black,
            )
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('notifications')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Use Shimmer effect while loading
            return _buildShimmerList();
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            final notifications = snapshot.data!.docs;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(notifications[index].id),
                  onDismissed: (direction) {
                    // Delete the notification from Firestore
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('notifications')
                        .doc(notifications[index].id)
                        .delete();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Notification deleted')),
                    );
                  },
                  background: Container(decoration: BoxDecoration(borderRadius:BorderRadius.circular(20) ,color: Colors.transparent)),
                  child: _buildNotificationItem(context, notifications[index]),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 10, // Number of shimmer placeholders
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 20.r,
            ),
            title: Container(
              height: 20.r,
              color: Colors.grey[300],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem(BuildContext context, DocumentSnapshot notification) {
    final UserId = notification['id'];
    final timestamp = notification['dateTime'] as Timestamp;
    final formattedDate = DateFormat.yMMMd().add_jm().format(timestamp.toDate());

    // Fetch user data from Firestore
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(UserId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerNotification(); // Use shimmer for individual item loading
        } else if (snapshot.hasError) {
          return Text('Error fetching user data');
        } else {
          final userSnapshot = snapshot.data!;
          final userProfilePicture = userSnapshot['profilePicture'];
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(uid: UserId),));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 21.r, backgroundColor: Colors.red,
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(userProfilePicture),
                    ),
                  ),
                  title: Row(
                    children: [
                      Flexible(
                        child: Text(
                          "${notification['notification'].toString().split(' ')[0]} " +
                              "${notification['notification'].toString().split(' ').skip(1).join(' ')}",
                          style: GoogleFonts.inter(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.w600,
                            color: !AppTheme.light ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    formattedDate,
                    style: GoogleFonts.nunitoSans(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.w500,
                      color: !AppTheme.light ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildShimmerNotification() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          radius: 20.r,
        ),
        title: Container(
          height: 20.r,
          color: Colors.grey[300],
        ),
      ),
    );
  }
}
