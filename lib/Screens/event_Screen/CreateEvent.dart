import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:onelink/components/myButton.dart';
import 'package:onelink/components/myTextfield.dart';
import 'package:uuid/uuid.dart';
import '../../Models/eventModel.dart';

class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _image;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedEventType = '';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Uuid uuid = Uuid();
  final UserID = FirebaseAuth.instance.currentUser!.phoneNumber;

  void _uploadEvent() async {
    if (_selectedDate == null ||
        _selectedTime == null ||
        _selectedEventType.isEmpty ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields and select an image'),
        ),
      );
      return;
    }

    DateTime eventDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    EventModel newEvent = EventModel(
      userUid: "${UserID}",
      eventID: uuid.v1(),
      name: _eventNameController.text.trim(),
      location: _locationController.text.trim(),
      time: DateFormat('HH:mm').format(eventDateTime),
      description: _descriptionController.text.trim(),
      imageUrl: '',
      eventDate: eventDateTime,
      EventType: _selectedEventType,
      EventStatus: 'Pending',
    );

    try {
      // Upload image to Firebase Storage
      final storagePath = 'events/${newEvent.eventID}.jpg';
      final storageRef = FirebaseStorage.instance.ref().child(storagePath);
      await storageRef.putFile(_image!);

      // Get download URL of the uploaded image
      final imageUrl = await storageRef.getDownloadURL();

      // Update Firestore document with image URL
      await FirebaseFirestore.instance.collection('events').add({
        ...newEvent.toMap(),
        'imageUrl': imageUrl,
      });

      // Clear fields and reset state after successful upload
      _eventNameController.clear();
      _locationController.clear();
      _descriptionController.clear();
      setState(() {
        _image = null;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event uploaded successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error uploading event: $e');
      // Handle error if any occurred during upload
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading event. Please try again later.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF888BF4), title:   Text(
        'Event Details',
        style: GoogleFonts.aladin(fontSize: 20, fontWeight: FontWeight.bold),
      ),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 10),
              MyTextField(
                  controller: _eventNameController,
                  hint: "Event Name",
                  obscure: false,
                  selection: true,
                  preIcon: Icons.drive_file_rename_outline,
                  keyboardtype: TextInputType.name),
              SizedBox(height: 16),
              MyTextField(
                  controller: _locationController,
                  hint: "Event Location",
                  obscure: false,
                  selection: true,
                  preIcon: FontAwesomeIcons.locationArrow,
                  keyboardtype: TextInputType.name),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                        controller: TextEditingController(
                          text: _selectedDate == null
                              ? ''
                              : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                        ),
                        hint: "Select Date",
                        obscure: false,
                        selection: true,
                        preIcon: FontAwesomeIcons.calendar,
                        keyboardtype: TextInputType.name),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xFF888BF4))),
                    onPressed: () => _selectDate(context),
                    child: Text('Select Date',style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(

                    child:MyTextField(
                        controller:     TextEditingController(
                          text: _selectedTime == null
                              ? ''
                              : _selectedTime!.format(context),
                        ),
                        hint: "Select Time",
                        obscure: false,
                        selection: true,
                        preIcon: FontAwesomeIcons.timesCircle,
                        keyboardtype: TextInputType.name),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xFF888BF4))),
                    onPressed: () => _selectTime(context),
                    child: Text('Select Time',style: TextStyle(color: Colors.white),
                  ),
                  )],
              ),


              SizedBox(height: 16),
              MyTextField(
                  controller: _descriptionController,
                  hint: "Add Description",
                  obscure: false,
                  selection: true,
                  preIcon: Icons.description,
                  keyboardtype: TextInputType.text),
              SizedBox(height: 16),
              CupertinoSegmentedControl<String>(
                children: {
                  'Physical Event': Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Physical Event'),
                  ),
                  'Virtual Event': Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Virtual Event'),
                  ),
                },
                onValueChanged: (value) {
                  setState(() {
                    _selectedEventType = value ?? '';
                  });
                },
                groupValue: _selectedEventType.isEmpty ? null : _selectedEventType,
                borderColor: Colors.blue, // Customize border color
                selectedColor: Colors.blue, // Customize selected segment color
                unselectedColor: Colors.white, // Customize unselected segment color
              ),
              SizedBox(height: 16),
              MyButton(
                onTap: () async {
                  final imagePicker = ImagePicker();
                  final pickedImage =
                  await imagePicker.getImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    setState(() {
                      _image = File(pickedImage.path);
                    });
                  }
                },
                text: 'Select Image', color: Colors.blue[300],
              ),
              SizedBox(height: 16),
              MyButton(color:Color(0xFF888BF4),
                onTap:
                 () => _uploadEvent(),
                text:"Upload Event" ,

              )

            ],
          ),
        ),
      ),
    );
  }
}
