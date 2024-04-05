import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:onelink/components/myButton.dart';

import '../../Get/fetchdata.dart';
import '../../components/myTextField.dart';
 // Import the MyTextField widget

class JoinCommunityFormPage extends StatelessWidget {
  final String communityId;
  final String userId;

  JoinCommunityFormPage({required this.communityId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF888BF4),
        title: Text('Join Community'),
      ),
      body: JoinCommunityForm(communityId: communityId, userId: userId),
    );
  }
}

class JoinCommunityForm extends StatelessWidget {
  final String communityId;
  final String userId;
  // final UserFetchController userFetchController = Get.put(UserFetchController());

  JoinCommunityForm({required this.communityId, required this.userId});

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _educationController = TextEditingController();
  TextEditingController _schoolController = TextEditingController();
  TextEditingController _collegeController = TextEditingController();
  TextEditingController _marksController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MyTextField(
              controller: _nameController,
              hint: 'Your Name',
              obscure: false,
              selection: true,
              preIcon: Icons.person,
              keyboardtype: TextInputType.name,
              fillcolor: Color(0xFFF2F2F2),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(height: 12),
            MyTextField(
              controller: _emailController,
              hint: 'Email',
              obscure: false,
              selection: true,
              preIcon: Icons.email,
              keyboardtype: TextInputType.emailAddress,
              fillcolor: Color(0xFFF2F2F2),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                // Add email validation if needed
                return null;
              },
            ),
            MyTextField(
              controller: _educationController,
              hint: 'Education',
              obscure: false,
              selection: true,
              preIcon: Icons.school,
              keyboardtype: TextInputType.text,
              fillcolor: Color(0xFFF2F2F2),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your education';
                }
                return null;
              },
            ),
            MyTextField(
              controller: _schoolController,
              hint: 'School',
              obscure: false,
              selection: true,
              preIcon: Icons.school,
              keyboardtype: TextInputType.text,
              fillcolor: Color(0xFFF2F2F2),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your school';
                }
                return null;
              },
            ),
            MyTextField(
              controller: _collegeController,
              hint: 'College',
              obscure: false,
              selection: true,
              preIcon: Icons.school,
              keyboardtype: TextInputType.text,
              fillcolor: Color(0xFFF2F2F2),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your college';
                }
                return null;
              },
            ),
            MyTextField(
              controller: _marksController,
              hint: 'Marks',
              obscure: false,
              selection: true,
              preIcon: Icons.score,
              keyboardtype: TextInputType.number,
              fillcolor: Color(0xFFF2F2F2),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your marks';
                }
                return null;
              },
            ),
            MyTextField(
              controller: _cityController,
              hint: 'City',
              obscure: false,
              selection: true,
              preIcon: Icons.location_city,
              keyboardtype: TextInputType.text,
              fillcolor: Color(0xFFF2F2F2),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your city';
                }
                return null;
              },
            ),
            MyTextField(
              controller: _stateController,
              hint: 'State',
              obscure: false,
              selection: true,
              preIcon: Icons.location_on,
              keyboardtype: TextInputType.text,
              fillcolor: Color(0xFFF2F2F2),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your state';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            MyButton(onTap: () {
              if (_formKey.currentState!.validate()) {
                _joinCommunity(
                  communityId,
                  userId,
                  _nameController.text,
                  _emailController.text,
                  _educationController.text,
                  _schoolController.text,
                  _collegeController.text,
                  _marksController.text,
                  _cityController.text,
                  _stateController.text,
                );
                // Navigate back to the previous screen after joining the community
                Navigator.pop(context);
              }
            }, text: "Join", color: Color(0xFF888BF4))
          ],
        ),
      ),
    );
  }

  void _joinCommunity(
      String communityId,
      String userId,
      String userName,
      String email,
      String education,
      String school,
      String college,
      String marks,
      String city,
      String state,
      ) {
    FirebaseFirestore.instance.collection('communities').doc(communityId).update({
      'members': FieldValue.arrayUnion([userId]),
    }).then((_) {
      FirebaseFirestore.instance.collection('communities').doc(communityId).collection('members').doc(userId).set({
        'name': userName,
        'email': email,
        'education': education,
        'school': school,
        'college': college,
        'marks': marks,
        'city': city,
        'state': state,
      });
    });
  }
}
