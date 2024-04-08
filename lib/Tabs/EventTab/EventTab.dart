import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onelink/Screens/event_Screen/Joined_Event.dart';
import 'package:onelink/components/myButton.dart';
import 'package:onelink/Models/EventmodelUI.dart';

import '../../Screens/event_Screen/CreateEvent.dart';
import '../../Screens/event_Screen/myEvents.dart';
import '../../Widgets/Expandable_fab.dart';
import '../../Widgets/actionButton.dart';
import '../../Widgets/searchbar.dart';

class EventTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ExpandableFab(children: [
        ActionButton(
          icon: const Icon(
            Icons.create,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration:
                    Duration(milliseconds: 500), // Adjust duration as needed
                pageBuilder: (context, animation, secondaryAnimation) =>
                    CreateEventPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = Offset(0.0, 1.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end).chain(
                    CurveTween(curve: curve),
                  );

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          },
        ),
        ActionButton(
          icon: const Icon(
            Icons.view_agenda,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration:
                    Duration(milliseconds: 500), // Adjust duration as needed
                pageBuilder: (context, animation, secondaryAnimation) =>
                    MyParticipatedEventsPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = Offset(0.0, 1.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end).chain(
                    CurveTween(curve: curve),
                  );

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          },
        ),
        ActionButton(
          icon: const Icon(
            Icons.join_full_sharp,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration:
                    Duration(milliseconds: 500), // Adjust duration as needed
                pageBuilder: (context, animation, secondaryAnimation) =>
                    My_events(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  var begin = Offset(0.0, 1.0);
                  var end = Offset.zero;
                  var curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end).chain(
                    CurveTween(curve: curve),
                  );

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              ),
            );
          },
        ),
      ], distance: 120),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          children: [
            Divider(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('events').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      var eventData =
                          eventDocs[index].data() as Map<String, dynamic>;
                      if (eventData['EventStatus'] == 'Accepted') {
                        return EventUICard(
                          eventName: eventData['eventName'],
                          location: eventData['location'],
                          eventTime: eventData['time'],
                          description: eventData['description'],
                          imageUrl: eventData['imageUrl'],
                          eventType: eventData['eventType'],
                          eventID: eventData['eventID'],
                          userId: eventData['userUid'],
                          eventDate: eventData['datePublished'],
                          EventStatus: eventData['EventStatus'],
                        );
                      } else {
                       return Container();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
