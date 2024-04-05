import 'package:flutter/material.dart';
import 'package:flutter_faq/flutter_faq.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/constants.dart';


class FAQ_Page extends StatefulWidget {
  const FAQ_Page({super.key});

  @override
  State<FAQ_Page> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FAQ_Page> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "FAQ's",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              FAQ(queStyle: kListHeadText,
                question: "Question 1",
                answer: data,
                ansDecoration: BoxDecoration(
                  color: kbgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                queDecoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              SizedBox(height: 20),
              FAQ(
                queStyle: kListHeadText,
                question: "Question 2",
                answer: data,
                ansDecoration: BoxDecoration(
                  color: kbgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                queDecoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              SizedBox(height: 20),
              FAQ(
                queStyle: kListHeadText,
                question: "Question 3",
                answer: data,
                ansDecoration: BoxDecoration(
                  color: kbgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                queDecoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String data = """"
 Lorem Ipsum.
""";
