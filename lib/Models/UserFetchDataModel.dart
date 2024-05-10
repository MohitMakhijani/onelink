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
  String? instagramLink;
  String? linkedinLink;
  bool isVerified = false;
  bool showEmail = false;
  bool showPhone = false;
  bool showLinkedin = false;
  bool showInstagram = false;

  UserModel1();

  UserModel1.fromJson(Map<String?, dynamic> json)
      : userId = json['userId'],
        name = json['name'],
        dateOfBirth = json['dateOfBirth'],
        gender = json['gender'],
        email = json['email'],
        phoneNumber = json['phoneNumber'],
        occupation = json['occupation'],
        showInstagram=json['showInstagram'],
        state = json['state'],
        district = json['district'],
        profilePicture = json['profilePicture'],
        bio = json['bio'],
        achievements = json['achievements'],
        instagramLink = json['instagramLink']??false,
        linkedinLink = json['linkedinLink'],
        isVerified = json['isVerified'] ?? false,
        showEmail = json['showEmail'] ?? false,
        showPhone = json['showPhone'] ?? false,
        showLinkedin = json['showLinkedin'] ?? false;
}
