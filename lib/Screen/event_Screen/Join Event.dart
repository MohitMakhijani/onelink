import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Theme.dart';
import '../../components/myButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../utils/utils.dart';
import 'EventForm.dart';

class JoinEvent extends StatefulWidget {
  final String eventName;
  final String location;
  final String time;
  final String description;
  final String imageUrl;
  final String price;
  final String eventType;
  final String eventId;
  final String userId;



  JoinEvent({
    required this.eventName,
    required this.location,
    required this.time,
    required this.description,
    required this.imageUrl,
    required this.eventType,
    required this.eventId,
    required this.userId,
    required this.price,
  });

  @override
  _JoinEventState createState() => _JoinEventState();
}

class _JoinEventState extends State<JoinEvent> {
  late User? _currentUser;
  bool _userJoinedEvent = false;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _checkUserJoinedEvent();
  }

  void _getCurrentUser() {
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> _deleteEvent() async {
    try {
      DocumentReference eventRef = FirebaseFirestore.instance.collection('events').doc(widget.eventId);
      DocumentSnapshot eventSnapshot = await eventRef.get();

      if (eventSnapshot.exists) {
        await eventRef.delete();
        showSnackBar(context, "Event Deleted Successfully");
        Navigator.pop(context);
      } else {
        print('No document found with eventId: ${widget.eventId}');
      }
    } catch (e) {
      print('Error deleting event: $e');
    }
  }

  Future<void> _checkUserJoinedEvent() async {
    try {
      QuerySnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('eventID', isEqualTo: widget.eventId)
          .get();

      if (eventSnapshot.docs.isNotEmpty) {
        DocumentSnapshot eventDoc = eventSnapshot.docs.first;
        List<dynamic> participants = eventDoc['participants'];
        setState(() {
          _userJoinedEvent = participants.any((participant) => participant['UserId'] == _currentUser!.uid);
        });
      }
    } catch (e) {
      print('Error checking user participation: $e');
    }
  }

  Future<void> _leaveEvent() async {
    try {
      QuerySnapshot eventSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('eventID', isEqualTo: widget.eventId)
          .get();

      if (eventSnapshot.docs.isNotEmpty) {
        DocumentSnapshot eventDoc = eventSnapshot.docs.first;
        List<dynamic> participants = eventDoc['participants'];
        participants.removeWhere((participant) => participant['UserId'] == _currentUser!.uid);
        await eventDoc.reference.update({'participants': participants});
        showSnackBar(context, "You have left the event");
        setState(() {
          _userJoinedEvent = false;
        });
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error leaving event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool createdByCurrentUser = _currentUser != null && _currentUser!.uid == widget.userId;

    return Scaffold(
      backgroundColor: AppTheme.light ? Colors.white : Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        title: Text(
          'Event Details',
          style: GoogleFonts.inter(fontSize: 25.sp, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    widget.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                widget.eventName,
                style: GoogleFonts.abrilFatface(
                  fontSize: 24.sp,
                  color: AppTheme.light ? Colors.black : Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  FaIcon(FontAwesomeIcons.indianRupeeSign, color: AppTheme.light ? Colors.red : Colors.red),
                  SizedBox(width: 8.0),
                  Text(
                    widget.price+"/-",
                    style: TextStyle(color: AppTheme.light ? Colors.red : Colors.red, fontSize: 16.sp),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  FaIcon(FontAwesomeIcons.locationCrosshairs, color: AppTheme.light ? Colors.black : Colors.white),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      widget.location,
                      style: TextStyle(color: AppTheme.light ? Colors.black : Colors.white, fontSize: 16.sp),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  FaIcon(FontAwesomeIcons.clock, color: AppTheme.light ? Colors.black : Colors.white),
                  SizedBox(width: 8.0),
                  Text(
                    widget.time,
                    style: TextStyle(color: AppTheme.light ? Colors.black : Colors.white, fontSize: 16.sp),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  FaIcon(FontAwesomeIcons.meetup, color: widget.eventType == 'Physical Event' ? Colors.red : Colors.green),
                  SizedBox(width: 8.0),
                  Text(
                    widget.eventType,
                    style: TextStyle(
                      color: widget.eventType == 'Physical Event' ? Colors.red : Colors.green,
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                widget.description,
                style: TextStyle(color: AppTheme.light ? Colors.black : Colors.white, fontSize: 16.sp),
              ),
              SizedBox(height: 20.0),
              Divider(),
              if (createdByCurrentUser)
                MyButton(
                  onTap: () async {
                    bool confirmDelete = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm Delete'),
                          content: Text('Are you sure you want to delete this Event?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmDelete != null && confirmDelete) {
                      await _deleteEvent();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Event deleted')),
                      );
                      Navigator.pop(context); // Pop back to previous screen after deletion
                    }
                  },
                  text: "Delete Event",
                  color: Colors.red,
                )
              else
                MyButton(
                  onTap: _userJoinedEvent ? _leaveEvent : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventForm(eventId: widget.eventId, price: widget.price,),
                      ),
                    );
                  },
                  text: _userJoinedEvent ? "Leave Event" : "Fill Form to Join Event",
                  color: Colors.red,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
