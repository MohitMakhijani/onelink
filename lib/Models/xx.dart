class UserModel1 {
  String? userId;
  String? name;
  String? email;
  String? bio;
  String? profilePhotoUrl;
  String? phoneNumber;
  String? dateOfbirth;
  String? LinkedIn;
  bool showEmail = true;
  bool showPhone = true;
  bool showLinkedin = true;
  int? postCount;

  UserModel1();

  UserModel1.fromJson(Map<String, dynamic> json) {
    userId = json['uuid'];
    name = json['name'];
    email = json['email'];
    profilePhotoUrl = json['profilePhotoUrl'];
    postCount = json['postCount'];
    phoneNumber = json['phoneNumber'];
    dateOfbirth = json['dateOfbirth'];
    bio = json['bio'];
    LinkedIn = json['LinkedIn'];
    showEmail = json['showEmail'] ?? true;
    showPhone = json['showPhone'] ?? true;
    showLinkedin = json['showLinkedin'] ?? true;
  }
}
