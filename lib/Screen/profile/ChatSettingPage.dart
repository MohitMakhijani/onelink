import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class ChatSettingsPage extends StatefulWidget {
  final String UserName;
  final String ProfilePicture;
  final String UId;
  const ChatSettingsPage({super.key, required this.UserName, required this.ProfilePicture, required this.UId});

  @override
  State<ChatSettingsPage> createState() => _ChatSettingsPageState();
}

class _ChatSettingsPageState extends State<ChatSettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 250.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(widget.ProfilePicture),

                    radius: 56.r,
                  ),
                ),
                Center(
                  child: Text(
                    widget.UserName,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700, fontSize: 24.sp),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 28.0, right: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                              backgroundColor: Colors.grey[400],
                              radius: 25.r,
                              child: IconButton(
                                  onPressed: () {},
                                  icon: FaIcon(
                                    Icons.call,
                                    color: Colors.white,
                                    size: 30,
                                  ))),
                          Text('Audio',style: TextStyle(color: Colors.grey[400]),)
                        ],
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                              backgroundColor: Colors.grey[400],
                              radius: 25.r,
                              child: IconButton(
                                  onPressed: () {},
                                  icon: FaIcon(
                                    Icons.videocam,
                                    color: Colors.white,
                                    size: 30,
                                  ))),
                          Text('Video',style: TextStyle(color: Colors.grey),)
                        ],
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                              backgroundColor: Colors.grey[400],
                              radius: 25.r,
                              child: IconButton(
                                  onPressed: () {},
                                  icon: FaIcon(
                                    FontAwesomeIcons.bell,
                                    color: Colors.white,
                                    size: 30,
                                  ))),      Text('Audio',style: TextStyle(color: Colors.grey),)
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Media',
                  style: GoogleFonts.inter(
                      fontSize: 17.sp, fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: IconButton(
                        onPressed: () {},
                        icon: FaIcon(Iconsax.gallery_add_bold),
                      )),
                )
              ],
            ),
          ),
             Padding(
            padding:  EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Search in Conversation',
                  style: GoogleFonts.inter(
                      fontSize: 17.sp, fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: IconButton(
                        onPressed: () {},
                        icon: FaIcon(Icons.search),
                      )),
                )
              ],
            ),
          ),
           Text("Privacy", style: GoogleFonts.inter(
               fontWeight: FontWeight.w700, fontSize: 14.sp,color: Colors.grey[500])),
           Padding(
            padding:  EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Block',
                  style: GoogleFonts.inter(
                      fontSize: 17.sp, fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: IconButton(
                        onPressed: () {},
                        icon: FaIcon(Icons.block,color: Colors.red,),
                      )),
                )
              ],
            ),
          ), Padding(
            padding:  EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: GoogleFonts.inter(
                      fontSize: 17.sp, fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: IconButton(
                        onPressed: () {},
                        icon: FaIcon(AntDesign.notification_fill,color: Colors.red,),
                      )),
                )
              ],
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
