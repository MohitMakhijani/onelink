
class UserModel1 {
  String? userId;
  String? name;
  String? email;
  String? profilePhotoUrl;
  String? phoneNumber;
  String? JobCount;
  String? EventCount;
  String? dateOfbirth;
  int? postCount;

  UserModel1();

  UserModel1.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    JobCount = json['JobCount'];
    EventCount = json['EventCount'];

    name = json['name'];
    email = json['email'];
    profilePhotoUrl = json['profilePhotoUrl'];
    postCount = json['postCount'];
    phoneNumber=json['phoneNumber'];
    dateOfbirth=json['dateOfbirth'];
  }
}
