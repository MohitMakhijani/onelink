import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onelink/Theme.dart';
import 'package:onelink/other/blockusers.dart';
import 'package:onelink/settingsPages/AboutUs.dart';
import 'package:onelink/settingsPages/AccountSettings.dart';
import 'package:onelink/settingsPages/MessagingSettings.dart';
import 'package:onelink/settingsPages/NotificationSetting.dart';
import 'package:onelink/settingsPages/Support.dart';
import 'package:onelink/settingsPages/privacySetting.dart';
import 'package:onelink/settingsPages/privacypolicy.dart';
import 'package:onelink/settingsPages/securitySettings.dart';

import '../../components/SettingsTile.dart';
class Settings1 extends StatelessWidget {
  final String image;
  final String email;
  final String name;

  const Settings1({
    Key? key,
    required this.image,
    required this.email,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppTheme.light?Colors.white:Colors.black,
      appBar: AppBar(
        foregroundColor: !AppTheme.light?Colors.white:Colors.black,
        backgroundColor: AppTheme.light?Colors.white:Colors.black,
        centerTitle: true,
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundImage: image.isNotEmpty
                        ? CachedNetworkImageProvider(image)
                        : AssetImage('Assets/images/Avatar.png') as ImageProvider<Object>,
                  ),
                  SizedBox(width: 15.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 22.sp,
                          color: !AppTheme.light?Colors.white:Colors.black
                        ),
                      ),
                      Text(
                        email,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: !AppTheme.light?Colors.white:Colors.black
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            SettingsItem(title: 'Account',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AccountSettingsPage(),));
            },imgpath: 'Assets/images/profile.svg',

            ),
            SettingsItem(title: 'Security',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => securitySettingsPage(),));
            },
            imgpath: 'Assets/images/key.svg',
            ),
            SettingsItem(title: 'Messaging', onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => messageSettingPage(),));
            },
            imgpath:'Assets/images/sms.svg',
            ),
            SettingsItem(title: 'Privacy',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BlockListScreen(),));
            },
            imgpath: 'Assets/images/security-safe.svg',
            ),
            SettingsItem(title: 'Notifications',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationSetting(),));
            },
            imgpath: 'Assets/images/notification-bing.svg',
            ),
            //SettingsItem(title: 'Language'),
            Divider(),
            SettingsItem(title: 'About Us',
            
            imgpath:'Assets/images/people.svg',
            onTap: () {
              
              Navigator.push(context,
               MaterialPageRoute(builder: (context)=>AboutUs()));
            },
            
            ),
            SettingsItem(title: 'Privacy Policy',
            imgpath: 'Assets/images/security-safe.svg',
             onTap: () {
              
              Navigator.push(context,
               MaterialPageRoute(builder: (context)=>privacyPolicy()));
            },
            ),
            SettingsItem(title: 'Support',
            imgpath: 'Assets/images/headphone.svg',
             onTap: () {
              
              Navigator.push(context,
               MaterialPageRoute(builder: (context)=>Support()));
            },
            ),
            
           
          ],
        ),
      ),
    );
  }
}
