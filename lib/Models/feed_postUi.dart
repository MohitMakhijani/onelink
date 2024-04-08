import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart'; // Import GetX package
import 'package:share/share.dart';
import '../Screens/commentScreen/commentdart.dart';
import '../Services/FirestoreMethods.dart';
import 'likegetx.dart';



class PostCard extends StatelessWidget {
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

  final postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    int commentsLength =
    comments.isEmpty ? 0 : int.tryParse(comments) ?? 0;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return CircularProgressIndicator();
        }

        var postData = snapshot.data!.data() as Map<String, dynamic>;
        List<dynamic> postLikes = postData['likes'];

        bool isLiked = postLikes.contains(
          FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
        );

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
                        CircleAvatar(
                          radius: 20.0,
                          backgroundImage: CachedNetworkImageProvider(profilePicture),
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          username,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16.0,
                            color: Color(0xFF888BF4),
                          ),
                        ),
                      ],
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
                    image: CachedNetworkImageProvider(image),
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
                      Obx(() => postController.isLiking
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
                            postId,
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
                                    postId: postId,
                                    image: image,
                                  ),
                                ),
                              );
                            },
                            child: Icon(Icons.comment_outlined, color: Color(0xFF888BF4)),
                          ),
                          Text(
                            '$commentsLength',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Color(0xFF888BF4),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18.0,left: 15),
                        child: IconButton(onPressed: () {
                          Share.share('Check out this cool app!/username=${username}');
                        }, icon: FaIcon(FontAwesomeIcons.share,color: Color(0xFF888BF4),)),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                description,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
