import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onelink/Models/Job%20Detail%20model.dart';
import 'package:onelink/components/myButton.dart';
import 'package:onelink/constants/constants.dart';

import 'apply_JOb.dart';

class JobDetailScreen extends StatelessWidget {
  final String jobId;

  JobDetailScreen({required this.jobId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Job Details',style:kAppBarFont),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('jobs')
            .where('JobId', isEqualTo: jobId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Job not found'));
          }

          // Retrieve job data from snapshot
          Map<String, dynamic> jobData =
              snapshot.data!.docs.first.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                JobDetailModel(
                  jobTitle: jobData['jobTitle'] ?? '',
                  description: jobData['description'] ?? '',
                  location: jobData['location'] ?? '',
                  salary: jobData['salary'] ?? '',
                  experience: jobData['experience'] ?? '',
                  companyName: jobData['companyName'] ?? '',
                  jobPosted: jobData['jobPosted'] ?? '',
                  skillRequired: jobData['skillsRequired'] ?? '',
                  aboutJob: jobData['aboutJob'] ?? '',
                  aboutCompany: jobData['aboutCompany'] ?? '',
                  whoCanApply: jobData['eligibility'] ?? '',
                  JobID: jobId,
                  numberOfOpenings: jobData['openings'] ?? 0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyButton(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ApplyJobPage(jobId: jobId,);
                          },
                        ));
                      },
                      text: "Apply Now",
                      color: Colors.blue),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
