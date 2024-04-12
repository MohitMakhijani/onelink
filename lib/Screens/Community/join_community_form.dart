import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onelink/components/myTextField.dart';

class JoinCommunityForm extends StatelessWidget {
  final String communityId;
  final String userId;

  JoinCommunityForm({required this.communityId, required this.userId});

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _graduationTypeController = TextEditingController();
  TextEditingController _collegeController = TextEditingController();
  TextEditingController _persuingController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Community Form'),
      ),
      body: SingleChildScrollView(
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Add email validation if needed
                  return null;
                },
              ),
              MyTextField(
                controller: _phoneController,
                hint: 'Phone',
                obscure: false,
                selection: true,
                preIcon: Icons.phone,
                keyboardtype: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  // Add phone validation if needed
                  return null;
                },
              ),
              MyTextField(
                controller: _graduationTypeController,
                hint: 'Graduation Type',
                obscure: false,
                selection: true,
                preIcon: Icons.school,
                keyboardtype: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your graduation type';
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your college';
                  }
                  return null;
                },
              ),
              MyTextField(
                controller: _persuingController,
                hint: 'Persuing',
                obscure: false,
                selection: true,
                preIcon: Icons.school,
                keyboardtype: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your persuing';
                  }
                  return null;
                },
              ),
              MyTextField(
                controller: _yearController,
                hint: 'Year',
                obscure: false,
                selection: true,
                preIcon: Icons.school,
                keyboardtype: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your year';
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your state';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _joinCommunity(
                      communityId,
                      userId,
                      _nameController.text,
                      _emailController.text,
                      _phoneController.text,
                      _graduationTypeController.text,
                      _collegeController.text,
                      _persuingController.text,
                      _yearController.text,
                      _cityController.text,
                      _stateController.text,
                    );
                    // Navigate back to the previous screen after joining the community
                    Navigator.pop(context);
                  }
                },
                child: Text("Join"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _joinCommunity(
      String communityId,
      String userId,
      String userName,
      String email,
      String phone,
      String graduationType,
      String college,
      String persuing,
      String year,
      String city,
      String state,
      ) {
    FirebaseFirestore.instance
        .collection('communities')
        .doc(communityId)
        .update({
      'members': FieldValue.arrayUnion([userId]),
    }).then((_) {
      FirebaseFirestore.instance
          .collection('communities')
          .doc(communityId)
          .collection('members')
          .doc(userId)
          .set({
        'name': userName,
        'email': email,
        'phone': phone,
        'graduationType': graduationType,
        'college': college,
        'persuing': persuing,
        'year': year,
        'city': city,
        'state': state,
      });
    });
  }
}
