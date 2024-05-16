// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:onelink/Auth/SignUp.dart';
import 'package:onelink/Screen/AppBar&BottomBar/Appbar&BottomBar.dart';

class LoadingScreen extends StatefulWidget {
  final String Action;
  const LoadingScreen(this.Action, {super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Get the current user

    Future.delayed(const Duration(milliseconds: 800), () {
      if (widget.Action == 'AuthtoHome' ||
          widget.Action == 'AddElementToHome' ||
          widget.Action == 'EditElementToHome' ||
          widget.Action == 'Refresh') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else if (widget.Action == 'logouttoHome') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      } else if (widget.Action == 'SettingTheme') {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: Color.fromARGB(255, 244, 66, 66),
          size: 50,
        ),
      ),
    );
  }
}
