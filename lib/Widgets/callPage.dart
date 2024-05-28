// import 'package:flutter/material.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
//
// class CallPage extends StatefulWidget {
//   const CallPage({
//     Key? key,
//     required this.callID,
//     required this.userid,
//     required this.userName,
//     required this.isVideo,
//   }) : super(key: key);
//
//   final String callID;
//   final String userid;
//   final bool isVideo;
//   final String userName;
//
//   @override
//   _CallPageState createState() => _CallPageState();
// }
//
// class _CallPageState extends State<CallPage> {
//   @override
//   void initState() {
//     super.initState();
//     initZego();
//   }
//
//   void initZego() async {
//     await ZegoUIKitPrebuiltCallInvitationService().init(
//       appID: 397177996,
//       appSign:
//       '19cc9c44747f36c647a2cbc24ad93bad791d249066ff4942b7500c656deeb5b3',
//       userID: widget.userid,
//       userName: widget.userName,
//       notificationConfig: ZegoCallInvitationNotificationConfig(
//         androidNotificationConfig: ZegoAndroidNotificationConfig(
//           channelID: "Ts Bridge Edu",
//           channelName: "Call Notifications",
//           sound: "notification",
//           icon: "notification_icon",
//         ),
//       ),
//       plugins: [ZegoUIKitSignalingPlugin()],
//       config: ZegoCallInvitationConfig(
//         permissions: [
//           ZegoCallInvitationPermission.microphone,
//           ZegoCallInvitationPermission.microphone,
//         ],
//       ),
//       requireConfig: (ZegoCallInvitationData data) {
//         final config = (data.invitees.length > 1)
//             ? (data.type == ZegoCallType.videoCall
//             ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
//             : ZegoUIKitPrebuiltCallConfig.groupVoiceCall())
//             : (data.type == ZegoCallType.videoCall
//             ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
//             : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall());
//
//         config.topMenuBarConfig.isVisible = true;
//         config.topMenuBarConfig.buttons
//             .insert(0, ZegoMenuBarButtonName.minimizingButton);
//
//         return config;
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ZegoUIKitPrebuiltCall(
//       appID: 397177996,
//       appSign:
//       '19cc9c44747f36c647a2cbc24ad93bad791d249066ff4942b7500c656deeb5b3',
//       userID: widget.userid,
//       userName: widget.userName,
//       callID: widget.callID,
//       config: widget.isVideo
//           ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
//           : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall(),
//     );
//   }
// }
