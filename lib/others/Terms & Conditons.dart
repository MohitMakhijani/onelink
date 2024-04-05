import 'package:flutter/material.dart';
import 'package:onelink/constants/constants.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Terms and Conditions",
          style: kAppBarFont.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            "Terms and Conditions",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed auctor eget velit in semper. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nullam vitae nulla varius, tincidunt magna sit amet, eleifend nibh. Suspendisse potenti. Duis tristique ligula nec quam finibus posuere. Sed auctor est at arcu vehicula, nec convallis libero molestie. Nullam sollicitudin justo vitae ante laoreet, in scelerisque lorem ultrices. Nulla in quam pretium, scelerisque ipsum ac, facilisis lacus. Sed non aliquet elit. Suspendisse sed mi turpis. Ut vel velit vel ante varius hendrerit.",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            "Privacy Policy",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed auctor eget velit in semper. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nullam vitae nulla varius, tincidunt magna sit amet, eleifend nibh. Suspendisse potenti. Duis tristique ligula nec quam finibus posuere. Sed auctor est at arcu vehicula, nec convallis libero molestie. Nullam sollicitudin justo vitae ante laoreet, in scelerisque lorem ultrices. Nulla in quam pretium, scelerisque ipsum ac, facilisis lacus. Sed non aliquet elit. Suspendisse sed mi turpis. Ut vel velit vel ante varius hendrerit.",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
