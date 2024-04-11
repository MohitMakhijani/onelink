import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:onelink/Get/fetchdata.dart';
import 'package:provider/provider.dart';
import '../../Models/xx.dart';
import '../../components/myButton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;
  DateTime? _selectedDate;
  File? _image;
  late UserModel1 myUser;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _bioController = TextEditingController();
    final userFetchController = Provider.of<UserFetchController>(context, listen: false);
    myUser = userFetchController.myUser;
    _nameController.text = myUser.name!;
    _emailController.text = myUser.email!;
    _bioController.text = myUser.bio!;
    _selectedDate = myUser.dateOfbirth as DateTime?;
    _image = myUser.profilePhotoUrl != null ? File(myUser.profilePhotoUrl!) : File('ed');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _updateUserProfile() async {
    try {
      final currentUserPhoneNumber = FirebaseAuth.instance.currentUser!.phoneNumber;
      final usersCollection = FirebaseFirestore.instance.collection('users');

      QuerySnapshot querySnapshot =
      await usersCollection.where('phoneNumber', isEqualTo: currentUserPhoneNumber).get();

      if (querySnapshot.size == 1) {
        String documentId = querySnapshot.docs[0].id;

        await usersCollection.doc(documentId).update({
          'name': _nameController.text,
          'email': _emailController.text,
          'dateOfBirth': _selectedDate,
          'bio': _bioController.text,
        });

        if (_image != null) {
          String profileImageUrl = await _uploadProfileImage(currentUserPhoneNumber!, _image!);
          await usersCollection.doc(documentId).update({'profilePhotoUrl': profileImageUrl});
        }

        final userFetchController = Provider.of<UserFetchController>(context, listen: false);
        userFetchController.fetchUserData();

        Navigator.pop(context);
      } else {
        print('User document not found for phone number: $currentUserPhoneNumber');
      }
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }

  String? _validateBio(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your bio';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  Future<String> _uploadProfileImage(String userId, File imageFile) async {
    try {
      Reference ref = FirebaseStorage.instance.ref().child('profile_images').child('$userId.jpg');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading profile image: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF888BF4),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.aladin(fontSize: MediaQuery.of(context).size.width * 0.05),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    onTap: _selectImage,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: NetworkImage(
                        myUser.profilePhotoUrl ??
                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateName,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateEmail,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _bioController,
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateBio,
                  maxLines: 3,
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          myUser.dateOfbirth.toString() == null
                              ? 'Date of Birth: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}'
                              : 'Select Date of Birth',
                          style: TextStyle(fontSize: 16),
                        ),
                        Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                MyButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _updateUserProfile();
                    }
                  },
                  text: 'Save Changes',
                  color: Color(0xFF888BF4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
