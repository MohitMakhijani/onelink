import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onelink/components/myTextField.dart';

class ApplyJobPage extends StatefulWidget {
  final String jobId;

  ApplyJobPage({required this.jobId});

  @override
  _ApplyJobPageState createState() => _ApplyJobPageState();
}

class _ApplyJobPageState extends State<ApplyJobPage> {
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

  Future<void> _joinJob() async {
    try {
      QuerySnapshot jobSnapshot = await FirebaseFirestore.instance
          .collection('jobs')
          .where('JobId', isEqualTo: widget.jobId)
          .get();

      if (jobSnapshot.docs.isNotEmpty) {
        DocumentSnapshot jobDoc = jobSnapshot.docs.first;

        String currentUserName = _nameController.text;
        String currentUserEmail = _emailController.text;
        String currentUserPhone = _phoneController.text;
        String currentUserResume = _resumeController.text;
        String currentUserLinkedIn = _linkedinController.text;
        String currentUserGithub = _githubController.text;
        String currentUserDescription = _descriptionController.text;
        String currentUserExperience = _experienceController.text;
        String currentUserSkills = _skillsController.text;
        String currentUserPortfolio = _portfolioController.text;
        String currentUserEducation = _educationController.text;

        Map<String, dynamic> candidateData = {
          'name': currentUserName,
          'email': currentUserEmail,
          'phone': currentUserPhone,
          'resume': currentUserResume,
          'linkedin': currentUserLinkedIn,
          'github': currentUserGithub,
          'description': currentUserDescription,
          'experience': currentUserExperience,
          'skills': currentUserSkills,
          'portfolio': currentUserPortfolio,
          'education': currentUserEducation,
        };

        await jobDoc.reference.collection('appliedCandidates').add(candidateData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Applied for the job successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
        // You can add any other action here after successful application
      } else {
        print('No job found with ID: ${widget.jobId}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error applying for the job: $e'),
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
        title: Text('Apply for Job'),
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
                      // Access the form values using the controllers
                      String name = _nameController.text;
                      String email = _emailController.text;
                      String phone = _phoneController.text;
                      String resume = _resumeController.text;
                      String linkedin = _linkedinController.text;
                      String github = _githubController.text;
                      String description = _descriptionController.text;
                      String experience = _experienceController.text;
                      String skills = _skillsController.text;
                      String portfolio = _portfolioController.text;
                      String education = _educationController.text;
                      _joinJob(); // Corrected method call
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
