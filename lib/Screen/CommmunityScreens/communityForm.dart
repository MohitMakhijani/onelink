import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onelink/Theme.dart';
import 'package:onelink/components/myTextField.dart';

class JoinCommunityForm extends StatelessWidget {
  final String communityId;
  final String userId;
  final int communityIndex; // Added communityIndex to determine the form

  JoinCommunityForm({
    required this.communityId,
    required this.userId,
    required this.communityIndex,
  });

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
    List<Widget> formFields = [];

    if (communityIndex == 1) {
      formFields = [
        MyTextField(
          controller: _nameController,
          hint: 'Your Name',
          obscure: false,
          selection: true,

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

          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your graduation type';
            }
            return null;
          },
        ),
        // Add more fields for index 1
        // ...
      ];
    } else if (communityIndex == 2) {
      formFields = [
        MyTextField(
          controller: _nameController,
          hint: 'Your Name',
          obscure: false,
          selection: true,
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
          hint: 'Contact Phone',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your contact phone number';
            }
            // Add phone validation if needed
            return null;
          },
        ),
        MyTextField(
          controller: _collegeController,
          hint: 'Organization/Company Name',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your organization/company name';
            }
            return null;
          },
        ),
        MyTextField(
          controller: _persuingController,
          hint: 'Website (Optional)',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        // Add more fields for index 2
        // ...
      ];
    }

    return Scaffold(
      backgroundColor: AppTheme.light?Colors.white:Colors.black,
      appBar: AppBar(
        backgroundColor: AppTheme.light?Colors.white:Colors.black,
        leading: IconButton(onPressed: 
        (){
          Navigator.pop(context);
        }

        , icon: Icon(Icons.arrow_back,
        color: !AppTheme.light?Colors.white:Colors.black,
        )),
        title: Text('Join Community Form',
        style: TextStyle(
          color: !AppTheme.light?Colors.white:Colors.black,
        ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ...formFields, // Display form fields based on community index
              SizedBox(height: 16),
              ElevatedButton(
                 style: ElevatedButton.styleFrom(
    backgroundColor:!AppTheme.light?Colors.white:Colors.black, // Set the background color here
  ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _joinCommunity();
                    Navigator.pop(context); // Navigate back after joining
                  }
                },
                child: Text("Join",
                style: TextStyle(
                  color: AppTheme.light?Colors.white:Colors.black,
                ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _joinCommunity() {
    // Save data to Firestore based on the entered data
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
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'graduationType': _graduationTypeController.text,
        'college': _collegeController.text,
        'persuing': _persuingController.text,
        // Add more fields to save based on the form
        // ...
      });
    });
  }
}