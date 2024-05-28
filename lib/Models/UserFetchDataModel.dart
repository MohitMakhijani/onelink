class UserModel1 {
  String? userId;
  String? name;
  String? dateOfBirth;
  String? gender;
  String? email;
  String? phoneNumber;
  String? occupation;
  String? state;
  String? district;
  String? profilePicture;
  String? bio;
  String? achievements;
  bool isVerified = false;

  UserModel1();

  UserModel1.fromJson(Map<String?, dynamic> json)
      : userId = json['userId'],
        name = json['name'],
        dateOfBirth = json['dateOfBirth'],
        gender = json['gender'],
        email = json['email'],
        phoneNumber = json['phoneNumber'],
        occupation = json['occupation'],
        state = json['state'],
        district = json['district'],
        profilePicture = json['profilePicture'],
        bio = json['bio'],
        achievements = json['achievements'],
        isVerified = json['isVerified'] ?? false;
}
