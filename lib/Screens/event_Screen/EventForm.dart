import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onelink/components/myTextField.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore

class EventForm extends StatefulWidget {
  final String eventId;

  EventForm({required this.eventId});

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _resumeController = TextEditingController();
  TextEditingController _linkedinController = TextEditingController();
  TextEditingController _githubController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _experienceController = TextEditingController();
  TextEditingController _skillsController = TextEditingController();
  TextEditingController _portfolioController = TextEditingController();
  TextEditingController _educationController = TextEditingController();

  Future<void> _joinEvent() async {
    try {print(widget.eventId);
      DocumentReference eventRef = FirebaseFirestore.instance.collection('events').doc(widget.eventId);

      Map<String, dynamic> participantData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'resume': _resumeController.text,
        'linkedin': _linkedinController.text,
        'github': _githubController.text,
        'description': _descriptionController.text,
        'experience': _experienceController.text,
        'skills': _skillsController.text,
        'portfolio': _portfolioController.text,
        'education': _educationController.text,
        // 'phoneNumber': FirebaseAuth.instance..currentUser!.phoneNumber.toString,

      };

      await eventRef.update({
        'participants': FieldValue.arrayUnion([participantData]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Applied for the event successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error applying for the event: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Apply for Event'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyTextField(
                  controller: _nameController,
                  hint: 'Name',
                  keyboardtype: TextInputType.text,
                  preIcon: Icons.person,
                  obscure: false,
                  selection: false,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: _emailController,
                  hint: 'Email',
                  keyboardtype: TextInputType.emailAddress,
                  preIcon: Icons.email,
                  obscure: false,
                  selection: false,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: _phoneController,
                  hint: 'Phone Number',
                  keyboardtype: TextInputType.phone,
                  preIcon: Icons.phone,
                  obscure: false,
                  selection: false,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: _resumeController,
                  hint: 'Resume Link',
                  keyboardtype: TextInputType.url,
                  preIcon: Icons.link,
                  obscure: false,
                  selection: false,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: _linkedinController,
                  hint: 'LinkedIn Link',
                  keyboardtype: TextInputType.url,
                  preIcon: Icons.link,
                  obscure: false,
                  selection: false,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: _githubController,
                  hint: 'GitHub Link',
                  keyboardtype: TextInputType.url,
                  preIcon: Icons.link,
                  obscure: false,
                  selection: false,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: _descriptionController,
                  hint: 'Description',
                  keyboardtype: TextInputType.multiline,
                  preIcon: Icons.description,
                  obscure: false,
                  selection: false,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: _experienceController,
                  hint: 'Past Experience',
                  keyboardtype: TextInputType.multiline,
                  preIcon: Icons.work,
                  obscure: false,
                  selection: false,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: _skillsController,
                  hint: 'Skills',
                  keyboardtype: TextInputType.multiline,
                  preIcon: Icons.star,
                  obscure: false,
                  selection: false,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: _portfolioController,
                  hint: 'Portfolio Link',
                  keyboardtype: TextInputType.url,
                  preIcon: Icons.link,
                  obscure: false,
                  selection: false,
                ),
                SizedBox(height: 10),
                MyTextField(
                  controller: _educationController,
                  hint: 'Education',
                  keyboardtype: TextInputType.multiline,
                  preIcon: Icons.school,
                  obscure: false,
                  selection: false,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Form is valid, proceed with submission
                      _joinEvent();
                      // Now you can use these values for further processing or submission
                    }
                  },
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    elevation: 4,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
