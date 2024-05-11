import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:onelink/Screen/chats/ChatSettingPage.dart';
import 'package:onelink/Screen/chats/check_block_Controller.dart';

import '../../Widgets/Audio/Video.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final String UserName;
  final String ProfilePicture;
  final String UId;

  const ChatScreen({
    Key? key,
    required this.chatRoomId,
    required this.UserName,
    required this.ProfilePicture,
    required this.UId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _messageController;
  late ScrollController _scrollController;
  late StreamController<QuerySnapshot>? _streamController;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    final CheckBlockController _checkBlockController =
    Get.put(CheckBlockController());

    _checkBlockController.checkBlockUser(widget.UId);
    _fetchTargetUserInfo(); // Fetch the target user's info
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _streamController?.close();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // Implement any logic you need when scrolling reaches the bottom
    }
  }

  void _updateRecentMessage(String message, String senderUid) {
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(widget.chatRoomId)
        .update({'recentMessage': message});
  }
  void _deleteMessage(DocumentSnapshot messageSnapshot) {
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(widget.chatRoomId)
        .collection('messages')
        .doc(messageSnapshot.id)
        .delete()
        .then((value) {
      print('Message deleted successfully');
    }).catchError((error) {
      print('Error deleting message: $error');
    });
  }
  void _fetchMessages() {
    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(widget.chatRoomId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .listen((snapshot) {
      if (_streamController != null && !_streamController!.isClosed) {
        _streamController!
            .add(snapshot); // Add the snapshot to the stream controller
      } else {
        _streamController =
            StreamController<QuerySnapshot>(); // Create a new stream controller
        _streamController!
            .add(snapshot); // Add the snapshot to the new stream controller
      }
    });
  }

  void _fetchTargetUserInfo() async {
    DocumentSnapshot roomSnapshot = await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(widget.chatRoomId)
        .get();

    List<String> users = List.from(roomSnapshot['users']);
  }

  void _sendMessage(String messageText, File? imageFile, File? videoFile,
      File? audioFile) async {
    if (messageText.isEmpty &&
        imageFile == null &&
        videoFile == null &&
        audioFile == null) {
      return; // Return if all attachments are empty
    }

    String? imageUrl;
    String? videoUrl;
    String? audioUrl;

    if (imageFile != null) {
      imageUrl = await _uploadFileToFirebase(imageFile);
    }
    if (videoFile != null) {
      videoUrl = await _uploadFileToFirebase(videoFile);
    }
    if (audioFile != null) {
      audioUrl = await _uploadFileToFirebase(audioFile);
    }

    _updateRecentMessage(
      messageText.trim(),
      FirebaseAuth.instance.currentUser!.uid,
    );

    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(widget.chatRoomId)
        .collection('messages')
        .add({
      'message': messageText,
      'senderUid': FirebaseAuth.instance.currentUser!.uid,
      'timestamp': Timestamp.now(),
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'audioUrl': audioUrl,
    });

    _messageController.clear();
  }

  Future<String?> _uploadFileToFirebase(File file) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
      FirebaseStorage.instance.ref().child('files/$fileName');
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading file to Firebase Storage: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final CheckBlockController _checkBlockController =
    Get.put(CheckBlockController());

    _fetchMessages(); // Initial fetch of messages

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatSettingsPage(
                  UId: widget.UId,
                  UserName: widget.UserName,
                  ProfilePicture: widget.ProfilePicture,
                  chatroomId: widget.chatRoomId,
                ),
              ),
            );
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage:
                CachedNetworkImageProvider(widget.ProfilePicture),
              ),
              SizedBox(width: 8.w),
              Text(
                widget.UserName,
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: FaIcon(
              Icons.videocam_outlined,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: FaIcon(
              Icons.local_phone_outlined,
              size: 30,
            ),
          )
        ],
      ),
      body: Obx(() {
      if (_checkBlockController.isBlocked.value) {
        return Center(
          child: Text("This User is currently Blocked"),
        );
      } else {
        return Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chatRooms')
                    .doc(widget.chatRoomId)
                    .collection('messages')
                    .orderBy('timestamp')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Color.fromARGB(255, 244, 66, 66),
                        size: 50,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                    );
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot messageSnapshot =
                      snapshot.data!.docs[index];
                      Map<String, dynamic> data = messageSnapshot.data()
                      as Map<String, dynamic>;

                      // Check if the message sender is the current user
                      bool isCurrentUser = data['senderUid'] ==
                          FirebaseAuth.instance.currentUser!.uid;

                      return Row(
                        mainAxisAlignment: isCurrentUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          BubbleMessage(
                            isCurrentUser: isCurrentUser,
                            sender: isCurrentUser ? 'You' : '',
                            targetUserName:
                            isCurrentUser ? '' : widget.UserName,
                            text: data['message'],
                            imageUrl: data['imageUrl'],
                            videoUrl: data['videoUrl'],
                            audioUrl: data['audioUrl'],
                            timestamp: data['timestamp'],
                            onDeletePressed: () =>
                                _deleteMessage(messageSnapshot), // Pass onDeletePressed function
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Visibility(
              child: _buildMessageComposer(),
              visible: !_checkBlockController.isBlocked.value,
            )
          ],
        );
      }
    }),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: FaIcon(Iconsax.image_bold),
            onPressed: () async {
              final pickedFile =
              await picker.getImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                File image = File(pickedFile.path);
                _sendMessage('', image, null, null); // Send image file
              }
            },
          ),
          IconButton(
            icon: FaIcon(Iconsax.video_add_bold),
            onPressed: () async {
              final pickedFile =
              await picker.getVideo(source: ImageSource.gallery);
              if (pickedFile != null) {
                File videoFile = File(pickedFile.path);
                _sendMessage('', null, videoFile, null); // Send video file
              }
            },
          ),
          IconButton(
            icon: FaIcon(Iconsax.microphone_2_bold),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: [
                  'mp3',
                  'wav',
                  'aac'
                ], // Add more extensions if needed
              );
              if (result != null) {
                File audioFile = File(result.files.single.path!);
                _sendMessage('', null, null, audioFile); // Send audio file
              }
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration:
              InputDecoration.collapsed(hintText: 'Type your message here'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _sendMessage(_messageController.text.trim(), null, null,
                  null); // Send text message
            },
          ),
        ],
      ),
    );
  }
}

class BubbleMessage extends StatelessWidget {
  final bool isCurrentUser;
  final String sender;
  final String targetUserName;
  final String text;
  final String? imageUrl;
  final String? videoUrl;
  final String? audioUrl;
  final Timestamp timestamp;
  final VoidCallback? onDeletePressed;

  const BubbleMessage({
    Key? key,
    required this.isCurrentUser,
    required this.sender,
    required this.targetUserName,
    required this.text,
    this.imageUrl,
    this.videoUrl,
    this.audioUrl,
    required this.timestamp, this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat.yMd().add_jm().format(timestamp.toDate());
    // Format timestamp as a string representing date and time

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(7)),
          color: isCurrentUser ? Colors.grey[200] : Colors.grey[200],
        ),
        child: GestureDetector(
          onLongPress: onDeletePressed,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null && imageUrl!.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    if (imageUrl != null && Uri.parse(imageUrl!).isAbsolute) {
                      _openImageFullScreen(context, imageUrl!);
                    } else {
                      print('Invalid image URL');
                    }
                  },
                  child: Image.network(
                    imageUrl!,
                    width: 200,
                  ),
                ),
              if (videoUrl != null && videoUrl!.isNotEmpty)
                VideoPlayerWidget(videoUrl!), // Display video player
              if (audioUrl != null && audioUrl!.isNotEmpty)
                AudioPlayerWidget(audioUrl!), // Display audio player
              if (text.isNotEmpty)
                Container(
                  constraints:
                  BoxConstraints(maxWidth: 250.w), // Adjust width as needed
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isCurrentUser == true ? Colors.black : Colors.black,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                formattedTime,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                  color: isCurrentUser == true ? Colors.black : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openImageFullScreen(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }
}
