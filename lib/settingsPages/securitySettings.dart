import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onelink/settingsPages/Attributemethod.dart';

class securitySettingsPage extends StatefulWidget {
  const securitySettingsPage({super.key});

  @override
  State<securitySettingsPage> createState() => _securitySettingsPageState();
}

class _securitySettingsPageState extends State<securitySettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
      AppBar(
        title: Center(
          child: Text("Security Settings",
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: 'InterRegular',
            fontWeight: FontWeight.w500
          ),
          ),
        ),
      ),
      body: Column(
        children: [ 
            SizedBox(
              height: 40.h,
            ),
         SettingsMethod('Assets/images/security.svg',
         "Password"),
          SettingsMethod('Assets/images/apps.svg',
         "Apps and sessions"),
          SettingsMethod('Assets/images/connected.svg',
         "connected accounts"),
          SettingsMethod('Assets/images/delegate.svg',
         "Delegate"),
         
         
        ],
      ),
    );
  }

}