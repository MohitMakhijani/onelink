import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:onelink/settingsPages/Attributemethod.dart';
import 'package:flutter_switch/flutter_switch.dart';

class privacySettings extends StatefulWidget {
  const privacySettings({super.key});

  @override
  State<privacySettings> createState() => _privacySettingsState();
}

class _privacySettingsState extends State<privacySettings> {
  bool receipts = false;
  bool live = true;
  bool archived = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Privacy Settings",
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
          SettingsMethod('Assets/images/lastseen.svg', "Last seen & online"),
          DividerMethod(),
        
          SwitchButtonMethodWithOutSubtitle(
              'Read receipts', 'receipts'),
          SwitchButtonMethodWithOutSubtitle('Hide history and live',
              'live'),
          generalMethod('Who can follow me', 'For shared accounts'),
          DividerMethod(),
         
          SettingsMethodWithSubtitle('Assets/images/block.svg', "Blocked","Two accounts"),
          
          
          SettingsMethodWithSubtitle('Assets/images/message-2.svg', "Messages and story replies","Only people you follow"),
           SettingsMethodWithSubtitle('Assets/images/message-2.svg', "Comments",
           "Everyone"),

          

          
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
            value: (toe == 'receipts')
                ? receipts
                : (toe == 'live')
                    ? live
                    : archived,
            //borderRadius: 30.0,
            //padding: 8.0,
            showOnOff: false,
            onToggle: (val) {
              setState(() {
                (toe == 'receipts')
                    ? (receipts = val)
                    : (toe == 'live')
                        ? live = val
                        : archived = val;
              });
            },
          ),
        ],
      ),
    );
  }
  
  Widget SwitchButtonMethodWithOutSubtitle(String title, String toe) {
    return Padding(
      padding: EdgeInsets.only(left: 50.w, right: 18.w, top: 12.h,bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: 'InterRegular',
            ),
          ),
          FlutterSwitch(
            activeColor: Colors.red,
            inactiveColor: Colors.grey,
            width: 50.0,
            height: 20.0,
            toggleSize: 30.0,
            toggleColor: Colors.white,
            value: (toe == 'receipts')
                ? receipts
                : (toe == 'live')
                    ? live
                    : archived,
            //borderRadius: 30.0,
            //padding: 8.0,
            showOnOff: false,
            onToggle: (val) {
              setState(() {
                (toe == 'receipts')
                    ? (receipts = val)
                    : (toe == 'live')
                        ? live = val
                        : archived = val;
              });
            },
          ),
        ],
      ),
    );
  }

}
