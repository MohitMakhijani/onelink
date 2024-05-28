import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:onelink/components/MyToast.dart';

import '../../Services/FireStoreMethod.dart';
import '../../Theme.dart';
import '../../Widgets/callPage.dart';
import 'ChatMediaPage.dart';
import 'check_block_Controller.dart';

class ChatSettingsPage extends StatefulWidget {
  final String UserName;
  final String ProfilePicture;
  final String chatroomId;
  final String UId;
  const ChatSettingsPage(
      {super.key,
      required this.UserName,
      required this.ProfilePicture,
      required this.UId,
      required this.chatroomId});

  @override
  State<ChatSettingsPage> createState() => _ChatSettingsPageState();
}

class _ChatSettingsPageState extends State<ChatSettingsPage> {
  @override
  void initState() {
    // TODO: implement initState
    final CheckBlockController _checkBlockController =
        Get.put(CheckBlockController());
    _checkBlockController.checkBlockUser(widget.UId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CheckBlockController _checkBlockController =
        Get.put(CheckBlockController());
    return Scaffold(
      backgroundColor: !AppTheme.light ? Colors.black : Colors.white,
      appBar: AppBar(
        foregroundColor: AppTheme.light ? Colors.black : Colors.white,
        backgroundColor: !AppTheme.light ? Colors.black : Colors.white,
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 230.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(widget.ProfilePicture),
                    radius: 45.r,
                  ),
                ),
                Center(
                  child: Text(
                    widget.UserName,
                    style: GoogleFonts.inter(
                        color: AppTheme.light ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 24.sp),
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
                              radius: 20.r,
                              child: IconButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => CallPage(
                                    //         callID:widget.chatroomId,
                                    //         userid: widget.UId,
                                    //         userName: widget.UserName, isVideo: false,
                                    //       ),
                                    //     ));
                                  },
                                  icon: FaIcon(
                                    Icons.call,
                                    color: Colors.white,
                                    size: 25,
                                  ))),
                          Text(
                            'Audio',
                            style: TextStyle(color: Colors.grey[400]),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                              backgroundColor: Colors.grey[400],
                              radius: 20.r,
                              child: IconButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => CallPage(
                                    //         callID:widget.chatroomId,
                                    //         userid: FirebaseAuth
                                    //             .instance.currentUser!.uid,
                                    //         userName: widget.UserName, isVideo: true,
                                    //       ),
                                    //     ));
                                  },
                                  icon: FaIcon(
                                    Icons.videocam,
                                    color: Colors.white,
                                    size: 25,
                                  ))),
                          Text(
                            'Video',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          CircleAvatar(
                              backgroundColor: Colors.grey[400],
                              radius: 20.r,
                              child: IconButton(
                                  onPressed: () {},
                                  icon: FaIcon(
                                    FontAwesomeIcons.bell,
                                    color: Colors.white,
                                    size: 25,
                                  ))),
                          Text(
                            'Audio',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Media',
                  style: GoogleFonts.inter(
                      color: AppTheme.light ? Colors.black : Colors.white,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ChatMediaPage(
                                chatRoomId: widget.chatroomId,
                              );
                            },
                          ));
                        },
                        icon: FaIcon(Iconsax.gallery_add_bold),
                      )),
                )
              ],
            ),
          ),
          Text("Privacy",
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                  color: Colors.grey[500])),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => _checkBlockController.isBlocked.value
                      ? Text(
                          'Unblock',
                          style: GoogleFonts.inter(
                              color:
                                  AppTheme.light ? Colors.black : Colors.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500),
                        )
                      : Text(
                          'Block',
                          style: GoogleFonts.inter(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color:
                                  AppTheme.light ? Colors.black : Colors.white),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: Obx(
                        () => IconButton(
                          onPressed: () async {
                            var currentUserUid =
                                FirebaseAuth.instance.currentUser!.uid;
                            var userDoc = FirebaseFirestore.instance
                                .collection('users')
                                .doc(currentUserUid);
                            var userInfo = await userDoc.get();

                            // Check if the user's UID is not in the "block" array
                            List<dynamic> blockedUsers = userInfo[
                                    'blockUsers'] ??
                                []; // If 'block' doesn't exist yet, default to an empty list
                            if (!blockedUsers.contains(widget.UId)) {
                              // User is not already blocked, proceed with blocking
                              await FireStoreMethods().blockUser(widget.UId);
                              ToastUtil.showToastMessage(
                                  'User Blocked Successfully');
                            } else {
                              // User is already blocked, proceed with unblocking
                              await FireStoreMethods().unblockUser(widget.UId);
                              ToastUtil.showToastMessage(
                                  'User Unblocked Successfully');
                              print('User is already blocked.');
                              // Optionally, you can show a message to the user indicating that the user is already blocked.
                            }
                          },
                          icon: _checkBlockController.isBlocked.value
                              ? FaIcon(
                                  Icons.block,
                                  color: Colors.black,
                                )
                              : FaIcon(
                                  Icons.block,
                                  color: Colors.red,
                                ),
                        ),
                      )),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifications',
                  style: GoogleFonts.inter(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.light ? Colors.black : Colors.white),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: IconButton(
                        onPressed: () {},
                        icon: FaIcon(
                          AntDesign.notification_fill,
                          color: Colors.red,
                        ),
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
