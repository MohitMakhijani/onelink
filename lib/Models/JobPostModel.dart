import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onelink/Screens/job_Screen/JobDetails.dart';
import 'package:onelink/components/myButton.dart';

class JobUICard extends StatefulWidget {
  final String jobTitle;
  final String description;
  final String location;
  final String salary;
  final String experience;
  final String companyName;
  final String jobPosted;
  final String skillRequired;
  final String aboutJob;
  final String aboutCompany;
  final String JobStatus;
  final String whoCanApply;
  final String JobID;
  final int numberOfOpenings;

  JobUICard({
    required this.JobStatus,
    required this.jobTitle,
    required this.description,
    required this.location,
    required this.salary,
    required this.experience,
    required this.companyName,
    required this.jobPosted,
    required this.skillRequired,
    required this.aboutJob,
    required this.aboutCompany,
    required this.whoCanApply,
    required this.numberOfOpenings,
    required this.JobID,
  });

  @override
  _JobTabState createState() => _JobTabState();
}

class _JobTabState extends State<JobUICard> {
  @override
  Widget build(BuildContext context) {
    // Check if the JobStatus is 'Accepted'
    if (widget.JobStatus == 'Accepted') {
      return Card(
        elevation: 4.0,
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.jobTitle,
                style: GoogleFonts.poppins(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                widget.description,
                style: GoogleFonts.acme(
                  fontSize: 16.0,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 12.0),
              Row(
                children: <Widget>[
                  Icon(Icons.location_on, color: Colors.blue),
                  SizedBox(width: 4.0),
                  Text(
                    widget.location,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: <Widget>[
                  FaIcon(FontAwesomeIcons.indianRupeeSign,color: Colors.green,size: 22,),
                  SizedBox(width: 4.0),
                  Text(
                    widget.salary,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: <Widget>[
                  Icon(Icons.timer, color: Colors.orange),
                  SizedBox(width: 4.0),
                  Text(
                    widget.experience,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(FontAwesomeIcons.building, color: Colors.purple),
                  SizedBox(width: 4.0),
                  Text(
                    widget.companyName,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: MyButton1(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return JobDetailScreen(jobId: widget.JobID);
                        }));
                      },
                      text: "View Details",
                      color:Color(0xFF888BF4),
                    ),
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Posted ${widget.jobPosted} ago',
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      // If JobStatus is not 'Accepted', return an empty container
      return Container(
        child: Center(child: Text("NO JOBS FOUND")),
      );
    }
  }
}
