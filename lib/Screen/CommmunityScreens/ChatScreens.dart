import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../FetchDataProvider/fetchData.dart';
import '../../Widgets/TextLinkWidget.dart';


enum ChatStreamEvent {
  refresh,
}

class CommunityChatScreen extends StatefulWidget {
  final String communityId;
  final String currentUserId;
  final String communityName;

  CommunityChatScreen({
    required this.communityId,
    required this.currentUserId,
    required this.communityName,
  });

  @override
  _CommunityChatScreenState createState() => _CommunityChatScreenState();
}

class _CommunityChatScreenState extends State<CommunityChatScreen> {
  late ScrollController _scrollController;
  StreamController<QuerySnapshot>? _streamController;
  List<String> _communityMembers = []; // List to store community members

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _streamController = StreamController<QuerySnapshot>();
    _fetchMessages();
    _fetchCommunityMembers(); // Initial fetch of messages
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _streamController?.close();
    super.dispose();
  }

  void _fetchCommunityMembers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('communities')
          .doc(widget.communityId)
          .collection('members')
          .get();

      setState(() {
        _communityMembers =
            querySnapshot.docs.map((doc) => doc['name'].toString()).toList();
      });
    } catch (e) {
      print('Error fetching community members: $e');
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {}
  }

  void _fetchMessages() {
    FirebaseFirestore.instance
        .collection('communities')
        .doc(widget.communityId)
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

  @override
  Widget build(BuildContext context) {
    final userFetchController =
    Provider.of<UserFetchController>(context, listen: false);
    final picker = ImagePicker();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {

          }, icon: FaIcon(CupertinoIcons.info,color: Colors.black,)
          )],
        title: Row(
          children: [
            CircleAvatar(
              radius: 19.r,
              backgroundImage: const NetworkImage(
                  'https://www.ingeniux.com/Images/Blog/Blog%20Images/Blog%20Front/web-cms-student-portal-main.jpg'),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.03),
            Text(
              widget.communityName,
              style: GoogleFonts.inter(
                  fontSize: 12.sp,fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _streamController!.stream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return  Center(
                    child:  LoadingAnimationWidget.staggeredDotsWave(
                      color: Color.fromARGB(255, 244, 66, 66),
                      size:50,
                    )
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  );
                });

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = snapshot.data!.docs[index]
                        .data() as Map<String, dynamic>;

                    // Check if the message sender is the current user
                    bool isCurrentUser = data['senderId'] ==
                        FirebaseAuth.instance.currentUser!.phoneNumber;

                    return Row(
                      mainAxisAlignment: (isCurrentUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start),
                      children: [
                        BubbleMessage(
                          isCurrentUser: isCurrentUser,
                          sender: data['sender'],
                          text: data['text'],
                          imageUrl: data['imageUrl'],
                          timestamp: data['timestamp'],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageComposer(
              context, picker), // Pass context and image picker
        ],
      ),
    );
  }

  Widget _buildMessageComposer(BuildContext context, ImagePicker picker) {
    TextEditingController _messageController = TextEditingController();

    Future<void> _getImage(ImageSource source) async {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        final userFetchController =
        Provider.of<UserFetchController>(context, listen: false);
        String? senderName =
            userFetchController.myUser.name; // Get the sender's name
        _sendMessage('', senderName!, imageFile: imageFile);
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: FaIcon(Iconsax.sticker_outline),
            onPressed: () async {
              await _getImage(ImageSource.camera);
            },
          ),

          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration.collapsed(hintText: 'Type your message here'),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: FaIcon(FontAwesome.paperclip_solid),
                onPressed: () async {
                  await _getImage(ImageSource.gallery);
                },
              ), IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  _sendMessage(_messageController.text.trim(), '');
                  _messageController.clear();
                  setState(() {

                  });
                  // Send only text message
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sendMessage(String messageText, String senderName,
      {File? imageFile}) async {
    if (messageText.isEmpty && imageFile == null) {
      return; // Return if both message text and image are empty
    }

    String?
    imageUrl; // Placeholder for image URL, if needed (for Firebase Storage upload)

    // Check if an image file is provided
    if (imageFile != null) {
      imageUrl = await _uploadImageToFirebase(imageFile);
    }

    FirebaseFirestore.instance
        .collection('communities')
        .doc(widget.communityId)
        .collection('messages')
        .add({
      'sender': senderName, // Set the sender's name
      'text': messageText,
      'imageUrl': imageUrl, // Include the image URL in the message data
      'timestamp': DateTime.now(),
      'senderId': FirebaseAuth.instance.currentUser!.phoneNumber
    });
  }

  Future<String?> _uploadImageToFirebase(File imageFile) async {
    try {
      // Generate a unique filename for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
      FirebaseStorage.instance.ref().child('images/$fileName.jpg');

      // Upload the image to Firebase Storage
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Download the image to the device's gallery
      await _downloadImageToDevice(downloadUrl);

      return downloadUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return null;
    }
  }

  Future<void> _downloadImageToDevice(String imageUrl) async {
    try {
      print('Downloading image to Firebase Storage');
      final response = await http.get(Uri.parse(imageUrl));
      final bytes = response.bodyBytes;

      final String dir = (await getApplicationDocumentsDirectory()).path;
      File file = File('$dir/image.jpg');
      await file.writeAsBytes(bytes);
    } catch (e) {
      print('Error downloading image: $e');
    }
  }
}

class BubbleMessage extends StatelessWidget {
  final bool isCurrentUser;
  final String sender;
  final String text;
  final String? imageUrl; // Updated to handle image URL or local file path
  final Timestamp timestamp;

  const BubbleMessage({
    Key? key,
    required this.isCurrentUser,
    required this.sender,
    required this.text,
    this.imageUrl, // Updated to handle image URL or local file path
    required this.timestamp,
  }) : super(key: key);

  void _openImageFullScreen(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Image.network(imageUrl), // Show image in full-screen view
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat.yMd().add_jm().format(timestamp.toDate());
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(isCurrentUser ? 1 : -1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: ModalRoute.of(context)!.animation!,
          curve: Curves.easeIn,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          if (imageUrl != null) {
            _openImageFullScreen(
                context, imageUrl!); // Open image in full-screen view
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            margin: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(7)),
              color: isCurrentUser ? Colors.grey[200] : Colors.grey[200],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Show sender's name only for received messages
                if (!isCurrentUser)
                  Text(sender,
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                // Display image from URL directly
                if (imageUrl != null)
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Image.network(imageUrl!),
                  ),
                // Display text if not empty
                if (text.isNotEmpty)
                  Container(
                    constraints: BoxConstraints(maxWidth: 250.w), // Adjust width as needed
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),   SizedBox(height: 4),
                Text(
                  formattedTime,
                  style:  TextStyle(fontWeight: FontWeight.w600, fontSize: 10.sp, color:Colors.black,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}