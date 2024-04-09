// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
//
// import '../../utils/utils.dart';
//
// class ProfileController extends GetxController {
//   var userData = {}.obs;
//   var postLen = 0.obs;
//   var followers = 0.obs;
//   var following = 0.obs;
//   var isFollowing = false.obs;
//   var isLoading = false.obs;
//
//   void getData() async {
//     isLoading.value = true;
//
//     try {
//       var userSnap = await FirebaseFirestore.instance
//           .collection('users')
//           .where('uuid', isEqualTo: widget.uid)
//           .get();
//       var postSnap = await FirebaseFirestore.instance
//           .collection('posts')
//           .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//           .get();
//
//       if (userSnap.docs.isNotEmpty) {
//         var userDataDoc = userSnap.docs.first;
//         userData.value = userDataDoc.data();
//         followers.value = userData['followers'].length;
//         following.value = userData['following'].length;
//         isFollowing.value = userData['followers']
//             .contains(FirebaseAuth.instance.currentUser!.uid);
//         postLen.value = postSnap.docs.length;
//       } else {
//         showSnackBar(context, 'User data not found.');
//       }
//     } catch (e) {
//       showSnackBar(
//         context,
//         e.toString(),
//       );
//     }
//
//     isLoading.value = false;
//   }
// }
