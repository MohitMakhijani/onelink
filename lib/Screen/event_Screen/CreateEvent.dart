import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../Models/eventModel.dart';
import '../../Theme.dart';
import '../../Widgets/Success Widget.dart';
import '../../components/myButton.dart';
import '../../components/myTextfield.dart';

class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _eventPrice = TextEditingController();
  File? _image;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TimeOfDay? _endTime;
  String _selectedEventType = 'Physical Event';
  Uuid uuid = Uuid();
  final UserID = FirebaseAuth.instance.currentUser!.uid;
  // void _pickLocation() async {
  //   LatLng? pickedLocation = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => LocationPickerPage()),
  //   );
  //
  //   if (pickedLocation != null) {
  //     _locationController.text =
  //     '${pickedLocation.latitude}, ${pickedLocation.longitude}';
  //   }
  // }
  // Function to select date
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

  // Function to select time
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
   Future<void> _EndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _endTime = picked;
      });
    }
  }


  // Function to upload event
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
      EventPrice: _eventPrice.text.trim(),
      userUid: "${UserID}",
      eventID: uuid.v1(),
      name: _eventNameController.text.trim(),
      location: _locationController.text.trim(),
      time: DateFormat('HH:mm').format(eventDateTime),
      description: _descriptionController.text.trim(),
      imageUrl: '', // Placeholder for imageUrl
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
        _selectedEventType = ''; // Clear selected event type
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event uploaded successfully')),
      );
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessWidget(
                text1: 'Your Event is Posted',
                text2: 'It will apporved by admin shortly'),
          )); // Close create event page
    } catch (e) {
      print('Error uploading event: $e');
      // Handle error if any occurred during upload
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error uploading event. Please try again later.')),
      );
    }
  }

  // Validator for event name
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an event name';
    }
    return null;
  }

  // Validator for event location
  String? _validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the event location';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.light ? Colors.white : Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        title: Text(
          'Event Details',
          style: GoogleFonts.aladin(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
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
                //  preIcon: Icons.drive_file_rename_outline,
                keyboardtype: TextInputType.name,
                validator: _validateName,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: TextEditingController(
                        text: _locationController.text

                      ),
                      hint: "Select Location",
                      obscure: false,
                      selection: true,
                      // preIcon: FontAwesomeIcons.calendar,
                      keyboardtype: TextInputType.name,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red)),
                    onPressed: () {},
                    child: Text(
                      'Pick Location',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),SizedBox(height: 16),
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
                      // preIcon: FontAwesomeIcons.calendar,
                      keyboardtype: TextInputType.name,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red)),
                    onPressed: () => _selectDate(context),
                    child: Text(
                      'Select Date',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: TextEditingController(
                        text: _selectedTime == null
                            ? ''
                            : _selectedTime!.format(context),
                      ),
                      hint: "Start Time",
                      obscure: false,
                      selection: true,
                      // preIcon: FontAwesomeIcons.timesCircle,
                      keyboardtype: TextInputType.name,
                    ),
                  ),
                  
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red)),
                    onPressed: () => _selectTime(context),
                    child: Text(
                      'Select Time',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
               Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: TextEditingController(
                        text: _endTime == null
                            ? ''
                            : _endTime!.format(context),
                      ),
                      hint: "End Time",
                      obscure: false,
                      selection: true,
                     // preIcon: FontAwesomeIcons.timesCircle,
                      keyboardtype: TextInputType.name,
                    ),
                  ),
                  
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
                    onPressed: () => _EndTime(context),
                    child: Text(
                      'Select Time',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              MyTextField(
                controller: _descriptionController,
                hint: "Add Description",
                obscure: false,
                selection: true,
                //  preIcon: Icons.description,
                keyboardtype: TextInputType.text,
              ),
              SizedBox(height: 16),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: _eventPrice,
                      hint: "Add Price",
                      obscure: false,
                      selection: true,
                      //  preIcon: Icons.description,
                      keyboardtype: TextInputType.number,
                    ),
                  ),  SizedBox(width: 11.w),
                  Container(
                    decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(15)),
                    width: 50.w,
                    height: 50.h,
                    child: Center(
                      child: Text('Rs',style: GoogleFonts.inter(
                        fontSize: 15.sp,color: Colors.white,fontWeight: FontWeight.bold
                      ),),
                    ),
                  )
                ],
              ),
              SizedBox(height: 16),
              Container(
                height: 200,
                width: double.infinity,
                decoration: _image != null
                    ? BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(_image!),
                          fit: BoxFit.cover,
                        ),
                      )
                    : BoxDecoration(),
                child: _image == null
                    ? Center(
                        child: Text(
                          'No image selected',
                          style: TextStyle(
                              color:
                                  AppTheme.light ? Colors.black : Colors.white),
                        ),
                      )
                    : null,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red)),
                    onPressed: () async {
                      final imagePicker = ImagePicker();
                      final pickedImage = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      if (pickedImage != null) {
                        setState(() {
                          _image = File(pickedImage.path);
                        });
                      }
                    },
                    child: Text(
                      'Select Image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DropdownButton<String>(
                    value:
                        _selectedEventType.isEmpty ? null : _selectedEventType,
                    items: [
                      DropdownMenuItem(
                        child: Text('Physical Event',
                            style: TextStyle(color: Colors.red)),
                        value: 'Physical Event',
                      ),
                      DropdownMenuItem(
                        child: Text('Virtual Event',
                            style: TextStyle(color: Colors.red)),
                        value: 'Virtual Event',
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedEventType = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              MyButton(
                color: Colors.red,
                onTap: () => _uploadEvent(),
                text: "Upload Event",
              )
            ],
          ),
        ),
      ),
    );
  }
}
