import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../Theme.dart';
import '../../UI-Models/EventmodelUI.dart';// Import your EventPost widget or data model

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
        .where('userUid', isEqualTo: _currentUser!.uid)
        .snapshots();

    print('Current User ID: ${_currentUser!.uid}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.light?Colors.white:Colors.black,
      appBar: AppBar(
           foregroundColor: !AppTheme.light?Colors.white:Colors.black,
        backgroundColor: Colors.red,
        // leading: IconButton(onPressed: (){

        // }, icon: Icon(Icons)),
        title: Text('Hosted Events',style:
         GoogleFonts.inter(
          color:!AppTheme.light?Colors.white:Colors.black,
          fontSize: MediaQuery.of(context).size.width*0.06),),

      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _userEventsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child:  LoadingAnimationWidget.staggeredDotsWave(
              color: Color.fromARGB(255, 244, 66, 66),
              size:50,
            ),);
          }

          List<QueryDocumentSnapshot> eventDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: eventDocs.length,
            itemBuilder: (context, index) {
              var eventData = eventDocs[index].data() as Map<String, dynamic>;

              return Column(
                children: [
                  Container(
                      child: Text("Event Status- ${eventData['EventStatus']}",style: GoogleFonts.inter(fontSize: 15,color: AppTheme.light?Colors.black:Colors.white),)),
                  EventUICard(
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
                      price:eventData['EventPrice']
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
