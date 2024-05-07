import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

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
      appBar: AppBar(
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
                        ),
                      ),
                      Text(
                        email,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(),
            SettingsItem(title: 'Account',),
            SettingsItem(title: 'Security'),
            SettingsItem(title: 'Messaging'),
            SettingsItem(title: 'Privacy'),
            SettingsItem(title: 'Notifications'),
            SettingsItem(title: 'Language'),
            Divider(),
            SettingsItem(title: 'About Us'),
            SettingsItem(title: 'Privacy Policy'),
            SettingsItem(title: 'Support'),
            Divider(),
            SettingsItem(title: 'Language'),
            SettingsItem(title: 'Dark Mode'),
            SizedBox(height: 15.h),
          ],
        ),
      ),
    );
  }
}
