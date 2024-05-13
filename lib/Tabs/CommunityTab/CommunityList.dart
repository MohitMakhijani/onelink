import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:onelink/Theme.dart';
import '../../Models/CommunityModel.dart';
import '../../Screen/CommmunityScreens/ChatScreens.dart';
import '../../Screen/CommmunityScreens/communityForm.dart';

class CommunityList extends StatelessWidget {
  final String currentUser = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('communities').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
                color: Color.fromARGB(255, 244, 66, 66),
                size:50,
              ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        List<Community> communities = [];
        snapshot.data!.docs.forEach((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          communities.add(Community(
            id: document.id,
            name: data['name'],
            members: List<String>.from(data['members']),
            messages: [], // You can fetch messages here if needed
          ));
        });

        return ListView.builder(
          itemCount: communities.length,
          itemBuilder: (BuildContext context, int index) {
            bool isUserJoined =
                communities[index].members.contains(currentUser);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 18.0, top: 28),
                            child: Text(
                              communities[index].name,
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                 color: !AppTheme.light?Colors.white:Colors.black
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 18.0),
                            child: Text(
                              '${communities[index].members.length} Members',
                              style: TextStyle(
                                color: !AppTheme.light?Colors.white:Colors.black
                              ),
                              
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red, width: 1)),
                        height: 40.h,
                        width: 100.w,
                        child: Center(
                            child: TextButton(
                                onPressed: () {
                                  if (isUserJoined) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CommunityChatScreen(
                                          communityId: communities[index].id,
                                          currentUserId: currentUser,
                                          communityName: communities[index].name,
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => JoinCommunityForm(
                                          communityId: communities[index].id,
                                          userId: currentUser,
                                          communityIndex: index + 1,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  isUserJoined ? "Chat" : "Join",
                                  style: TextStyle(
                              color: !AppTheme.light?Colors.white:Colors.black),
                                ))),
                      ),
                    )
                  ],
                ),
                height: 100.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red, width: 1)),
              ),
            );
          },
        );
      },
    );
  }
}
