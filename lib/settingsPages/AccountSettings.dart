import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onelink/settingsPages/Attributemethod.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
      AppBar(
        title: Center(
          child: Text("Account Settings",
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
         SettingsMethod('Assets/images/personaldetails.svg',
         "Personal details"),
          SettingsMethod('Assets/images/info.svg',
         "Info and permissions"),
          SettingsMethod('Assets/images/lock.svg',
         "Two-step verification"),
          SettingsMethod('Assets/images/request.svg',
         "Request account info"),
          SettingsMethod('Assets/images/ad.svg',
         "Ad preferences"),
         SettingsMethod('Assets/images/trash.svg',
         "Delete account"),
         
        ],
      ),
    );
  }

}