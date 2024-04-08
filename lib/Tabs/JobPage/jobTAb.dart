import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onelink/Models/JobPostModel.dart';
import 'package:onelink/Screens/job_Screen/CreateJob.dart';
import 'package:onelink/Screens/job_Screen/appliedJob.dart';
import 'package:onelink/Screens/job_Screen/postedjob.dart';
import '../../Widgets/Expandable_fab.dart';
import '../../Widgets/actionButton.dart';
import '../../Widgets/searchbar.dart';
import '../../components/myButton.dart';

class JobTab extends StatelessWidget {
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
                    JobPostingPage(),
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
                    AppliedJobsPage(),
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
                    PostedJobsPage(),
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
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          children: [

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

    if (jobData['jobStatus'] == 'Accepted') {
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
          JobStatus: jobData['jobStatus'],
        ),
      );
    }
    else{
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
