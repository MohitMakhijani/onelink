import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../Get/fetchdata.dart';

class CommunityChatScreen extends StatelessWidget {
  final String communityId;
  final String currentUserId;

  CommunityChatScreen({required this.communityId, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    // Access the UserFetchController instance
    final userFetchController = Provider.of<UserFetchController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Community Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('communities').doc(communityId).collection('messages').orderBy('timestamp').snapshots(),
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
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['sender']),
                      subtitle: Text(data['text']),
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageComposer(context), // Pass context to access the UserFetchController
        ],
      ),
    );
  }

  Widget _buildMessageComposer(BuildContext context) {
    TextEditingController _messageController = TextEditingController();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration.collapsed(hintText: 'Send a message...'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              final userFetchController = Provider.of<UserFetchController>(context, listen: false);
              String? senderName = userFetchController.myUser.name; // Get the sender's name
              _sendMessage(_messageController.text.trim(), senderName!);
              _messageController.clear();
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage(String messageText, String senderName) {
    FirebaseFirestore.instance.collection('communities').doc(communityId).collection('messages').add({
      'sender': senderName, // Set the sender's name
      'text': messageText,
      'timestamp': DateTime.now(),
    });
  }
}
