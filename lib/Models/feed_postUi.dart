import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Screens/commentScreen/commentdart.dart';
import '../Services/FirestoreMethods.dart';

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
  bool _isLiking = false; // Add this variable to track liking/unliking state

  @override
  Widget build(BuildContext context) {
    int commentsLength =
        widget.comments.isEmpty ? 0 : int.tryParse(widget.comments) ?? 0;

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
                      backgroundImage:
                          CachedNetworkImageProvider(widget.profilePicture),
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
                  _isLiking
                      ? CircularProgressIndicator()
                      : IconButton(
                          icon: Column(
                            children: [
                              Icon(
                                widget.likes.contains(FirebaseAuth
                                        .instance.currentUser!.phoneNumber
                                        .toString())
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Color(0xFF888BF4),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 1.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${widget.likes.length} ',
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
                            if (_isLiking) return;
                            setState(() {
                              _isLiking = true;
                            });
                            await FireStoreMethods().likePost(
                              widget.postId,
                              FirebaseAuth.instance.currentUser!.phoneNumber
                                  .toString(),
                              widget.likes,
                            );
                            setState(() {
                              _isLiking = false;
                            });
                          },
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
                        child: Icon(Icons.comment_outlined,
                            color: Color(0xFF888BF4)),
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
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            widget.description,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
