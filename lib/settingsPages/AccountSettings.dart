import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onelink/settingsPages/Attributemethod.dart';
import 'package:onelink/settingsPages/MessagingSettings.dart';

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
        backgroundColor: AppTheme.light?Colors.white:Colors.black ,
        title: Center(
          child: Text("Account Settings",
          style: TextStyle(
            fontSize: 16.sp,
            fontFamily: 'InterRegular',
            fontWeight: FontWeight.w500,
            color: !AppTheme.light?Colors.white:Colors.black,
          ),
          ),
        ),
      ),
      backgroundColor:  AppTheme.light?Colors.white:Colors.black,
      body: Column(
        children: [ 
            SizedBox(
              height: 40.h,
            ),
         SettingsMethod('Assets/images/personaldetails.svg',
         "Personal details",AppTheme.light),
          SettingsMethod('Assets/images/info.svg',
         "Info and permissions",AppTheme.light),
          SettingsMethod('Assets/images/lock.svg',
         "Two-step verification",AppTheme.light),
          SettingsMethod('Assets/images/request.svg',
         "Request account info",AppTheme.light),
          SettingsMethod('Assets/images/ad.svg',
         "Ad preferences",AppTheme.light),
         SettingsMethod('Assets/images/trash.svg',
         "Delete account",AppTheme.light),
         
        ],
      ),
    );
  }

}