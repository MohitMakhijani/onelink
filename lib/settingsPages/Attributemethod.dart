
// ignore_for_file: deprecated_member_use

  import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onelink/settingsPages/MessagingSettings.dart';

Widget SettingsMethod(String imgpath, String text, bool light) {
    return Padding(
         padding:  EdgeInsets.symmetric(horizontal: 18.w,vertical: 8.h),
         child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Row(
            children: [
              SvgPicture.asset(imgpath,
              color: !light?Colors.white:Colors.black,),
              SizedBox(
                width: 10.w,
              ),
             (text=='Delegate' || text=='Who can message' || text=='Theme' ||
             text=='Last seen & online')? 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [ 
                   Text(text,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'InterRegular',
                color: light?Colors.black:Colors.white
              
              ),),
              Text((text=='Who can message')?'Everyone':
              (text=='Delegate')?'For shared accounts':
              (text=='Last seen & online')?'Everyone can see'  : 'Light',
              style: TextStyle(
                fontSize: 8.sp,
                fontFamily: 'InterRegular',
                color: light?Colors.black:Colors.white,
              
              ),),

                ],
              ):
             Text(text,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'InterRegular',
              color: light?Colors.black:Colors.white,
              ),),
             
            ],
          ),
          (text!='Theme' && text!='Wallpaper')?Icon(Icons.keyboard_arrow_right,
          color: light?Colors.black:Colors.white,
          ):SizedBox(),
          ],
         ),
       );
  }
  Widget SettingsMethodWithSubtitlewithArrow(String imgpath, String text,String subtitle, bool light) {
    return Padding(
         padding:  EdgeInsets.symmetric(horizontal: 18.w,vertical: 8.h),
         child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Row(
            children: [
              SvgPicture.asset(imgpath,
              color: !AppTheme.light?Colors.white:Colors.black,),
              SizedBox(
                width: 10.w,
              ),
             
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [ 
                   Text(text,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'InterRegular',
                color: !AppTheme.light?Colors.white:Colors.black,
              
              ),),
              Text(subtitle,
              style: TextStyle(
                fontSize: 8.sp,
                fontFamily: 'InterRegular',
              color: !AppTheme.light?Colors.white:Colors.black,
              ),),

                ],
              )
             
            ],
          ),
        // Icon(Icons.keyboard_arrow_right),
          ],
         ),
       );
  }
  Widget SettingsMethodWithSubtitle(String imgpath, String text,String subtitle, bool light) {
    return Padding(
         padding:  EdgeInsets.symmetric(horizontal: 18.w,vertical: 8.h),
         child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Row(
            children: [
              SvgPicture.asset(imgpath,
              color: !AppTheme.light?Colors.white:Colors.black,
              ),
              SizedBox(
                width: 10.w,
              ),
             
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [ 
                   Text(text,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'InterRegular',
                color: !AppTheme.light?Colors.white:Colors.black
              
              ),),
              Text(subtitle,
              style: TextStyle(
                fontSize: 8.sp,
                fontFamily: 'InterRegular',
                color: !AppTheme.light?Colors.white:Colors.black
              ),),

                ],
              )
             
            ],
          ),
          //(text!='Theme' && text!='Wallpaper')?Icon(Icons.keyboard_arrow_right):SizedBox(),
          ],
         ),
       );
  }
  Widget DividerMethod() {
    return Divider(
        height: 10,
        color: AppTheme.light? Color.fromARGB(255, 143, 149, 158):Colors.white,
        thickness: 0.7,
        indent : 15,
        endIndent : 15,       
     );
  }
  
  Widget generalMethod(String title, String subtitle, bool light) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 50.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: 'InterRegular',
               color: !light?Colors.white:Colors.black,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 8.sp,
              fontFamily: 'InterRegular',
               color: !light?Colors.white:Colors.black,
            ),
          ),
        ],
      ),
    );
  }

Widget SetMethod(String imgpath, String text, bool light) {
    return Padding(
         padding:  EdgeInsets.symmetric(horizontal: 18.w,vertical: 8.h),
         child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Row(
            children: [
              SvgPicture.asset(imgpath,
              color: !light?Colors.white:Colors.black,
              ),
              SizedBox(
                width: 10.w,
              ),
            
             Text(text,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'InterRegular',
                color: !light?Colors.white:Colors.black,
              
              ),),
             
            ],
          ),
          
          ],
         ),
       );
  }