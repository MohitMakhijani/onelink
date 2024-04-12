import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onelink/Screens/chats/chat_screen.dart';
import 'package:onelink/Screens/profile/editProfile.dart';
import 'package:onelink/Services/FirestoreMethods.dart';
import 'package:onelink/components/myButton.dart';
import '../../Models/feed_postUi.dart';
import '../../Widgets/FolowButton.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';
import 'FollowerFollowingPage.dart';

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
    getStreamData();
  }

  getStreamData() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .snapshots()
        .listen((userDataSnapshot) {
      if (userDataSnapshot.exists) {
        userData = userDataSnapshot.data()!;
        setState(() {
          followers = userData['followers'].length;
          following = userData['following'].length;
          isFollowing = (userData['followers'] as List<dynamic>).any(
                  (follower) =>
              follower is Map<String, dynamic> &&
                  follower['uid'] == FirebaseAuth.instance.currentUser!.uid);
        });
      }
    });

    FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: widget.uid)
        .snapshots()
        .listen((postSnapshot) {
      setState(() {
        postLen = postSnapshot.docs.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF888BF4),
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
                    GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return FollowFollowing1(uid: widget.uid);
                            },
                          ));
                        },
                        child: buildStatColumn(followers, "followers")),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return FollowFollowing(uid: widget.uid);
                          },
                        ));
                      },
                      child: buildStatColumn(following, "following"),
                    )
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FirebaseAuth.instance.currentUser!.uid == widget.uid
                        ? FollowButton(
                      text: 'Edit Profile',
                      backgroundColor: Color(0xFF888BF4),
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
                      backgroundColor: Colors.red,
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
                if (FirebaseAuth.instance.currentUser!.uid != widget.uid)
                  Center(
                    child: MyButton1(
                      onTap: () {
                        createChatRoom();
                      },
                      text: "Message",
                      color: Colors.blue,
                    ),
                  ),
                SizedBox(height: 8),
                Text(
                  userData['bio'] ?? '',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  userData['email'] ?? '',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          Divider(),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .where('uid', isEqualTo: userData['uuid'])
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              return GridView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 1.5,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  DocumentSnapshot snap = snapshot.data!.docs[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Scaffold(
                              appBar: AppBar(
                                title: Text('Posts'),
                                backgroundColor: Color(0xFF888BF4),
                              ),
                              body: PostCard(
                                username: snap['username'],
                                likes: snap['likes'],
                                time: snap['datePublished'],
                                profilePicture: snap['profImage'],
                                image: snap['postUrl'],
                                description: snap['description'],
                                postId: snap['postId'],
                                uid: snap['uid'],
                                comments: '',
                              ),
                            );
                          },
                        ),
                      );
                    },
                    child: FadeInImage(
                      fadeInDuration: Duration(milliseconds: 100),
                      filterQuality: FilterQuality.high,
                      placeholder: AssetImage('Assets/images/onboarding1.png'),
                      image: CachedNetworkImageProvider(snap['postUrl'] ?? ''),
                      fit: BoxFit.cover,
                    ),
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
  void createChatRoom() async {
    String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    String targetUserUid = userData['uuid'];
    String targetUserName = userData['name'] ?? '';
    String targetUserProfile = userData['profilePhotoUrl'] ?? '';

    // Create a unique chat room ID based on user UIDs
    String chatRoomId = currentUserUid.hashCode <= targetUserUid.hashCode
        ? '$currentUserUid-$targetUserUid'
        : '$targetUserUid-$currentUserUid';

    // Check if the chat room already exists
    DocumentSnapshot chatRoomSnapshot = await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .get();

    if (chatRoomSnapshot.exists) {
      // Chat room already exists, navigate to chat screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            chatRoomId: chatRoomId,
            UserName: targetUserName,
            ProfilePicture: targetUserProfile,
          ),
        ),
      );
    } else {
      // Chat room doesn't exist, create and navigate to chat screen
      FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomId).set({
        'users': [currentUserUid, targetUserUid],
        'createdAt': FieldValue.serverTimestamp(),
        'recentMessage': ""
      }).then((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatRoomId: chatRoomId,
              UserName: targetUserName,
              ProfilePicture: targetUserProfile,
            ),
          ),
        );
      });
    }}}