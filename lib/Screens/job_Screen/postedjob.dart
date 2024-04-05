import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onelink/Screens/job_Screen/JobDetails.dart';

class PostedJobsPage extends StatelessWidget {
  final String UserPhone;

  PostedJobsPage({ required this.UserPhone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posted Jobs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .where('phoneNumber', isEqualTo: UserPhone.toString())
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No jobs posted yet.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var jobData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(jobData['jobTitle']),
                subtitle: Text(jobData['description']),
                onTap: () {
                  // Navigate to job details page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailScreen(jobId: jobData['JobId'],),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
