import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String name;
  final String email;
  final String profilePhotoUrl;
  final String bio;
  final DateTime dateOfBirth;
  final int postCount;
  final String phoneNumber;
  final String uuid;

  UserModel(  {required this.bio,
    required this.userId,
    required this.name,
    required this.email,
    required this.profilePhotoUrl,
    required this.dateOfBirth,
    required this.postCount,
    required this.phoneNumber,
    required this.uuid,
  });

  // Create a factory constructor to convert Firestore snapshot to UserModel
  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      userId: snapshot.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profilePhotoUrl: data['profilePhotoUrl'] ?? '',
      dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate(),
      postCount: data['postCount'] ?? 0,
      phoneNumber: data['phoneNumber'] ?? '',
      uuid: data['uuid'] ?? '',
 bio: data['bio'],
    );
  }

  // Convert UserModel to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profilePhotoUrl': profilePhotoUrl,
      'dateOfBirth': dateOfBirth,
      'postCount': postCount,
      'phoneNumber': phoneNumber, // Add phoneNumber field
      'uuid': uuid, // Add uuid field
    };
  }

  @override
  String toString() {
    return 'UserModel{userId: $userId, name: $name, email: $email, '
        'profilePhotoUrl: $profilePhotoUrl, dateOfBirth: $dateOfBirth, '
        'postCount: $postCount, phoneNumber: $phoneNumber, uuid: $uuid}';
  }
}
