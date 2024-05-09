
  import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

Widget SettingsMethod(String imgpath, String text) {
    return Padding(
         padding:  EdgeInsets.symmetric(horizontal: 18.w,vertical: 8.h),
         child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Row(
            children: [
              SvgPicture.asset(imgpath),
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
              
              ),),
              Text((text=='Who can message')?'Everyone':
              (text=='Delegate')?'For shared accounts':
              (text=='Last seen & online')?'Everyone can see'  : 'Light',
              style: TextStyle(
                fontSize: 8.sp,
                fontFamily: 'InterRegular',
              
              ),),

                ],
              ):
             Text(text,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'InterRegular',
              
              ),),
             
            ],
          ),
          (text!='Theme' && text!='Wallpaper')?Icon(Icons.keyboard_arrow_right):SizedBox(),
          ],
         ),
       );
  }
  
  Widget DividerMethod() {
    return Divider(
        height: 10,
        color: const Color.fromARGB(255, 143, 149, 158),
        thickness: 0.3,
        indent : 15,
        endIndent : 15,       
     );
  }
  
  Widget generalMethod(String title, String subtitle) {
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
    );
  }

Widget SetMethod(String imgpath, String text) {
    return Padding(
         padding:  EdgeInsets.symmetric(horizontal: 18.w,vertical: 8.h),
         child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Row(
            children: [
              SvgPicture.asset(imgpath),
              SizedBox(
                width: 10.w,
              ),
            
             Text(text,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'InterRegular',
              
              ),),
             
            ],
          ),
          
          ],
         ),
       );
  }