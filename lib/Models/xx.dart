class UserModel1 {
  String? userId;
  String? name;
  String? email;
  String? bio;
  String? profilePhotoUrl;
  String? phoneNumber;
  String? dateOfbirth;
  int? postCount;
  // List<String>? following;
  // List<String>? followers;

  UserModel1();

  UserModel1.fromJson(Map<String, dynamic> json) {
    userId = json['uuid'];
    bio = json['bio'];
    // followers = List<String>.from(json['followers'] ?? []);
    // following = List<String>.from(json['following'] ?? []);
    name = json['name'];
    email = json['email'];
    profilePhotoUrl = json['profilePhotoUrl'];
    postCount = json['postCount'];
    phoneNumber = json['phoneNumber'];
    dateOfbirth = json['dateOfbirth'];
    bio = json['bio'];
  }
}
