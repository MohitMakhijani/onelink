import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onelink/Theme.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
final _controller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: !AppTheme.light?Colors.white:Colors.black,
        backgroundColor: AppTheme.light?Colors.white:Colors.black,
        title: Center(
          child: Text('Support',
           style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'InterRegular',
                    fontWeight: FontWeight.w700,
                    color: !AppTheme.light?Colors.white:Colors.black,
                    
                  ),
          ),
        ),
      ),
      backgroundColor: AppTheme.light?Colors.white:Colors.black,
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 18.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.r)
                
                  ),
                  child: TextField(
                    controller:_controller ,
                    //maxLength: 20,
                    maxLines: 5,
                    //expands: true,
                    decoration: InputDecoration(
                      hintText: '  Tell us how we can help you'
                      
                    ),
                  ),
                ),
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
            Padding(
              padding:  EdgeInsets.only(bottom: 50.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [ 
                  Text(
                    "We will respond to you in a StartupOdero chat",
                    style: TextStyle(
                      fontFamily: 'InterRegular',
                      fontSize: 12,
                      color: !AppTheme.light?Colors.white:Colors.black,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      print("Submit");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: 
                         Padding(
                           padding:  EdgeInsets.symmetric(horizontal: 7.w,vertical: 3.h),
                           child: Text("Submit",
                                                 
                           style: TextStyle(
                                                 fontFamily: 'InterRegular',
                                                 fontSize: 12,
                                                 color: AppTheme.light?Colors.white:Colors.black,
                                                 fontWeight: FontWeight.w400
                                             
                                                 ),),
                         ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}