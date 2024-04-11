import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onelink/Get/fetchdata.dart';
import 'package:onelink/Screens/Home/BottomNavPage.dart';
import 'package:onelink/Services/FirestoreMethods.dart';
import 'package:onelink/components/myButton.dart';
import 'package:onelink/components/myTextfield.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class SetUpProfile extends StatefulWidget {
  const SetUpProfile({Key? key}) : super(key: key);

  @override
  State<SetUpProfile> createState() => _SetUpProfileState();
}

class _SetUpProfileState extends State<SetUpProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  Uint8List? _file;
  DateTime? _selectedDate;
  Uuid uuid = Uuid();

  Future<Uint8List?> _selectImage(BuildContext parentContext) async {
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Uint8List fileBytes = await pickedFile.readAsBytes();
      return fileBytes;
    }
    return null;
  }

  late UserFetchController userFetchController;

  @override
  void initState() {
    super.initState();
    userFetchController =
        Provider.of<UserFetchController>(context, listen: false);
    userFetchController.fetchUserData();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  String? _validateInput(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (fieldName == 'Email') {
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        return 'Please enter a valid email address';
      }
    }
    if (fieldName == 'Date of Birth') {
      if (_selectedDate == null) {
        return 'Please select Date of Birth';
      } else if (_selectedDate!.year < 1960 || _selectedDate!.year > 2018) {
        return 'Date of Birth should be between 1960 and 2018';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 85.0, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add your",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "Information and",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "Profile photo",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 58),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 25, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundImage: _file != null
                          ? MemoryImage(_file!)
                      as ImageProvider // Cast MemoryImage to ImageProvider
                          : AssetImage('Assets/images/Avatar.png')
                      as ImageProvider, // Cast AssetImage to ImageProvider
                      radius: 60,
                    ),
                    MyButton1(
                      onTap: () async {
                        Uint8List? file = await _selectImage(context);
                        if (file != null) {
                          setState(() {
                            _file = file;
                          });
                        }
                      },
                      text: "Upload Photo",
                      color: Color(0xFF888BF4),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              MyTextField(
                controller: _nameController,
                hint: "Name",
                obscure: false,
                selection: true,
                preIcon: Icons.drive_file_rename_outline,
                keyboardtype: TextInputType.name,
                validator: (value) => _validateInput(value, fieldName: 'Name'),
              ),
              MyTextField(
                controller: _emailController,
                hint: "Email",
                obscure: false,
                selection: true,
                preIcon: Icons.mail,
                keyboardtype: TextInputType.emailAddress,
                validator: (value) => _validateInput(value, fieldName: 'Email'),
              ),
              MyTextField(
                controller: _bioController,
                hint: "Bio",
                obscure: false,
                selection: true,
                preIcon: Icons.info,
                keyboardtype: TextInputType.multiline,
                validator: (value) => null, // You can add validation if needed
              ),

              SizedBox(height: 15),
              // Date of Birth Picker
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate != null
                            ? 'Date of Birth: ${_selectedDate!.toString().split(' ')[0]}'
                            : 'Select Date of Birth',
                      ),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              MyButton(
                onTap: () {
                  String? nameError = _validateInput(_nameController.text, fieldName: 'Name');
                  String? emailError = _validateInput(_emailController.text, fieldName: 'Email');
                  if (nameError == null && emailError == null && _selectedDate != null) {
                    FireStoreMethods().createUser(
                      userId: FirebaseAuth.instance.currentUser!.uid,
                      name: _nameController.text.trim(),
                      email: _emailController.text.trim(),
                      profilePhotoUrl: '', // Don't pass anything here
                      dateOfBirth: _selectedDate!,
                      postCount: 0,
                      context: context,
                      imageBytes: _file,
                      phoneNumber: "${FirebaseAuth.instance.currentUser!.phoneNumber}",
                      bio: _bioController.text.trim(),
                    );
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return HomeScreen();
                      },
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please fill all the fields correctly and select Date of Birth',
                        ),
                      ),
                    );
                  }
                },
                text: "Select And Continue",
                color: Color(0xFF888BF4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
