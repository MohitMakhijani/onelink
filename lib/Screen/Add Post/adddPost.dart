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
import 'package:onelink/Services/FireStoreMethod.dart';
import 'package:onelink/components/myButton.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

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
    Uint8List? _file;
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
        final Uint8List? imageData = await file.readAsBytes();
        if (imageData != null) {
          setState(() {
            _file = imageData;
          });
        }
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 25,
        leading: _file != null
            ? IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _file = null;
            });
          },
        )
            : null,
        backgroundColor: Colors.white,
        centerTitle: true,

        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (_file != null) {
                // Navigate to caption page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CaptionPage(image: _file!, name: userName, profile: userProfile,),
                  ),
                );
              } else {
                _toggleFlash();
              }
            },
            icon: FaIcon(
              _file == null ? EvaIcons.flash : Icons.arrow_right,size: 18,
              color: _file == null ? Colors.black : Colors.red,
            ),
          ),
        ],
      ),
      body: _file == null
          ? _buildCameraPreview()
          : _buildImagePreview(),
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
                  return CameraPreview(_controller);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [    IconButton(
              onPressed: () async {
                final List<AssetEntity>? result =
                await AssetPicker.pickAssets(context);
                if (result != null && result.isNotEmpty) {
                  final AssetEntity asset = result.first;
                  File? file = await asset.file;
                  if (file != null) {
                    Uint8List? fileData = await file.readAsBytes();
                    _file = fileData;
                    setState(() {});
                  }
                }
              },
              icon: Icon(Icons.photo_library),
              color: Colors.black,
              iconSize: 30,
            ),
              IconButton(
                onPressed: _captureImage,
                icon: Icon(Icons.camera),
                color: Colors.black,
                iconSize: 30,
              ),
              IconButton(
                onPressed: _toggleCameraLensDirection,
                icon: Icon(Icons.flip_camera_android),
                color: Colors.black,
                iconSize: 30,
              ),

            ],
          ),
        ],
      );
    }


  Widget _buildImagePreview() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.memory(
            _file!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}

class CaptionPage extends StatefulWidget {
  final Uint8List image;
  final String name;
  final String profile;

  const CaptionPage({Key? key, required this.image, required this.name, required this.profile}) : super(key: key);

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
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Caption',
          style: TextStyle(color: Colors.black, fontSize: 25.sp),
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
                    width: MediaQuery.of(context).size.width/1.2,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.memory(
                        widget.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 100,
                child: TextField(
                  maxLength: 800,
                  controller: _descriptionController,
                  
                  decoration: InputDecoration(
                    hintText: "Write a caption...",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 8,
                ),
              ),
            ),
            SizedBox(height: 5),
           MyButton3(onTap: () {
FireStoreMethods().uploadPost(_descriptionController.text, widget.image, FirebaseAuth.instance.currentUser!.uid,widget.name, widget.profile );

           }, text: 'Post', color: Colors.red[400], textcolor: Colors.white)
          ],
        ),
      ),
    );
  }
}
