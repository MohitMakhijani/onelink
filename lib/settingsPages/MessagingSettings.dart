import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:onelink/settingsPages/Attributemethod.dart';
import 'package:flutter_switch/flutter_switch.dart';

class messageSettingPage extends StatefulWidget {
  const messageSettingPage({super.key});

  @override
  State<messageSettingPage> createState() => _messageSettingPageState();
}

class _messageSettingPageState extends State<messageSettingPage> {
  bool send = false;
  bool media = true;
  bool archived = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Messaging Settings",
            style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'InterRegular',
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40.h,
          ),
          SettingsMethod('Assets/images/messages.svg', "Who can message"),
          DividerMethod(),
          SwitchButtonMethod(
              'Enter is send', 'Enter key will send your message', 'send'),
          SwitchButtonMethod('Media downloads',
              'Download newly received media automatically', 'media'),
          generalMethod('Font size', 'Medium'),
          DividerMethod(),
          SwitchButtonMethod(
              'Archived chats',
              'Archived chats will remain archived when you\n receive a new message',
              'archived'),
          DividerMethod(),
          SetMethod('Assets/images/chatbackup.svg','Chat backup'),
          SetMethod('Assets/images/history.svg','Chat history'),
          DividerMethod(),
          SettingsMethod('Assets/images/sun.svg', "Theme"),
          SettingsMethod('Assets/images/gallery.svg', "Wallpaper"),
          

          

          
        ],
      ),
    );
  }
  


  Widget SwitchButtonMethod(String title, String subtitle, String toe) {
    return Padding(
      padding: EdgeInsets.only(left: 50.w, right: 18.w, top: 12.h,bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: 'InterRegular',
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 8.sp,
                  fontFamily: 'InterRegular',
                ),
              ),
            ],
          ),
          FlutterSwitch(
            activeColor: Colors.red,
            inactiveColor: Colors.grey,
            width: 50.0,
            height: 20.0,
            toggleSize: 30.0,
            toggleColor: Colors.white,
            value: (toe == 'send')
                ? send
                : (toe == 'media')
                    ? media
                    : archived,
            //borderRadius: 30.0,
            //padding: 8.0,
            showOnOff: false,
            onToggle: (val) {
              setState(() {
                (toe == 'send')
                    ? (send = val)
                    : (toe == 'media')
                        ? media = val
                        : archived = val;
              });
            },
          ),
        ],
      ),
    );
  }
}
