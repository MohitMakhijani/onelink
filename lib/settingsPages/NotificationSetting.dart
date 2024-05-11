import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:onelink/settingsPages/Attributemethod.dart';
import 'package:flutter_switch/flutter_switch.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({super.key});

  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> {
  bool vibrate = false;
  bool popup = true;
  bool light = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Notification Settings",
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
           SettingsMethod('Assets/images/musicnote.svg',
         "Notification tone"),
          //SettingsMethod('Assets/images/lastseen.svg', "Last seen & online"),
         // DividerMethod(),
        SwitchButtonMethodWithOutSubtitlewithImg(
          'Vibration','vibrate','Assets/images/ph_vibrate.svg'),
           SwitchButtonMethodWithOutSubtitlewithImg(
          'Popup notification','popup','Assets/images/carbon_popup.svg'),
           SwitchButtonMethodWithOutSubtitlewithImg(
          'Light','light','Assets/images/lamp-on.svg'),
         
          

          
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
            value: (toe == 'vibrate')
                ? vibrate
                : (toe == 'popup')
                    ? popup
                    : light,
            //borderRadius: 30.0,
            //padding: 8.0,
            showOnOff: false,
            onToggle: (val) {
              setState(() {
                (toe == 'vibrate')
                    ? (vibrate = val)
                    : (toe == 'popup')
                        ? popup = val
                        : light = val;
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
            value: (toe == 'vibrate')
                ? vibrate
                : (toe == 'popup')
                    ? popup
                    : light,
            //borderRadius: 30.0,
            //padding: 8.0,
            showOnOff: false,
            onToggle: (val) {
              setState(() {
                (toe == 'vibrate')
                    ? (vibrate = val)
                    : (toe == 'popup')
                        ? popup = val
                        : light = val;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget SwitchButtonMethodWithOutSubtitlewithImg(String title, String toe,String Img) {
    return Padding(
      padding: EdgeInsets.only(left: 18.w, right: 18.w, top: 12.h,bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(Img),
              SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
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
            value: (toe == 'vibrate')
                ? vibrate
                : (toe == 'popup')
                    ? popup
                    : light,
            //borderRadius: 30.0,
            //padding: 8.0,
            showOnOff: false,
            onToggle: (val) {
              setState(() {
                (toe == 'vibrate')
                    ? (vibrate = val)
                    : (toe == 'popup')
                        ? popup = val
                        : light = val;
              });
            },
          ),
        ],
      ),
    );
  }

}
