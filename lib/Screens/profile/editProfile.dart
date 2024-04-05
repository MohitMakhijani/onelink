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
  late TextEditingController _phoneController;
  DateTime? _selectedDate;
  File? _image; // Initialize _image to null
  late UserModel1 myUser; // Define myUser variable

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    final userFetchController = Provider.of<UserFetchController>(context, listen: false);
    myUser = userFetchController.myUser; // Fetch user data from UserFetchController
    _nameController.text = myUser.name!;
    _emailController.text = myUser.email!;
    _phoneController.text = myUser.phoneNumber!;
    _selectedDate = myUser.dateOfbirth as DateTime?;
    _image = myUser.profilePhotoUrl != null ? File(myUser.profilePhotoUrl!) : File('ed');
  }


  // Remainig
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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

      // Query Firestore for the document with the current user's phoneNumber
      QuerySnapshot querySnapshot = await usersCollection.where('phoneNumber', isEqualTo: currentUserPhoneNumber).get();

      // Check if a document matching the phoneNumber exists
      if (querySnapshot.size == 1) {
        // Extract the document ID from the query result
        String documentId = querySnapshot.docs[0].id;

        // Update the document fields
        await usersCollection.doc(documentId).update({
          'name': _nameController.text,
          'email': _emailController.text,
          'phoneNumber': _phoneController.text,
          'dateOfBirth': _selectedDate, // Assuming _selectedDate is already DateTime type
          // Add other fields as needed
        });

        // Update the user information in the UserFetchController using Provider
        final userFetchController = Provider.of<UserFetchController>(context, listen: false);
        userFetchController.fetchUserData(); // Fetch updated user data

        // Navigate back to profile page after successful update
        Navigator.pop(context);
      } else {
        print('User document not found for phone number: $currentUserPhoneNumber');
      }
    } catch (e) {
      print('Error updating user profile: $e');
      // Handle error
    }
  }


  Future<String> _uploadProfileImage(String userId, File imageFile) async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$userId.jpg');
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
      appBar:AppBar(backgroundColor: Color(0xFF888BF4),title: Text("Edit Profile",style: GoogleFonts.aladin(fontSize: MediaQuery.of(context).size.width*0.05)),) ,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: _selectImage,
                child:CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                      myUser.profilePhotoUrl??
                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png')
                )
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        myUser.dateOfbirth.toString()==null
                            ? 'Date of Birth: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}'
                            : 'Select Date of Birth',
                      ),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              MyButton(
                onTap: _updateUserProfile,
                text: 'Save Changes',
                color: Color(0xFF888BF4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
