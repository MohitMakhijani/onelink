import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onelink/Screens/chats/chat_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecentChatsPage extends StatefulWidget {
  const RecentChatsPage({Key? key}) : super(key: key);

  @override
  _RecentChatsPageState createState() => _RecentChatsPageState();
}

class _RecentChatsPageState extends State<RecentChatsPage> {
  late String currentUserUid;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: () => setState(() {

        }), icon: FaIcon(Icons.search))
      ],
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search chats...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                searchController.clear();
                setState(() {}); // Clear search results
              },
            ),
          ),
        ),
      ),
      body:StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chatRooms')
            .where('users', arrayContains: currentUserUid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> chatRooms = snapshot.data!.docs;
          if (chatRooms.isEmpty) {
            return Center(child: Text('No recent chats'));
          }

          // Filter chat rooms where the other user is also a member
          List<DocumentSnapshot> filteredChatRooms = chatRooms
              .where((room) => (room['users'] as List).contains(currentUserUid))
              .toList();

          if (searchController.text.isNotEmpty) {
            // Create a temporary list to hold the filtered rooms
            List<DocumentSnapshot> tempFilteredChatRooms = [];

            // Use async/await to wait for the get method inside forEach
            Future.forEach(filteredChatRooms, (room) async {
              String otherUserName = '';
              await Future.forEach(room['users'] as List, (uid) async {
                if (uid == currentUserUid) {
                  DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(uid).get();
                  if (userData.exists) {
                    otherUserName = userData['name'] ?? '';
                  }
                }
              });
              if (otherUserName.toLowerCase().contains(searchController.text.toLowerCase())) {
                tempFilteredChatRooms.add(room); // Add the room to filtered list
              }
            }).then((_) {
              setState(() {
                filteredChatRooms = tempFilteredChatRooms; // Assign the filtered list to main list
              });
            });
          }

          if (filteredChatRooms.isEmpty) {
            return Center(child: Text('No recent chats with this user'));
          }

          return ListView.builder(
            itemCount: filteredChatRooms.length,
            itemBuilder: (context, index) {
              DocumentSnapshot room = filteredChatRooms[index];

              // Find the other user's UID in the chat room
              String otherUserUid = (room['users'] as List)
                  .firstWhere((uid) => uid != currentUserUid);

              return UserTile(
                uid: otherUserUid,
                onTap: () {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(otherUserUid)
                      .get()
                      .then((userData) {
                    if (userData.exists) {
                      String userName = userData['name'] ?? 'Unknown';
                      String profilePicture = userData['profilePhotoUrl'] ?? '';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            chatRoomId: room.id,
                            UserName: userName,
                            ProfilePicture: profilePicture,
                          ),
                        ),
                      );
                    }
                  });
                },
              );
            },
          );
        },
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final String uid;
  final VoidCallback onTap;

  const UserTile({Key? key, required this.uid, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream:
      FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
      builder: (context, userSnapshot) {
        if (userSnapshot.hasError) {
          return Text('Error: ${userSnapshot.error}');
        }

        if (!userSnapshot.hasData || userSnapshot.data == null) {
          return SizedBox.shrink();
        }

        var userData = userSnapshot.data!.data();
        if (userData == null || userData is! Map<String, dynamic>) {
          return SizedBox.shrink(); // Handle null or invalid data
        }

        return ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            radius: 25,
            backgroundImage:
            CachedNetworkImageProvider(userData['profilePhotoUrl'] ?? ''),
          ),
          title: Text(userData['name'] ?? ''),
          subtitle: Text('Tap to chat'),
        );
      },
    );
  }
}
