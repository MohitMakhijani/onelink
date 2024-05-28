import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:onelink/Screen/AppBar&BottomBar/Appbar&BottomBar.dart';
import 'package:onelink/Services/FireStoreMethod.dart';
import 'package:onelink/Theme.dart';
import 'package:onelink/components/MyToast.dart';
import 'package:onelink/components/myButton.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:video_player/video_player.dart';

class AddPostScreen extends StatefulWidget {
  final String uid;

  const AddPostScreen({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  dynamic _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  late String userProfile = '';
  late String userName = '';

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
    setUp();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
    );
    _controller = CameraController(frontCamera, ResolutionPreset.medium);
    return _controller.initialize();
  }

  Future<void> setUp() async {
    final usersnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();
    setState(() {
      userName = usersnapshot['name'];
      userProfile = usersnapshot['profilePicture'];
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _captureImage() async {
    try {
      await _initializeControllerFuture;
      final XFile? file = await _controller.takePicture();
      if (file != null) {
        if (file.path.toLowerCase().endsWith('.mp4')) {
          setState(() {
            _file = File(file.path);
          });
        } else {
          final Uint8List? imageData = await file.readAsBytes();
          if (imageData != null) {
            setState(() {
              _file = imageData;
            });
          }
        }
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.light ? Colors.white : Colors.black,
      appBar: AppBar(
        toolbarHeight: 30,
        leading: _file != null
            ? IconButton(
          icon: Icon(Icons.arrow_back,
              color: !AppTheme.light ? Colors.white : Colors.black),
          onPressed: () {
            setState(() {
              _file = null;
            });
          },
        )
            : null,
        backgroundColor: AppTheme.light ? Colors.white : Colors.black,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (_file != null) {
                // Navigate to caption page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CaptionPage(
                      file: _file!,
                      name: userName,
                      profile: userProfile,
                    ),
                  ),
                );
              } else {
                _toggleFlash();
              }
            },
            icon: FaIcon(
              _file == null ? EvaIcons.flash : Bootstrap.forward,
              size: 30,
              color: _file == null
                  ? !AppTheme.light
                  ? Colors.white
                  : Colors.black
                  : Colors.red,
            ),
          ),
        ],
      ),
      body: _file == null ? _buildCameraPreview() : _buildImageOrVideoPreview(),
    );
  }

  void _toggleFlash() async {
    if (!_controller.value.isInitialized) {
      return;
    }
    try {
      final bool hasFlash = _controller.value.flashMode == FlashMode.torch;
      if (hasFlash) {
        await _controller.setFlashMode(FlashMode.off);
      } else {
        await _controller.setFlashMode(FlashMode.torch);
      }
    } on CameraException catch (e) {
      print('Error toggling flash: ${e.description}');
    }
  }

  void _toggleCameraLensDirection() async {
    if (_controller.value.description.lensDirection ==
        CameraLensDirection.front) {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
      );
      _controller = CameraController(backCamera, ResolutionPreset.medium);
    } else {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
      );
      _controller = CameraController(frontCamera, ResolutionPreset.medium);
    }

    await _controller.initialize();
    setState(() {});
  }

  Widget _buildCameraPreview() {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Stack(
                  children: [
                    CameraPreview(_controller),
                    if (_file != null && _file is Uint8List)
                      Image.memory(
                        _file!,
                        fit: BoxFit.cover,
                      ),
                    if (_file != null && _file is File)
                      VideoPlayerController.file(File(_file!.path)).value.isInitialized
                          ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(
                          VideoPlayerController.file(File(_file!.path)),
                        ),
                      )
                          : Container(),
                  ],
                );
              } else {
                return Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Color.fromARGB(255, 244, 66, 66),
                    size: 50,
                  ),
                );
              }
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () async {
                final List<AssetEntity>? result = await AssetPicker.pickAssets(context);
                if (result != null && result.isNotEmpty) {
                  final AssetEntity asset = result.first;
                  if (asset.type == AssetType.video) {
                    File? file = await asset.file;
                    if (file != null) {
                      setState(() {
                        _file = file;
                      });
                    }
                  } else {
                    File? file = await asset.file;
                    if (file != null) {
                      Uint8List? fileData = await file.readAsBytes();
                      _file = fileData;
                      setState(() {});
                    }
                  }
                }
              },
              icon: Icon(Icons.photo_library),
              color: !AppTheme.light ? Colors.white : Colors.black,
              iconSize: 30,
            ),
            IconButton(
              onPressed: _captureImage,
              icon: Icon(Icons.camera),
              color: !AppTheme.light ? Colors.white : Colors.black,
              iconSize: 30,
            ),
            IconButton(
              onPressed: _toggleCameraLensDirection,
              icon: Icon(Icons.flip_camera_android),
              color: !AppTheme.light ? Colors.white : Colors.black,
              iconSize: 30,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageOrVideoPreview() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: _file is Uint8List
            ? Image.memory(
          _file!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        )
            : _file is File
            ? VideoPlayer(
          VideoPlayerController.file(File(_file!.path)),
        )
            : Container(),
      ),
    );
  }
}

class CaptionPage extends StatefulWidget {
  final dynamic file;
  final String name;
  final String profile;

  const CaptionPage({
    Key? key,
    required this.file,
    required this.name,
    required this.profile,
  }) : super(key: key);

  @override
  _CaptionPageState createState() => _CaptionPageState();
}

class _CaptionPageState extends State<CaptionPage> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: !AppTheme.light ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: !AppTheme.light ? Colors.black : Colors.white,
        foregroundColor: AppTheme.light ? Colors.black : Colors.white,
        centerTitle: true,
        title: Text(
          'Caption',
          style: TextStyle(
              color: AppTheme.light ? Colors.black : Colors.white,
              fontSize: 25.sp),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 250.h,
                    width: MediaQuery.of(context).size.width / 1.2,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: widget.file is Uint8List
                        ? Image.memory(
                      widget.file,
                      fit: BoxFit.cover,
                    )
                        : widget.file is File
                        ? VideoPlayer(
                      VideoPlayerController.file(File(widget.file!.path)),
                    )
                        : Container(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                child: TextField(
                  maxLength: 800,
                  controller: _descriptionController,
                  style: TextStyle(
                      color: AppTheme.light ? Colors.black : Colors.white),
                  decoration: InputDecoration(
                    hintText: "Write a caption...",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 8,
                ),
              ),
            ),
            SizedBox(height: 5),
            MyButton3(
                onTap: () {
                  FireStoreMethods().uploadPost(
                      _descriptionController.text,
                      widget.file,
                      FirebaseAuth.instance.currentUser!.uid,
                      widget.name,
                      widget.profile);
                  ToastUtil.showToastMessage('Post Successfully Uploaded');
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                },
                text: 'Post',
                color: Colors.red[400],
                textcolor: Colors.white)
          ],
        ),
      ),
    );
  }
}
