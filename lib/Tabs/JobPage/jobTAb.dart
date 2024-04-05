import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onelink/Models/JobPostModel.dart';
import 'package:onelink/Screens/job_Screen/CreateJob.dart';
import 'package:onelink/Screens/job_Screen/postedjob.dart';
import '../../Widgets/searchbar.dart';
import '../../components/myButton.dart';

class JobTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     SizedBox(
            //       height: 15,
            //     ),
            //     MyButton1(
            //         onTap: () {
            //           Navigator.push(context, MaterialPageRoute(
            //             builder: (context) {
            //               return JobPostingPage();
            //             },
            //           ));
            //         },
            //         text: "Post a Job",
            //         color: Colors.blue),
            //     MyButton1(
            //         onTap: () {
            //           String? phone =
            //               FirebaseAuth.instance.currentUser!.phoneNumber;
            //           Navigator.push(context, MaterialPageRoute(
            //             builder: (context) {
            //               return PostedJobsPage(UserPhone: "${phone}");
            //             },
            //           ));
            //         },
            //         text: "My Jobs",
            //         color: Colors.blue),
            //   ],
            // ),
            Divider(),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('jobs').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final jobDocs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: jobDocs.length,
                    itemBuilder: (context, index) {
                      final jobData =
                          jobDocs[index].data() as Map<String, dynamic>;
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: JobUICard(
                          jobTitle: jobData['jobTitle'],
                          description: jobData['description'],
                          location: jobData['location'],
                          salary: jobData['salary'],
                          experience: jobData['experience'],
                          companyName: jobData['companyName'],
                          jobPosted: jobData['jobPosted'],
                          skillRequired: jobData['skillsRequired'],
                          aboutJob: jobData['aboutJob'],
                          aboutCompany: jobData['aboutCompany'],
                          whoCanApply: jobData['eligibility'],
                          numberOfOpenings: jobData['openings'],
                          JobID: jobData['JobId'],
                          JobStatus: jobData['JobStatus'],
                        ),
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
