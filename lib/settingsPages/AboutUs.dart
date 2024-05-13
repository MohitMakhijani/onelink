import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onelink/Theme.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  AppTheme.light?Colors.white:Colors.black,
      appBar: AppBar(
        foregroundColor: !AppTheme.light?Colors.white:Colors.black,
        backgroundColor: AppTheme.light?Colors.white:Colors.black,
      ),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('StartupOdero',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: !AppTheme.light?Colors.white:Colors.black
          ),
          ),
          Text('Version 2.24',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade500
          ),
          ),
        
          Image.asset('Assets/images/loginabout.png'),
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ 
              SvgPicture.asset('Assets/images/cicon.svg'),
              SizedBox(
                width: 5.w,
              ),
              Text('2023-2024 StartupOdero',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600
          ),
          ),

            ],
          ),
          SizedBox(
            height: 30.h,
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 169, 1, 1),
              borderRadius: BorderRadius.circular(30)
            ),
            child: TextButton(onPressed: () { 

              print("Licences");
             },
            child:Padding(
              padding:  EdgeInsets.symmetric(vertical: 1.h,horizontal: 30.w),
              child: Text("Licences",
              style: TextStyle(
                color: AppTheme.light?Colors.white:Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500
              ),
              ),
            ) ,),
          )
        ],
      )),
    );
  }
}