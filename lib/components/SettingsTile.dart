import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onelink/Theme.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final String imgpath;

  const SettingsItem({
    Key? key,
    required this.title,
    this.onTap,
    required this.imgpath
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(imgpath,
                  color: !AppTheme.light?Colors.white:Colors.black,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                      color: !AppTheme.light?Colors.white:Colors.black
                    ),
                  ),
                ],
              ),
              Icon(Icons.keyboard_arrow_right,
              color: !AppTheme.light?Colors.white:Colors.black,)
            ],
          ),
          SizedBox(height: 15.h),
        ],
      ),
    );
  }
}
