import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:onelink/Models/ONboardingModel.dart';
import 'package:onelink/Screen/AppBar&BottomBar/Appbar&BottomBar.dart';
import 'package:onelink/Screen/ONboardingScreens/Onboarding.dart';
import 'package:onelink/Widgets/dotWidget.dart';
import 'package:onelink/main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
class spalshscreen extends StatefulWidget {
  @override
  _spalshscreenState createState() => _spalshscreenState();
}

class _spalshscreenState extends State<spalshscreen> {
    // Define a StreamController
  StreamController<int> _controller = StreamController<int>();
  
  
  @override
  void initState() {
    super.initState();
    // Start the continuous loop of changing ball colors
    _startLoop();
  }

  @override
  void dispose() {
    super.dispose();
    // Dispose the StreamController to avoid memory leaks
    _controller.close();
  }

  // Function to start the continuous loop of changing ball colors
  void _startLoop() {
    Timer.periodic(Duration(seconds: 3), (timer) {
 
      Navigator.push(context, MaterialPageRoute(builder:
       (Context)=>Onboarding()
      ));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('Assets/images/logo2.png'),
          LoadingAnimationWidget.staggeredDotsWave(
        color: Color.fromARGB(255, 244, 66, 66),
        size:50,
      ),
      
        ],
      )),
    );
  }
}