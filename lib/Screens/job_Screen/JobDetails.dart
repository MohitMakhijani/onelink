import 'package:firebase_auth/firebase_auth.dart';
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
    final currentUserPhone = FirebaseAuth.instance.currentUser!.phoneNumber;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF888BF4),
        title: Text('Job Details', style: kAppBarFont),
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

          // Check if jobId is present in the jobs collection
          bool jobExists = snapshot.data!.docs.isNotEmpty;

          // Retrieve job data from snapshot
          Map<String, dynamic> jobData =
          snapshot.data!.docs.first.data() as Map<String, dynamic>;

          final jobUserId = jobData['UserId'];
          final appliedCandidates = jobData['appliedCandidates'];

          bool isJobCreatedByUser = jobUserId == currentUserPhone;
          bool hasUserApplied = appliedCandidates != null &&
              appliedCandidates.any((candidate) =>
              candidate['UserId'] == currentUserPhone);

          // Get the document ID of the job
          String jobDocumentId = snapshot.data!.docs.first.id;

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
                if (jobExists && !isJobCreatedByUser && !hasUserApplied)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ApplyJobPage(jobId: jobId);
                            },
                          ),
                        );
                      },
                      text: "Apply Now",
                      color: Colors.blue,
                    ),
                  ),
                if (jobExists && isJobCreatedByUser)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyButton(
                      onTap: () async {
                        bool confirmDelete = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirm Delete'),
                              content: Text('Are you sure you want to delete this job?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmDelete != null && confirmDelete) {
                          await FirebaseFirestore.instance
                              .collection('jobs')
                              .doc(jobDocumentId) // Use jobDocumentId to target the specific job document
                              .delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Job deleted')),
                          );
                          Navigator.pop(context); // Pop back to previous screen after deletion
                        }
                      },
                      text: 'Delete Job',
                      color: Colors.red,
                    ),
                  ),
                if (jobExists && hasUserApplied)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MyButton(
                      onTap: () async {
                        try {
                          // Find the index of the user's application in the appliedCandidates array
                          int userIndex = appliedCandidates.indexWhere(
                                  (candidate) =>
                              candidate['UserId'] == currentUserPhone);

                          // Remove the user's application from the appliedCandidates array
                          if (userIndex != -1) {
                            appliedCandidates.removeAt(userIndex);

                            await FirebaseFirestore.instance
                                .collection('jobs')
                                .doc(jobDocumentId)
                                .update({'appliedCandidates': appliedCandidates});

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('You left the job')),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to leave the job: $e'),
                            ),
                          );
                        }
                      },
                      text: "Leave Job",
                   color: Colors.red,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
