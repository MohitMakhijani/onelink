import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/constants.dart';
import 'AccountSettingPage.dart';
import 'NotificationSetting.dart';
import 'PrivatePolicy.dart'; // Import the notification settings page

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor:  Color(0xFF888BF4),
        title: Text(
          'App Settings',
          style: kAppBarFont,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsListTile(
              title: 'Notification Settings',
              subtitle: 'Configure notification preferences',
              onTap: () {
                // Navigate to the notification settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationSettingsPage(),
                  ),
                );
              },
            ),
            Divider(),
            SettingsListTile(
              title: 'Theme',
              subtitle: 'Manage your Themes',
              onTap: () {
                // Navigate to the account settings page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AccountSettingsPage(),
                  ),
                );
              },
            ),
            Divider(),
            SettingsListTile(
              title: 'Privacy Settings',
              subtitle: 'Adjust privacy preferences',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivacySettingsPage(),
                  ),
                );
              },
            ),
            Divider(),
            // Add more settings as needed
          ],
        ),
      ),
    );
  }
}
class SettingsListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const SettingsListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
           borderRadius: BorderRadius.circular(12)),
      child: ListTile(
/*
        tileColor: kprimaryColor,
*/
        title: Text(
          title,
          style: GoogleFonts.poppins(),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(),
        ),
        onTap: onTap,
      ),
    );
  }
}