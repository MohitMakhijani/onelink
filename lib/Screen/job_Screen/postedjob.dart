import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onelink/Theme.dart';

import 'JobDetails.dart';

class PostedJobsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Posted Jobs',
          style: GoogleFonts.inter(
              color: AppTheme.light ? Colors.black : Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: AppTheme.light ? Colors.white : Colors.black,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .where('UserId',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString())
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
              child: Text(
                'No jobs posted yet.',
                style: TextStyle(
                    color: !AppTheme.light ? Colors.white : Colors.black),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var jobData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return Column(
                children: [
                  SizedBox(height: 10,),
                  Container(
                    child: Text(
                      "Job Status-${jobData['jobStatus']}",
                      style: GoogleFonts.inter(color: AppTheme.light?Colors.black:Colors.white,
                          fontSize: MediaQuery.of(context).size.width * 0.040),
                    ),

                  ),
                  ListTile(
                    title: Text(
                      jobData['jobTitle'] ?? "",
                      style: TextStyle(
                          color: AppTheme.light ? Colors.black : Colors.white),
                    ),
                    subtitle: Text(
                      jobData['description'],
                      style: TextStyle(
                          color: AppTheme.light ? Colors.black : Colors.white),
                    ),
                    onTap: () {
                      // Navigate to job details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobDetailScreen(
                            jobId: jobData['JobId'],
                          ),
                        ),
                      );
                    },
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
