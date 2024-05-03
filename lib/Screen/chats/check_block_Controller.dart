import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CheckBlockController extends GetxController {
  RxBool isBlocked = false.obs;

  void checkBlockUser(String userId) async {
    try {
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (documentSnapshot.exists) {
        var blockUsers = documentSnapshot.data()?['blockUsers'];
        if (blockUsers != null &&
            (blockUsers as List).contains(userId)) {
          isBlocked.value = true;
          print('true');
        } else {
          isBlocked.value = false;
          print('false');
        }
      } else {
        // User document does not exist
        print('User document does not exist');
      }
    } catch (error) {
      // Handle any errors
      print("Error checking user block status: $error");
    }
  }
}
