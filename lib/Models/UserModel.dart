import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String name;
  final String dateOfBirth;
  final String gender;
  final String email;
  final String phoneNumber;
  final String occupation;
  final String state;
  final String district;
  final String profilePicture;
  final String bio;
  final String achievements;
  final String instagramLink;
  final String linkedinLink;
  final bool IsVerified;

  UserModel({
    required this.IsVerified,
    required this.userId,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.email,
    required this.phoneNumber,
    required this.occupation,
    required this.state,
    required this.district,
    required this.profilePicture,
    required this.bio,
    required this.achievements,
    required this.instagramLink,
    required this.linkedinLink,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      userId: snapshot.id,
      name: data['name'] ?? '',
      dateOfBirth: data['dateOfBirth'] ?? '',
      gender: data['gender'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      occupation: data['occupation'] ?? '',
      state: data['state'] ?? '',
      district: data['district'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
      bio: data['bio'] ?? '',
      achievements: data['achievements'] ?? '',
      instagramLink: data['instagramLink'] ?? '',
      linkedinLink: data['linkedinLink'] ?? '',
      IsVerified: false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'email': email,
      'phoneNumber': phoneNumber,
      'occupation': occupation,
      'state': state,
      'district': district,
      'profilePicture': profilePicture,
      'bio': bio,
      'achievements': achievements,
      'instagramLink': instagramLink,
      'linkedinLink': linkedinLink,
    };
  }

  @override
  String toString() {
    return 'UserModel{userId: $userId, name: $name, email: $email, '
        'profilePicture: $profilePicture, dateOfBirth: $dateOfBirth, '
        'phoneNumber: $phoneNumber}';
  }
}
