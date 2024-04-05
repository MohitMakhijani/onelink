import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onelink/components/MyToast.dart';
import 'package:onelink/components/myButton.dart';
import 'package:onelink/constants/constants.dart';

import '../profile/SetUpProfile/setupProfilePage.dart';

class ChipChoicePage extends StatefulWidget {
  @override
  _ChipChoicePageState createState() => _ChipChoicePageState();
}

class _ChipChoicePageState extends State<ChipChoicePage> {
  String selectedCategory = ''; // State to track the selected category

  List<String> categories = [
    'Student',
    'Teacher',
    'Investor',
    'Founder',
    'Developer',
    'Influencer',
    'Mentors'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose a Category',
          style: kAppBarFont,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Wrap(
                  spacing: 16.0,
                  runSpacing: 12.0,
                  children: List.generate(categories.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: ChoiceChip(
                        shadowColor: Colors.grey[300],
                        elevation: 3,
                        labelStyle: GoogleFonts.poppins(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                        label: Text(categories[index]),
                        selected: selectedCategory == categories[index],
                        selectedColor:
                            Colors.blue, // Change color when selected
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedCategory = categories[index];
                            } else {
                              selectedCategory = '';
                            }
                          });
                        },
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: MyButton(
              onTap: () {
                if (selectedCategory.isNotEmpty) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(
                          milliseconds: 500), // Adjust duration as needed
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          SetUpProfile(),
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
                } else {
                  ToastUtil.showToastMessage("Please Select a Category");
                }
              },
              text: "Continue",
              color: Colors.blue,
            ),
          )
        ],
      ),
    );
  }
}
