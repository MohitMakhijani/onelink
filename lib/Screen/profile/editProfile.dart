import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../FetchDataProvider/fetchData.dart';
import '../../Models/UserFetchDataModel.dart';
import '../../components/myButton.dart';
import '../../components/myTextfield.dart';
import 'editProfileGetx.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _achievements;
  late TextEditingController _emailController;
  late TextEditingController _instagramcontroller;
  late TextEditingController _linkController;
  late TextEditingController _bioController;
  TextEditingController _profession=TextEditingController();
  TextEditingController _contact=TextEditingController();
  TextEditingController _Address=TextEditingController();
  TextEditingController _link = TextEditingController();
  String? _selectedDate;
  File? _image;
  late UserModel1 _myUser;
  final _formKey = GlobalKey<FormState>();
  String _instagramLink='';
  String _YoutubeLink='';
  String _linkedinLink='';
  bool _LinkedAdded=false;
    String _TwitterLink='';
  bool _TwitterAdded=false;
    String _FacebookLink='';
  bool _FacebookAdded=false;
    String _GithubLink='';
  bool _GithubAdded=false;
  bool _InstagramAdded=false;
   bool _YoutubeAdded=false;
    bool _website=false;
     String _websiteLink='';
  bool _portfolio=false;
   String _PortfolioLink='';
   bool _Resume=false;
    String _ResumeLink='';
  bool _hideEmail = false;
  bool _hidePhone = false;
  bool _hideinstagram = false;
  bool _hideLinkedIn = false;
    bool _hideYoutube = false;
  bool _hideTwitter = false;
    bool _hideFacebook = false;
  bool _hideGithub = false;
    bool _hideWeb = false;
    bool _hidePortfolio = false;
  bool _hideResume = false;
  
  Map<String, String> socialMediaLinks = {};
  void addNewSocialMediaLink(String title, String link) {
    setState(() {
      socialMediaLinks[title] = link;
    });
  }

  void deleteSocialMediaLink(String title) {
    setState(() {
      socialMediaLinks.remove(title);
    });
  }

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _instagramcontroller = TextEditingController();
    _achievements = TextEditingController();

    _emailController = TextEditingController();
    _bioController = TextEditingController();
    _linkController = TextEditingController();
    final userFetchController =
        Provider.of<UserFetchController>(context, listen: false);
    _myUser = userFetchController.myUser;
    _instagramcontroller.text = _myUser.instagramLink ?? '';
    _emailController.text = _myUser.email ?? '';
    _achievements.text = _myUser.achievements ?? '';
    _bioController.text = _myUser.bio ?? '';
    _nameController.text = _myUser.name ?? '';
    _linkController.text = _myUser.linkedinLink ?? '';
    _selectedDate = _myUser.dateOfBirth;
    _image =
        _myUser.profilePicture != null ? File(_myUser.profilePicture!) : null;
    _hideEmail = _myUser.showEmail;
    _hidePhone = _myUser.showPhone;
    _hideinstagram = _myUser.showInstagram;
    _hideLinkedIn = _myUser.showLinkedin;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  String? _validateBio(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your bio';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email';
    }
    return null;
  }

  Future<String> _uploadProfileImage(String userId, File imageFile) async {
    try {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$userId.jpg');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading profile image: $e');
      throw e;
    }
  }

  String dropdownvalue = 'Social Media Links'; 
  String dropdownvalue1 = 'Website/Portfolio/Resume'; 
  String dropdownvalue2 = '';
  String dropdownvalue3 = '';// Current selected value
   String dropdownvalue4 = '';
  final List<String> SocialMediaLinks = [
    'Social Media Links',
    'Linkedin',
    'Instagram',
    'Youtube',
    'Twitter',
    'Facebook',
    'GitHub'
  ];
   final List<String> WebPortResume = [
    'Website/Portfolio/Resume',
    'Website',
    'Portfolio',
    'Resume',
    
  ];
  final List<String> currentJob = [
    '',
    'Working',
    'Open to work',
    'change company',
    
  ];
    final List<String> Internship = [
    '',
    'Yes',
    'No',
  ];
     final List<String> TypeOfInternShip = [
    '',
    'Paid',
    'UnPaid',
    'Both'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.redAccent, // LinkedIn-style color
        title: Text(
          "Edit Profile",
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Share.share('J.N.V');
              },
              icon: FaIcon(Icons.share, color: Colors.white))
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  height: 180.h,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        child: Container(
                          width: 500,
                          height: 100,
                          color: Colors.redAccent,
                        ),
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width / 3.2,
                        top: 25,
                        child: GestureDetector(
                          onTap: _selectImage,
                          child: CircleAvatar(
                            radius: MediaQuery.of(context).size.width / 5,
                            backgroundColor: Colors.grey[200],
                            backgroundImage: _myUser.profilePicture != ''
                                ? CachedNetworkImageProvider(
                                    _myUser.profilePicture ?? '')
                                : AssetImage('Assets/images/Avatar.png')
                                    as ImageProvider<Object>,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Change Profile Imagae',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(children: [
                  MyTextField(
                    controller: _nameController,
                    hint: 'name',
                    keyboardtype: TextInputType.name,
                    obscure: false,
                    selection: true,
                  ),
                    MyTextField(
                    controller: _profession,
                    hint: 'Edit Profession',
                    keyboardtype: TextInputType.name,
                    obscure: false,
                    selection: true,
                  ),
                  MyTextField(
                    controller: _bioController,
                    hint: 'bio',
                    keyboardtype: TextInputType.name,
                    obscure: false,
                    selection: true,
                  ),
                
                  Padding(
                    padding: EdgeInsets.only(bottom: 15.h, left: 150.w),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: //Text("hbhbh"),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton(
                                                    value: dropdownvalue,
                                                    icon: const Icon(Icons.arrow_drop_down),
                                                    onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                                                    },
                                                    items: SocialMediaLinks.map<DropdownMenuItem<String>>(
                              (String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                                                    }).toList(),
                                                  ),
                          ),
                    ),
                  ),
                  (dropdownvalue != 'Social Media Links')
                      ? Column(
                          children: [
                            MyTextField(
                                validator: (value) {
                                  if (value!.length < 3) {
                                    Text("Please Enter Link");
                                  }
                                },
                                controller: _link,
                                hint: 'Enter Link',
                                obscure: false,
                                selection: true,
                                keyboardtype: TextInputType.name),
                            MyButton(
                                onTap: () {
                                  // addNewSocialMediaLink(
                                  //     dropdownvalue, _link.text);
                                  
                                    setState(() {
                                      if(dropdownvalue=='Linkedin'){
                                        _linkedinLink=_link.text;
  _LinkedAdded=true;
                                      }
                                      else if(dropdownvalue=="Instagram"){
                                         _instagramLink=_link.text;
                                        _InstagramAdded=true;
                                      }   else if(dropdownvalue=="Youtube"){
                                         _YoutubeLink=_link.text;
                                        _YoutubeAdded=true;
                                      }
                                       else if(dropdownvalue=="Twitter"){
                                         _TwitterLink=_link.text;
                                        _TwitterAdded=true;
                                      }
                                        else if(dropdownvalue=="Facebook"){
                                         _FacebookLink=_link.text;
                                        _FacebookAdded=true;
                                      }
                                        else if(dropdownvalue=="GitHub"){
                                         _GithubLink=_link.text;
                                        _GithubAdded=true;
                                      }
});
                                  
                                  print(socialMediaLinks);
                                },
                                text: "add",
                                color: Colors.redAccent),
                                SizedBox(
                                  height: 10.h,
                                )
                          ],
                        )
                      : SizedBox(),

_LinkedAdded?  SocialMediaLinkMethod('Linkedin','Assets/images/linkedin.png',_linkedinLink,_hideLinkedIn):SizedBox(),
_InstagramAdded?  SocialMediaLinkMethod('Instagram','Assets/images/instagram.png',_instagramLink,_hideinstagram):SizedBox(),
_YoutubeAdded?  SocialMediaLinkMethod('Youtube','Assets/images/youtube.png',_YoutubeLink,_hideYoutube):SizedBox(),
 _TwitterAdded?  SocialMediaLinkMethod('Twitter','Assets/images/twitter.png',_TwitterLink,_hideTwitter):SizedBox(), 
  _FacebookAdded?  SocialMediaLinkMethod('Facebook','Assets/images/facebook.png',_FacebookLink,_hideFacebook):SizedBox(), 
    _GithubAdded?  SocialMediaLinkMethod('GitHub','Assets/images/github.png',_GithubLink,_hideGithub):SizedBox(), 
                  //          SizedBox(
                  //           height: 200.h,
                  // child: ListView.builder(

                  //   itemCount: socialMediaLinks.length,
                  //   itemBuilder: (context, index) {
                  //     String key = socialMediaLinks.keys.elementAt(index);
                  //     return ListTile(
                  //       title: Text(key),
                  //       subtitle: Text(socialMediaLinks[key]!),
                  //       trailing: IconButton(
                  //         icon: Icon(Icons.delete),
                  //         onPressed: () {
                  //           deleteSocialMediaLink(key);
                  //         },
                  //       ),
                  //     );
                  //   },
                  // ),
                  // ),

                  
                   MyTextField(
                    controller: _contact,
                    hint: 'Contact',
                    keyboardtype: TextInputType.name,
                    obscure: false,
                    selection: true,
                  ),
                MyTextField(
                    controller: _emailController,
                    hint: 'email',
                    keyboardtype: TextInputType.name,
                    obscure: false,
                    selection: true,
                  ),
                  
                  MyTextField(
                    controller: _Address,
                    hint: 'Address',
                    keyboardtype: TextInputType.name,
                    obscure: false,
                    selection: true,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15.h,),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: //Text("hbhbh"),
                          Padding(
                            padding:  EdgeInsets.only(left: 100.w),
                            child: DropdownButton(
                                                    value: dropdownvalue1,
                                                    icon: const Icon(Icons.arrow_drop_down),
                                                    onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue1 = newValue!;
                            });
                                                    },
                                                    items: WebPortResume.map<DropdownMenuItem<String>>(
                              (String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                                                    }).toList(),
                                                  ),
                          ),
                    ),
                  ),
                  (dropdownvalue1 != 'Website/Portfolio/Resume')
                      ? Column(
                          children: [
                            MyTextField(
                                validator: (value) {
                                  if (value!.length < 3) {
                                    Text("Website/Portfolio/Resume");
                                  }
                                },
                                controller: _link,
                                hint: 'Enter Link',
                                obscure: false,
                                selection: true,
                                keyboardtype: TextInputType.name),
                            MyButton(
                                onTap: () {
                                  // addNewSocialMediaLink(
                                  //     dropdownvalue, _link.text);
                                  
                                    setState(() {
                                      if(dropdownvalue1=='Website'){
                                        _websiteLink=_link.text;
  _website=true;
                                      }
                                      else if(dropdownvalue1=="Portfolio"){
                                         _PortfolioLink=_link.text;
                                        _portfolio=true;
                                      }   else if(dropdownvalue1=="Resume"){
                                         _ResumeLink=_link.text;
                                        _Resume=true;
                                      }
                                      
});
                                  
                                  print(socialMediaLinks);
                                },
                                text: "add",
                                color: Colors.redAccent),
                                SizedBox(
                                  height: 10.h,
                                )
                          ],
                        )
                      : SizedBox(),


_website?  SocialMediaLinkMethod('Website','Assets/images/web.png',_websiteLink,_hideWeb):SizedBox(),
_portfolio?  SocialMediaLinkMethod('Portfolio','Assets/images/portfolio.png',_PortfolioLink,_hidePortfolio):SizedBox(),
_Resume?  SocialMediaLinkMethod('Resume','Assets/images/resume.png',_ResumeLink,_hideResume):SizedBox(),
  Padding(
                    padding: EdgeInsets.only(bottom: 15.h,),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: //Text("hbhbh"),
                          Row(
                            children: [
                              Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 10.w),
                                child: Text("Current Job Status:",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold
                                ),
                                ),
                              ),
                              Padding(
                                padding:  EdgeInsets.only(left: 20.w),
                                child: DropdownButton(
                                                        value: dropdownvalue2,
                                                        icon: const Icon(Icons.arrow_drop_down),
                                                        onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue2 = newValue!;
                                });
                                                        },
                                                        items: currentJob.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                                                        }).toList(),
                                                      ),
                              ),
                            ],
                          ),
                    ),
                  ),
                
                   Padding(
                    padding: EdgeInsets.only(bottom: 15.h,),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: //Text("hbhbh"),
                          Row(
                            children: [
                              Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 10.w),
                                child: Text("Are You Looking For Internship:",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold
                                ),
                                ),
                              ),
                              Padding(
                                padding:  EdgeInsets.only(left: 10.w),
                                child: DropdownButton(
                                                        value: dropdownvalue3,
                                                        icon: const Icon(Icons.arrow_drop_down),
                                                        onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue3 = newValue!;
                                });
                                                        },
                                                        items: Internship.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                                                        }).toList(),
                                                      ),
                              ),
                            ],
                          ),
                    ),
                  ),  
                      
 Padding(
                    padding: EdgeInsets.only(bottom: 15.h,),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: //Text("hbhbh"),
                          Row(
                            children: [
                              Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 10.w),
                                child: Text("Type of Internship looking for:",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold
                                ),
                                ),
                              ),
                              Padding(
                                padding:  EdgeInsets.only(left: 10.w),
                                child: DropdownButton(
                                                        value: dropdownvalue4,
                                                        icon: const Icon(Icons.arrow_drop_down),
                                                        onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue4 = newValue!;
                                });
                                                        },
                                                        items: TypeOfInternShip.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                                                        }).toList(),
                                                      ),
                              ),
                            ],
                          ),
                    ),
                  ),      

                ]),
              ),
              SizedBox(height: 15.h),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Row(
              //       children: [
              //         Checkbox(
              //           value: !_hideEmail,
              //           onChanged: (value) {
              //             setState(() {
              //               _hideEmail = !_hideEmail;
              //             });
              //           },
              //         ),
              //         Text(_hideEmail ? 'Show Email' : 'Hide Email',
              //             style: TextStyle(
              //                 fontSize:
              //                     MediaQuery.of(context).size.width * 0.03)),
              //       ],
              //     ),
              //     Row(
              //       children: [
              //         Checkbox(
              //           value: !_hidePhone,
              //           onChanged: (value) {
              //             setState(() {
              //               _hidePhone = !_hidePhone;
              //             });
              //           },
              //         ),
              //         Text(_hidePhone ? 'Show Phone' : 'Hide Phone',
              //             style: TextStyle(
              //                 fontSize:
              //                     MediaQuery.of(context).size.width * 0.03)),
              //       ],
              //     ),
              //     Row(
              //       children: [
              //         Checkbox(
              //           value: !_hideLinkedIn,
              //           onChanged: (value) {
              //             setState(() {
              //               _hideLinkedIn = !_hideLinkedIn;
              //             });
              //           },
              //         ),
              //         Text(_hideLinkedIn ? 'Show LinkedIn' : 'Hide LinkedIn',
              //             style: TextStyle(
              //                 fontSize:
              //                     MediaQuery.of(context).size.width * 0.03)),
              //       ],
              //     ),
              //   ],
              // ),
              // Row(
              //   children: [
              //     Checkbox(
              //       value: !_hideinstagram,
              //       onChanged: (value) {
              //         setState(() {
              //           _hideinstagram = !_hideinstagram;
              //         });
              //       },
              //     ),
              //     Text(_hideLinkedIn ? 'Show instagram' : 'Hide instagram',
              //         style: TextStyle(
              //             fontSize: MediaQuery.of(context).size.width * 0.03)),
              //   ],
              // ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: MyButton(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          final currentUserrUid =
                              FirebaseAuth.instance.currentUser!.uid;
                          final usersCollection =
                              FirebaseFirestore.instance.collection('users');
                          print(currentUserrUid);
                          QuerySnapshot querySnapshot = await usersCollection
                              .where('userId', isEqualTo: currentUserrUid)
                              .get();

                          if (querySnapshot.size == 1) {
                            String documentId = querySnapshot.docs[0].id;

                            await usersCollection.doc(documentId).update({
                              'name': _nameController.text.toLowerCase(),
                              'email': _emailController.text,
                              'bio': _bioController.text,
                              'linkedinLink': _linkController.text,
                              'showEmail': _hideEmail,
                              'showPhone': _hidePhone,
                              'showInstagram': _hideinstagram,
                              'instagramLink': _instagramcontroller.text,
                              'showLinkedin': _hideLinkedIn,
                              'achievements': _achievements.text,
                            });

                            if (_image != null) {
                              String profileImageUrl =
                                  await _uploadProfileImage(
                                      currentUserrUid, _image!);
                              await usersCollection
                                  .doc(documentId)
                                  .update({'profilePicture': profileImageUrl});
                            }

                            final userFetchController =
                                Provider.of<UserFetchController>(context,
                                    listen: false);
                            userFetchController.fetchUserData();

                            Navigator.pop(context);
                          } else {
                            print(
                                'User document not found for phone number: $currentUserrUid');
                          }
                        } catch (e) {
                          print('Error updating user profile: $e');
                        }
                      }
                    },
                    text: 'Update',
                    color: Colors.black54),
              )
            ],
          ),
        ),
      ),
    );
  }

  Padding SocialMediaLinkMethod(String title,String imgpath, String link,bool hide) {
    return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.r),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.r)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                height: 35,
                                imgpath,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(link),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                  value:
                  (title=='Linkedin')?!_hideLinkedIn:
                  (title=='Instagram')?!_hideinstagram:
                   (title=='Youtube')?!_hideYoutube:
                    (title=='Twitter')?!_hideTwitter:
                    (title=='Facebook')?!_hideFacebook:
                    (title=='GitHub')?!_hideGithub:
                    (title=='Website')?!_hideWeb:
                    (title=='Portfolio')?!_hidePortfolio:
                    !_hideResume

                    ,
                  onChanged: (value) {
                    setState(() {
                      if(title=='Linkedin')
                      _hideLinkedIn= !_hideLinkedIn;
                      else if(title=='Instagram')
                      _hideinstagram=!_hideinstagram;
                       else if(title=='Youtube')
                      _hideYoutube=!_hideYoutube;
                       else if(title=='Twitter')
                      _hideTwitter=!_hideTwitter;
                       else if(title=='Facebook')
                      _hideFacebook=!_hideFacebook;
                       else if(title=='GitHub')
                      _hideGithub=!_hideGithub;
                      else if(title=='Website')
                      _hideWeb=!_hideWeb;
                      else if(title=='Portfolio')
                      _hidePortfolio=!_hidePortfolio;
                      else if(title=='Resume')
                      _hideResume=!_hideResume;

                    });
                  },
                ),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
  if(title=="Linkedin"){
    
    _LinkedAdded=false;
  
  }
   else if(title=="Instagram"){
       
      _InstagramAdded=false;
    }   else if(title=="Youtube"){
     
      _YoutubeAdded=false;
    }
     else if(title=="Twitter"){
      
      _TwitterAdded=false;
    }
      else if(title=="Facebook"){
      
      _FacebookAdded=false;
    }
      else if(title=="GitHub"){
      
      _GithubAdded=false;
    }
     else if(title=="Website"){
      
      _website=false;
    }
     else if(title=="Portfolio"){
      
      _portfolio=false;
    }
     else if(title=="Resume"){
      
      _Resume=false;
    }
});


                                  }, child: Icon(Icons.delete)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
  }
}
