import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Models/EventmodelUI.dart'; // Import your EventPost widget or data model

class My_events extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<My_events> {
  late User? _currentUser;
  late Stream<QuerySnapshot> _userEventsStream;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      _fetchUserEvents();
    }
  }

  void _fetchUserEvents() {
    _userEventsStream = FirebaseFirestore.instance
        .collection('events')
        .where('userUid', isEqualTo: _currentUser!.phoneNumber)
        .snapshots();

    print('Current User ID: ${_currentUser!.uid}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Events'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _userEventsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<QueryDocumentSnapshot> eventDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: eventDocs.length,
            itemBuilder: (context, index) {
              var eventData = eventDocs[index].data() as Map<String, dynamic>;

              return EventUICard(
                eventName: eventData['eventName'],
                location: eventData['location'],
                eventTime: eventData['time'],
                description: eventData['description'],
                imageUrl: eventData['imageUrl'],
                eventType: eventData['eventType'],
                eventID: eventDocs[index].id,
                userId: eventData['userUid'],
                eventDate: eventData['datePublished'],
                EventStatus: eventData['EventStatus'],
              );
            },
          );
        },
      ),
    );
  }
}
