import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onelink/Theme.dart';
import 'package:provider/provider.dart';

import '../FetchDataProvider/fetchData.dart';
import '../Services/FireStoreMethod.dart';
import '../Widgets/comment_card.dart';
import '../utils/utils.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;
  final String image;
  final String TargetUserId;

  const CommentsScreen({Key? key, required this.postId, required this.image, required this.TargetUserId}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentEditingController = TextEditingController();

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await FireStoreMethods().postComment(
          widget.postId,
          commentEditingController.text,
          uid,
          name,
          profilePic,
          widget.TargetUserId
      );

      if (res != 'success') {
        showSnackBar(context, res);
      }
      setState(() {
        commentEditingController.text = '';
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserFetchController>(context).myUser;

    return Scaffold(
      backgroundColor: AppTheme.light?Colors.white:Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title:  Text('Comments',style: GoogleFonts.aladin(fontSize: MediaQuery.of(context).size.width*0.05,
         color: !AppTheme.light?Colors.white:Colors.black
        ),),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1
            ),
            color: Colors.grey
            
            ),
            
            width: MediaQuery.of(context).size.width * 1.1,
            height: MediaQuery.of(context).size.width * 0.7,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(

                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('comments')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) => CommentCard(
                    snap: snapshot.data!.docs[index], postId: widget.postId, uid: widget.TargetUserId,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
           color: AppTheme.light?Colors.white:Colors.black,
           border: Border.all(
            color: Colors.grey,
            width: 2.0
            
           ),
           borderRadius: BorderRadius.circular(10)

          ),
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.profilePicture ?? ""),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold,
                     color: !AppTheme.light?Colors.white:Colors.black
                    ),
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
           color: !AppTheme.light?Colors.white:Colors.black,

                      ),
                      hintText: 'Comment as ${user.name}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => postComment(
                  user.userId ?? "",
                  user.name ?? "",
                  user.profilePicture ?? " ",
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
