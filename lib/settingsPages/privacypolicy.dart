import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onelink/Theme.dart';

class privacyPolicy extends StatefulWidget {
  const privacyPolicy({super.key});

  @override
  State<privacyPolicy> createState() => _privacyPolicyState();
}

class _privacyPolicyState extends State<privacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.topLeft,
          colors: [
           AppTheme.light? Colors.white:Colors.black,
            const Color.fromARGB(255, 236, 189, 187),
            
          ],
        ),
      ),
      child: Scaffold(
      backgroundColor: Colors.transparent,
        appBar: AppBar(
          foregroundColor: !AppTheme.light?Colors.white:Colors.black,
          backgroundColor: AppTheme.light?Colors.white:Colors.black,
          title: Center(
            child: Text(
              "Privacy Policy",
              style: TextStyle(
                color:!AppTheme.light?Colors.white:Colors.black,
                fontSize: 16.sp
              ),
            ),
            
          ),
          actions: [
            Icon(Icons.refresh),
            SizedBox(
              width: 10.w,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ 
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset('Assets/images/horizontallogo.svg'),
                    Row(
                      children: [
                        IconButton(onPressed: 
                        (){
                          print("Search");
                        }
                        , icon: Icon(Icons.search,
                        color: !AppTheme.light?Colors.white:Colors.black,
                        )),
                        IconButton(onPressed: 
                        (){
                          print("Search");
                        }
                        , icon: Icon(Icons.menu,
                        color: !AppTheme.light?Colors.white:Colors.black,
                        ))
                      ],
                    ),
            
            
                  ],
                ),
                Text("Privacy Policy",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'InterRegular',
                  fontWeight: FontWeight.w700,
                  color: !AppTheme.light?Colors.white:Colors.black,

                ),),
                 Text("What is Privacy Policy and what\ndoes it cover?",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'InterRegular',
                  fontWeight: FontWeight.w700,
                  color: !AppTheme.light?Colors.white:Colors.black,
                  
                ),),
                 Text("Last updated on March 13, 2024",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'InterRegular',
                  fontWeight: FontWeight.w300,
                  color: !AppTheme.light?Colors.white:Colors.black,

                ),),
                SizedBox(
                  height: 20.h,
                ),
              PolicyAttributeMethod("About Lorem Ipsium"),
              Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.” The purpose of lorem ipsum is to create a natural looking block of text (sentence, paragraph, page, etc.) that doesn't distract from the layout.",
               style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'InterRegular',
                  fontWeight: FontWeight.w300,
                  color: !AppTheme.light?Colors.white:Colors.black,
                ),
                
              ),
              SizedBox(
                height: 20.h,
              ),
              PolicyAttributeMethod('About Lorem Lorem'),
              Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.” The purpose of lorem ipsum is to create a natural looking block of text (sentence, paragraph, page, etc.) that doesn't distract from the layout.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.” The purpose of lorem ipsum is to create a natural looking block of text (sentence, paragraph, page, etc.) that doesn't distract from the layout.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.” The purpose of lorem ipsum is to create a natural looking block of text (sentence, paragraph, page, etc.) that doesn't distract from the layout.",
               style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'InterRegular',
                  fontWeight: FontWeight.w300,
                  color: !AppTheme.light?Colors.white:Colors.black,
                ),
                
              ),
              SizedBox(
                height: 10.h,
              ),
              SvgPicture.asset('Assets/images/policyPhoto.svg'),
              Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.” The purpose of lorem ipsum is to create a natural looking block of text (sentence, paragraph, page, etc.) that doesn't distract from the layout.",
               style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'InterRegular',
                  fontWeight: FontWeight.w300,
                  color: !AppTheme.light?Colors.white:Colors.black,
                ),
                
              ),
              ],
            ),
          ),
        ),
      ),

    
    );
  }

  Widget PolicyAttributeMethod(String text) {
    return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.light?Colors.white:Colors.black,
                borderRadius: BorderRadiusDirectional.circular(10)
              ),
              child: Padding(
                padding:  EdgeInsets.symmetric(vertical: 15.h,horizontal: 20.w),
                child: Text(
                  text,
                  style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'InterRegular',
                  fontWeight: FontWeight.w700,
                  color: !AppTheme.light?Colors.white:Colors.black
                ),
                ),
              ),
            );
  }
}