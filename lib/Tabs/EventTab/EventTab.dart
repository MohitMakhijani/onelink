import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onelink/components/myButton.dart';
import 'package:onelink/Models/EventmodelUI.dart';

import '../../Screens/event_Screen/CreateEvent.dart';
import '../../Screens/event_Screen/myEvents.dart';
import '../../Widgets/searchbar.dart';

class EventTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     SizedBox(height: 15,),
            //     MyButton1(
            //         onTap: () {
            //           Navigator.push(context, MaterialPageRoute(
            //             builder: (context) {
            //               return CreateEventPage();
            //             },
            //           ));
            //         },
            //         text: "Create Event",
            //         color: Colors.blue),
            //     MyButton1(
            //         onTap: () {
            //           Navigator.push(context, MaterialPageRoute(
            //             builder: (context) {
            //               return My_events();
            //             },
            //           ));
            //         },
            //         text: "My Events",
            //         color: Colors.blue),
            //   ],
            // ),
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
