import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onelink/components/myButton.dart';
import 'package:onelink/components/myTextField.dart';
import 'package:uuid/uuid.dart';
import 'package:validators/validators.dart' as validator;


class JobPostingPage extends StatefulWidget {
  @override
  _JobPostingPageState createState() => _JobPostingPageState();
}

class _JobPostingPageState extends State<JobPostingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _skillsRequiredController = TextEditingController();
  final TextEditingController _aboutJobController = TextEditingController();
  final TextEditingController _aboutCompanyController = TextEditingController();
  final TextEditingController _eligibilityController = TextEditingController();
  final TextEditingController _openingsController = TextEditingController();
  File? _image;
  final uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF888BF4),
        title: Text(
          'Post a Job',
          style: GoogleFonts.aladin(fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTextField(
                controller: _jobTitleController,
                hint: 'Job Title',
                obscure: false,
                selection: false,
                preIcon: Bootstrap.journal_bookmark,
                keyboardtype: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a job title';
                  }
                  return null;
                },
              ),
              MyTextField(
                controller: _descriptionController,
                hint: 'Description',
                obscure: false,
                selection: false,
                preIcon: Icons.bolt,
                keyboardtype: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a job description';
                  }
                  return null;
                },
              ),
              MyTextField(
                controller: _locationController,
                hint: 'Location',
                obscure: false,
                selection: false,
                preIcon: Icons.abc,
                keyboardtype: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the job location';
                  }
                  return null;
                },
              ),
              MyTextField(
                controller: _salaryController,
                hint: 'Salary',
                obscure: false,
                selection: false,
                preIcon: Icons.abc,
                keyboardtype: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the job salary';
                  }
                  return null;
                },
              ),
              MyTextField(
                controller: _experienceController,
                hint: 'Experience Required',
                obscure: false,
                selection: false,
                preIcon: Icons.abc,
                keyboardtype: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the required experience';
                  }
                  return null;
                },
              ),
              MyTextField(
                controller: _companyNameController,
                hint: 'Company Name',
                obscure: false,
                selection: false,
                preIcon: Clarity.namespace_line,
                keyboardtype: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the company name';
                  }
                  return null;
                },
              ),
              MyTextField(
                controller: _skillsRequiredController,
                hint: 'Skills Required',
                obscure: false,
                selection: false,
                preIcon: Icons.skip_next,
                keyboardtype: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the required skills';
                  }
                  return null;
                },
              ),
              MyTextField(
                controller: _aboutJobController,
                hint: 'About the Job',
                obscure: false,
                selection: false,
                keyboardtype: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide information about the job';
                  }
                  return null;
                },
                preIcon: Icons.align_vertical_bottom_outlined,
              ),
              MyTextField(
                controller: _aboutCompanyController,
                hint: 'About the Company',
                obscure: false,
                selection: false,
                preIcon: Icons.compost,
                keyboardtype: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide information about the company';
                  }
                  return null;
                },
              ),
              MyTextField(
                controller: _eligibilityController,
                hint: 'Eligibility',
                obscure: false,
                selection: false,
                preIcon: Icons.elderly,
                keyboardtype: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please specify the eligibility criteria';
                  }
                  return null;
                },
              ),
              MyTextField(
                controller: _openingsController,
                hint: 'Number of Openings',
                obscure: false,
                selection: false,
                preIcon: Icons.open_in_browser,
                keyboardtype: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please specify the number of job openings';
                  }
                  if (!validator.isNumeric(value)) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: _selectImage,
                child: Container(
                  height: 150.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _image == null
                      ? Center(child: Text('Select an Image'))
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 20.0),
              MyButton(
                onTap: () {
                  _submitForm();
                },
                text: "Submit",
                color: Color(0xFF888BF4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_image == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please select an image for the job posting'),
            ),
          );
          return;
        }

        final imageRef = FirebaseStorage.instance
            .ref()
            .child('job_images/${DateTime.now().toIso8601String()}');
        final UploadTask uploadTask = imageRef.putFile(_image!);
        final TaskSnapshot downloadUrl = await uploadTask;
        final String imageUrl = await downloadUrl.ref.getDownloadURL();
        final Userid = FirebaseAuth.instance.currentUser!.phoneNumber;

        final jobData = {
          'appliedCandidates': [],
          'jobStatus': 'pending',
          'UserId': "${Userid}",
          'JobId': uuid.v1(),
          'jobTitle': _jobTitleController.text,
          'description': _descriptionController.text,
          'location': _locationController.text,
          'salary': _salaryController.text,
          'experience': _experienceController.text,
          'companyName': _companyNameController.text,
          'jobPosted': DateTime.now().toString(),
          'skillsRequired': _skillsRequiredController.text,
          'aboutJob': _aboutJobController.text,
          'aboutCompany': _aboutCompanyController.text,
          'eligibility': _eligibilityController.text,
          'openings': int.parse(_openingsController.text),
          'imageUrl': imageUrl,
        };

        await FirebaseFirestore.instance.collection('jobs').add(jobData);

        _jobTitleController.clear();
        _descriptionController.clear();
        _locationController.clear();
        _salaryController.clear();
        _experienceController.clear();
        _companyNameController.clear();
        _skillsRequiredController.clear();
        _aboutJobController.clear();
        _aboutCompanyController.clear();
        _eligibilityController.clear();
        _openingsController.clear();
        setState(() {
          _image = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Job posted successfully'),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to post job: $error'),
          ),
        );
      }
    }
  }
}
