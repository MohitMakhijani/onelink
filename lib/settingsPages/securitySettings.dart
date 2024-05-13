import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onelink/Theme.dart';
import 'package:onelink/settingsPages/Attributemethod.dart';
import 'package:onelink/settingsPages/MessagingSettings.dart';

class securitySettingsPage extends StatefulWidget {
  const securitySettingsPage({super.key});

  @override
  State<securitySettingsPage> createState() => _securitySettingsPageState();
}

class _securitySettingsPageState extends State<securitySettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.light?Colors.white:Colors.black,
      appBar: 

      AppBar(
        foregroundColor: !AppTheme.light?Colors.white:Colors.black,
        backgroundColor: AppTheme.light?Colors.white:Colors.black,
        title: Center(
          child: Text("Security Settings",
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: 'InterRegular',
            fontWeight: FontWeight.w500,
            color: !AppTheme.light?Colors.white:Colors.black
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
         "Password",AppTheme.light),
          SettingsMethod('Assets/images/apps.svg',
         "Apps and sessions",AppTheme.light),
          SettingsMethod('Assets/images/connected.svg',
         "connected accounts",AppTheme.light),
          SettingsMethod('Assets/images/delegate.svg',
         "Delegate",AppTheme.light),
         
         
        ],
      ),
    );
  }

}