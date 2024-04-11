import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onelink/Screens/profile/profilePage.dart';
import 'package:share/share.dart';
import '../Screens/commentScreen/commentdart.dart';
import '../Services/FirestoreMethods.dart';
import '../others/report.dart';
import 'likegetx.dart';

class PostCard extends StatefulWidget {
  final String username;
  final List<dynamic> likes;
  final Timestamp time;
  final String profilePicture;
  final String image;
  final String description;
  final String postId;
  final String uid;
  final String comments;

  PostCard({
    required this.username,
    required this.likes,
    required this.time,
    required this.profilePicture,
    required this.image,
    required this.description,
    required this.postId,
    required this.uid,
    required this.comments,
  });

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').doc(widget.postId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data == null) {
           // Placeholder for loading state
        }

        var postData = snapshot.data!.data() as Map<String, dynamic>;
        List<dynamic> postLikes = postData['likes'];

        bool isLiked = postLikes.contains(
          FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
        );

        CollectionReference commentsRef = FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Container(
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(uid: widget.uid),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundImage: CachedNetworkImageProvider(widget.profilePicture),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          widget.username,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.0,
                            color: Color(0xFF888BF4),
                          ),
                        ),
                      ],
                    ),
                    DropdownButton<String>(
                      icon: Icon(Icons.more_vert),
                      items: currentUser != null && currentUser.uid == widget.uid
                          ? <DropdownMenuItem<String>>[
                        DropdownMenuItem(value: 'Report', child: Text('Report')),
                        DropdownMenuItem(value: 'Delete', child: Text('Delete')),
                        DropdownMenuItem(value: 'Edit', child: Text('Edit')),
                      ]
                          : <DropdownMenuItem<String>>[
                        DropdownMenuItem(value: 'Report', child: Text('Report')),
                      ],
                      onChanged: (String? newValue) {
                        if (newValue == 'Delete') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirm Delete"),
                                content: Text("Are you sure you want to delete this post?"),
                                actions: [
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Delete"),
                                    onPressed: () {
                                      FireStoreMethods().deletePost(widget.postId);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (newValue == 'Report') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportPostScreen(
                                uid: widget.uid,
                                postId: widget.postId,
                              ),
                            ),
                          );
                        } else if (newValue == 'Edit') {
                          // Navigate to the edit post screen
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => EditPostScreen(
                          //       postId: widget.postId,
                          //     ),
                          //   ),
                          // );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 1.75,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[200],
              child: Row(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Obx(
                            () => postController.isLiking
                            ? CircularProgressIndicator()
                            : IconButton(
                          icon: Column(
                            children: [
                              Icon(
                                isLiked ? Icons.favorite : Icons.favorite_border,
                                color: Color(0xFF888BF4),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${postLikes.length} ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.0,
                                        color: Color(0xFF888BF4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onPressed: () async {
                            if (postController.isLiking) return;
                            postController.setLiking(true);

                            await FireStoreMethods().likePost(
                              widget.postId,
                              FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
                              postLikes,
                            );

                            postController.setLiking(false);
                          },
                        ),
                      ),
                      SizedBox(width: 12.0),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommentsScreen(
                                    postId: widget.postId,
                                    image: widget.image,
                                  ),
                                ),
                              );
                            },
                            child: Icon(Icons.comment_outlined, color: Color(0xFF888BF4)),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: commentsRef.snapshots(),
                            builder: (context, commentsSnapshot) {
                              if (commentsSnapshot.hasError) {
                                return Text('Error: ${commentsSnapshot.error}');
                              }

                              if (!commentsSnapshot.hasData || commentsSnapshot.data == null) {
                                return SizedBox.shrink();
                              }

                              int numComments = commentsSnapshot.data!.docs.length;

                              return Text(
                                '$numComments',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Color(0xFF888BF4),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18.0, left: 15),
                        child: IconButton(
                          onPressed: () {
                            Share.share('Check out this cool app!/username=${widget.username}');
                          },
                          icon: FaIcon(FontAwesomeIcons.share, color: Color(0xFF888BF4)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Obx(() =>
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.description,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                      maxLines: postController.showAllDescription ? 50 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.description.length > 50) // Adjust the threshold as needed
                      TextButton(
                        onPressed: () {
                          postController.ShowDescription(!postController.showAllDescription);
                          print('Button tapped: showAllDescription: ${postController.showAllDescription}');
                        },
                        child: Text(
                          postController.showAllDescription ? 'Show less' : 'Show more',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Divider()
          ],
        );
      },
    );
  }
}
