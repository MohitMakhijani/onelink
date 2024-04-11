import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onelink/Auth/OTP%20SUCESS.dart';
import 'package:onelink/Screens/Home/BottomNavPage.dart';
import 'package:onelink/Screens/profile/SetUpProfile/setupProfilePage.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../Get/fetchdata.dart';
import '../components/myButton.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  final String verificationId;

  OTPScreen({required this.phone, required this.verificationId});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _pinPutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.2, // Adjusted height
              width: MediaQuery.of(context).size.width, // Adjusted height

              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Image.asset(
                 "Assets/images/verification2.png",
                  fit: BoxFit.fill, // Maintain aspect ratio while covering the container
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "OTP Verification",
                  style:
                      GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),  Padding(
              padding: const EdgeInsets.only(left: 28.0,top: 15),
              child: Row(
                children: [
                  Text(
                    "Enter The OTP sent to ",
                    style:
                        GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w400),
                  ),Text(
                    "+91${widget.phone} ",
                    style:
                        GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Pinput(
                defaultPinTheme: PinTheme(
                    height: 80,
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(width: 1))),
                androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                length: 6,
                controller: _pinPutController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Text(
                    "Didn't you recived the OTP?   ",
                    style:
                    GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400,color: Colors.grey),
                  ),
                  Text(
                    "Resend OTP",
                    style:
                    GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color:Color(0xFF888BF4) ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _verifyOTP,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: MyButton(
                      onTap: () => _verifyOTP(),
                      text: "Verify",
                      color:Color(0xFF888BF4)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _verifyOTP() async {
    String pin = _pinPutController.text.trim();
    if (pin.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid OTP.")),
      );
      return;
    }

    try {
      // Verify OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: pin,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Check if the user exists and navigate accordingly
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? phoneNumber = user.phoneNumber;
        if (phoneNumber != null) {
          bool isPhoneNumberRegistered =
              await isPhoneNumberAlreadyRegistered(phoneNumber);
          if (isPhoneNumberRegistered) {
            // Phone number is registered, navigate to home page
            // Provider.of<UserFetchController>(context, listen: false).fetchUserData();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else {
            // Phone number is not registered, navigate to setup profile page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OTPSUCCESS()),
            );
          }
        } else {
          // Handle null phone number
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Phone number is null. Please try again.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User does not exist. Please try again.")),
        );
      }
    } catch (e) {
      // Handle verification failure
      print("Error verifying OTP: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to verify OTP. Please try again.")),
      );
    }
  }

  // Function to check if the phone number is already registered
  Future<bool> isPhoneNumberAlreadyRegistered(String phoneNumber) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print("Error checking phone number registration: $e");
      return false;
    }
  }
}
