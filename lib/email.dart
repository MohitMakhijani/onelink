import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'components/MyToast.dart';


class ApiFunc {
  // Define the API endpoint
  final String apiUrl = 'https://emailverifcationcode.onrender.com/send-email';

  // Function to send email
  Future<void> mail({required String targetuser}) async {
    // Create the request body
    final Map<String, String> body = {
      
      "email": targetuser,
      "subject": "Event Joined !!!",
      "messsage": "You Successfully Participated Event!"
    };

    try {
      // Make the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      // Check the response status
      if (response.statusCode == 200) {
        ToastUtil.showToastMessage('Event Joined Successfully');
        // Success
        print('Email sent successfully.');
      } else {
        ToastUtil.showToastMessage('Error');
        // Failure
        print('Failed to send email. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      // Handle any errors
      print('Error sending email: $e');
    }
  }
}

