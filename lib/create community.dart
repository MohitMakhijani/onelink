import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateCommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController _communityNameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Community'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Community Name:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _communityNameController,
              decoration: InputDecoration(
                hintText: 'Enter community name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _createCommunity(_communityNameController.text.trim());
              },
              child: Text('Create Community'),
            ),
          ],
        ),
      ),
    );
  }

  void _createCommunity(String communityName) {
    FirebaseFirestore.instance.collection('communities').add({
      'name': communityName,
      'members': [], // Initially no members
      'messages': [], // Initialjai shree ly no messages
    });
  }
}