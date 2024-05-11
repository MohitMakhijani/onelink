import 'package:flutter/material.dart';

class AppColor{
 


    AppColorMethod(String presentColor) {
    // Initialize themeColor based on the presentColor
    if (presentColor == 'light') {
    Color  themeColor = Colors.white; // Assuming white is the theme color for 'light'
    } else {
    Color  themeColor = Colors.black; // Assuming black is the theme color for 'dark'
    }
  }
}