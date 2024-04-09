import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchTabController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  RxList<DocumentSnapshot> searchResults = RxList<DocumentSnapshot>();

  void performSearch(String query) async {
    try {
      List<DocumentSnapshot> results = [];

      // Search for users
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isEqualTo: query)
          .get();
      results.addAll(usersSnapshot.docs);

      // Search for events
      QuerySnapshot eventsSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('name', isEqualTo: query)
          .get();
      results.addAll(eventsSnapshot.docs);

      // Search for jobs
      QuerySnapshot jobsSnapshot = await FirebaseFirestore.instance
          .collection('jobs')
          .where('title', isEqualTo: query)
          .get();
      results.addAll(jobsSnapshot.docs);

      searchResults.assignAll(results);
    } catch (e) {
      print('Error performing search: $e');
    }
  }
}
