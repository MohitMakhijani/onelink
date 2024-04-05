import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Models/feed_postUi.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<QueryDocumentSnapshot> postDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: postDocs.length,
            itemBuilder: (context, index) {
              var post = postDocs[index].data() as Map<String, dynamic>;
              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(post['postId'])
                    .collection('comments')
                    .get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> commentSnapshot) {
                  if (commentSnapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox.shrink(); // Return an empty widget while waiting for data
                  }

                  int commentsLength = commentSnapshot.data!.docs.length;

                  return PostCard(
                    username: post['username'] ?? '',
                    likes: post['likes'] ?? "0",
                    time: post['datePublished'],
                    profilePicture: post['profImage'] ?? '',
                    image: post['postUrl'] ?? '',
                    description: post['description'],
                    postId: post['postId'],
                    uid: post['uid'],
                    comments: commentsLength.toString(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
