import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onelink/components/myButton.dart';
import '../../Models/CommunityModel.dart';
import '../../Screens/Community/CommunityChatScreen.dart';
import '../../Screens/Community/join_community_form.dart';
class CommunityList extends StatelessWidget {
  final String currentUser = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('communities').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
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

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Adjust the number of columns as needed
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: communities.length,
          itemBuilder: (context, index) {
            bool isUserJoined = communities[index].members.contains(currentUser);
            return GestureDetector(
              onTap: () {
                if (!isUserJoined) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JoinCommunityFormPage(
                        communityId: communities[index].id,
                        userId: currentUser,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommunityChatScreen(
                        communityId: communities[index].id,
                        currentUserId: currentUser,
                      ),
                    ),
                  );
                }
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    gradient: isUserJoined
                        ? LinearGradient(
                      colors: [   Color(0xFF888BF4), Colors.lightBlueAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )
                        : LinearGradient(
                      colors: [Colors.lightBlueAccent, Color(0xFF888BF4)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          communities[index].name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${communities[index].members.length} members',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      MyButton1(
                        onTap: () {
                          if (isUserJoined) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommunityChatScreen(
                                  communityId: communities[index].id,
                                  currentUserId: currentUser,
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JoinCommunityFormPage(
                                  communityId: communities[index].id,
                                  userId: currentUser,
                                ),
                              ),
                            );
                          }
                        },
                        text: isUserJoined ? 'Chat' : 'Join',
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
