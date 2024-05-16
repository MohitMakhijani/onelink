import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onelink/Theme.dart';
import 'package:onelink/components/myTextField.dart';

class JoinCommunityForm extends StatefulWidget {
  final String communityId;
  final String userId;
  final int communityIndex; // Added communityIndex to determine the form

  JoinCommunityForm({
    required this.communityId,
    required this.userId,
    required this.communityIndex,
  });

  @override
  State<JoinCommunityForm> createState() => _JoinCommunityFormState();
}

class _JoinCommunityFormState extends State<JoinCommunityForm> {
  final _formKey = GlobalKey<FormState>();
  String? _starupRegistered;
  String? _selectedGender;
  String? _selectedInfluencerType;
  String? _selectedInfluencerFullorpartTime;
  //Othres TextEditing Fields
  TextEditingController _OthersnameController = TextEditingController();
  TextEditingController _OthersemailController = TextEditingController();
  TextEditingController _OthersphoneController = TextEditingController();
  TextEditingController OthersSkillsController = TextEditingController(); 
  TextEditingController OthersAddressController = TextEditingController();
  TextEditingController OthersPassedOutOrNotController =TextEditingController();
  TextEditingController OthersYearOfStudyController = TextEditingController();
  TextEditingController OthersAchivementController = TextEditingController();
  TextEditingController OthersGoalsController = TextEditingController();
  TextEditingController _OthersGraduationController = TextEditingController();
  TextEditingController _OthersCollegeController = TextEditingController();
  TextEditingController _OthersBranchController = TextEditingController();
  TextEditingController _OthersLinkedinPersonalController =TextEditingController();
 
 //Student TextEditing Fields
  TextEditingController _StudentnameController = TextEditingController();
  TextEditingController _StudentemailController = TextEditingController();
  TextEditingController _StudentphoneController = TextEditingController();
   TextEditingController StudentAddressController = TextEditingController();
  TextEditingController StudentSkillsController = TextEditingController();
  TextEditingController StudentPassedOutOrNotController =TextEditingController();
  TextEditingController StudentYearOfStudyController = TextEditingController();
  TextEditingController StudentAchivementController = TextEditingController();
  TextEditingController StudentGoalsController = TextEditingController();
  TextEditingController StudentGraduationController = TextEditingController();
  TextEditingController StudentCollegeController = TextEditingController();
  TextEditingController StudentBranchController = TextEditingController();
  TextEditingController StudentLinkedinPersonalController =TextEditingController();


//Investors TextEditing Fields
  TextEditingController _InvestorsnameController = TextEditingController();
  TextEditingController _InvestorsemailController = TextEditingController();
  TextEditingController _InvestorsphoneController = TextEditingController();
   TextEditingController _InvestorsAddressController = TextEditingController();
  TextEditingController _InvestorsSkillsController = TextEditingController();
  TextEditingController _InvestorsPassedOutOrNotController =TextEditingController();
  TextEditingController _InvestorsYearOfStudyController = TextEditingController();
  TextEditingController _InvestorsAchivementController = TextEditingController();
  TextEditingController _InvestorsGoalsController = TextEditingController();
  TextEditingController _InvestorsGraduationController = TextEditingController();
  TextEditingController _InvestorsCollegeController = TextEditingController();
  TextEditingController _InvestorsBranchController = TextEditingController();
  TextEditingController _InvestorsLinkedinPersonalController =TextEditingController();

  TextEditingController _influencerResourceRequiredController =
      TextEditingController();

  TextEditingController _influencernameController = TextEditingController();

  TextEditingController _influenceremailController = TextEditingController();

  TextEditingController _influencerphoneController = TextEditingController();
  TextEditingController _influencerLinkedinPersonalController =
      TextEditingController();
  TextEditingController _influencerinstagramPersonalController =
      TextEditingController();
  TextEditingController _influencerSocialMediaController =
      TextEditingController();
  //TextEditingController _StartupsGroupProfessionController = TextEditingController();
  TextEditingController _StartupsGroupnameController = TextEditingController();

  TextEditingController _StartupsGroupemailController = TextEditingController();

  TextEditingController _StartupsGroupphoneController = TextEditingController();

  TextEditingController _StartupsGroupProfessionController =
      TextEditingController();

  TextEditingController _StartupsGroupIdeaStageController =
      TextEditingController();

  TextEditingController _StartupsGroupCompanyNameController =
      TextEditingController();

  TextEditingController _StartupsGroupCompanyWebController =
      TextEditingController();

  TextEditingController _StartupsGroupDesignationController =
      TextEditingController();

  TextEditingController _StartupsGroupBussinessNameController =
      TextEditingController();
  TextEditingController _StartupsGroupNoofBussinessController =
      TextEditingController();
  TextEditingController _StartupsGroupLinkedinPersonalController =
      TextEditingController();
  TextEditingController _StartupsGroupLinkedinCompanyController =
      TextEditingController();
  TextEditingController _StartupsGroupInstagramPersonalController =
      TextEditingController();
  TextEditingController _StartupsGroupInstagramCompanyController =
      TextEditingController();
  TextEditingController _graduationTypeController = TextEditingController();

  TextEditingController _influencerAgeController = TextEditingController();

  TextEditingController _influencerProfessionController =
      TextEditingController();

  TextEditingController _yearController = TextEditingController();

  TextEditingController _cityController = TextEditingController();

  TextEditingController _stateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Widget> formFields = [];

    if (widget.communityIndex == 1) {
      formFields = [
        TextMethod("Full name"),
        MyTextField(
          controller: _StartupsGroupnameController,
          hint: 'Your Name',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        TextMethod('Gender'),
        DropDownMethod(['Male', 'Female', 'Others'], _selectedGender),
        TextMethod("Email"),

        //SizedBox(height: 12),
        MyTextField(
          controller: _StartupsGroupemailController,
          hint: 'Email',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            // Add email validation if needed
            return null;
          },
        ),
        TextMethod("Contact"),
        MyTextField(
          controller: _StartupsGroupphoneController,
          hint: 'Contact',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            // Add phone validation if needed
            return null;
          },
        ),
        TextMethod("Your Profession"),
        MyTextField(
          controller: _StartupsGroupProfessionController,
          hint: 'Ex:Upcoming entrepreneur',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your graduation type';
            }
            return null;
          },
        ),
        TextMethod(
            "You are a Entrepreneur and looking towards Build a new startup what was the stage it is in ?"),
        // Add more fields for index 1
        MyTextField(
          controller: _StartupsGroupIdeaStageController,
          hint: 'Idea stage',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your graduation type';
            }
            return null;
          },
        ),
        TextMethod(
            'If you are a startup founder, your Company/Organisation name ?'),
        MyTextField(
          controller: _StartupsGroupCompanyNameController,
          hint: 'message',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your graduation type';
            }
            return null;
          },
        ),
        TextMethod('Company Website'),
        MyTextField(
          controller: _StartupsGroupCompanyWebController,
          hint: 'company',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your graduation type';
            }
            return null;
          },
        ),
        TextMethod('Your Designation in company ?'),
        MyTextField(
          controller: _StartupsGroupDesignationController,
          hint: 'designation',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your graduation type';
            }
            return null;
          },
        ),
        TextMethod('Nature of Business ?'),
        MyTextField(
          controller: _StartupsGroupBussinessNameController,
          hint: 'business',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your graduation type';
            }
            return null;
          },
        ),
        TextMethod('Nature of Business ?'),
        MyTextField(
          controller: _StartupsGroupBussinessNameController,
          hint: 'business',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your graduation type';
            }
            return null;
          },
        ),
        TextMethod('Is your Startup Registered ?'),
        DropDownMethod(
            ['YES', 'NO', 'Registration is on process', 'Will register later'],
            _starupRegistered),
        TextMethod('Is your startup Revenue Generating ?'),
        DropDownMethod([
          'YES',
          'NO',
          'Others',
        ], _starupRegistered),
        TextMethod('Total No.of Employee\'s'),
        MyTextField(
          controller: _StartupsGroupNoofBussinessController,
          hint: 'Total No.of Bussiness',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your graduation type';
            }
            return null;
          },
        ),
        TextMethod('LinkedIn(Personal)'),
        MyTextField(
          controller: _StartupsGroupLinkedinPersonalController,
          hint: 'linkedin',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your graduation type';
            }
            return null;
          },
        ),
        TextMethod('LinkedIn(Company page)'),
        MyTextField(
          controller: _StartupsGroupLinkedinCompanyController,
          hint: 'linkedin',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your graduation type';
            }
            return null;
          },
        ),
        TextMethod('Instagram account(Personal)*'),
        MyTextField(
          controller: _StartupsGroupInstagramPersonalController,
          hint: 'instagram',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your graduation type';
            }
            return null;
          },
        ),
        TextMethod('Instagram Account(Company page)'),
        MyTextField(
          controller: _StartupsGroupInstagramCompanyController,
          hint: 'instagram',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your graduation type';
            }
            return null;
          },
        ),

        // ...
      ];
    } else if (widget.communityIndex == 2) {
      formFields = [
        TextMethod("Full Name"),
        MyTextField(
          controller: _influencernameController,
          hint: 'name',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        TextMethod('Gender'),
        DropDownMethod(['Male', 'Female', 'Others'], _selectedGender),
        TextMethod("Email"),
        MyTextField(
          controller: _influenceremailController,
          hint: 'Email',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            // Add email validation if needed
            return null;
          },
        ),
        TextMethod("Contact"),
        MyTextField(
          controller: _influencerphoneController,
          hint: 'Contact',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your contact phone number';
            }
            // Add phone validation if needed
            return null;
          },
        ),
        TextMethod('Age'),
        MyTextField(
          controller: _influencerAgeController,
          hint: 'age',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your organization/company name';
            }
            return null;
          },
        ),
        TextMethod('Present Profession'),
        MyTextField(
          controller: _influencerProfessionController,
          hint: 'Profession',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('Influencer\'s Type'),
        DropDownMethod(['New', 'Old', 'Others'], _selectedInfluencerType),
        TextMethod("Are you a full time/part time influencer"),
        DropDownMethod([
          'Full time',
          'Part Time',
        ], _selectedInfluencerFullorpartTime),

        TextMethod(
            'If you are a upcoming influencer, what are the resources you required ?'),
        MyTextField(
          controller: _influencerResourceRequiredController,
          hint: 'Resource you Required',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('LinkedIn Account'),
        MyTextField(
          controller: _influencerLinkedinPersonalController,
          hint: 'linkedin',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your graduation type';
            }
            return null;
          },
        ),
        TextMethod('Instagram Account'),
        MyTextField(
          controller: _influencerinstagramPersonalController,
          hint: 'instagram',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your graduation type';
            }
            return null;
          },
        ),
        TextMethod('Any other social media accounts'),
        MyTextField(
          controller: _influencerSocialMediaController,
          hint: 'SocialMedia',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your graduation type';
            }
            return null;
          },
        ),

        // Add more fields for index 2
        // ...
      ];
    } else if (widget.communityIndex == 3) {
      formFields = [
        TextMethod("Full Name"),
        MyTextField(
          controller: _OthersnameController,
          hint: 'name',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        TextMethod('Gender'),
        DropDownMethod(['Male', 'Female', 'Others'], _selectedGender),
        TextMethod("Email"),
        MyTextField(
          controller: _OthersemailController,
          hint: 'Email',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            // Add email validation if needed
            return null;
          },
        ),
        TextMethod("Contact"),
        MyTextField(
          controller: _OthersphoneController,
          hint: 'Contact',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your contact phone number';
            }
            // Add phone validation if needed
            return null;
          },
        ),
        TextMethod('Address'),
        MyTextField(
          controller: OthersAddressController,
          hint: 'Enter Your Address',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your organization/company name';
            }
            return null;
          },
        ),
        TextMethod('Graduation Type'),
        MyTextField(
          controller: _OthersGraduationController,
          hint: 'graduation',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('College/University'),
        MyTextField(
          controller: _OthersCollegeController,
          hint: 'college',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('Branch'),
        MyTextField(
          controller: _OthersBranchController,
          hint: 'branch',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('Year Of Study'),
        MyTextField(
          controller: OthersYearOfStudyController,
          hint: 'Year Of Study',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('Pursuing/Passed'),
        MyTextField(
          controller: OthersPassedOutOrNotController,
          hint: 'Pursuing/Passed Year Passed out',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('Skills'),
        MyTextField(
          controller: OthersSkillsController,
          hint: 'skills',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),

        TextMethod('Achivements'),
        MyTextField(
          controller: OthersAchivementController,
          hint: 'Enter your Achivements',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('Goal'),
        MyTextField(
          controller: OthersGoalsController,
          hint: 'Enter your Goal',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('LinkedIn Account'),
        MyTextField(
          controller: _OthersLinkedinPersonalController,
          hint: 'linkedin',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your graduation type';
            }
            return null;
          },
        ),

        // Add more fields for index 2
        // ...
      ];
    } else if (widget.communityIndex == 4) {
      formFields = [
        TextMethod("Full Name"),
        MyTextField(
          controller: _InvestorsnameController,
          hint: 'name',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        TextMethod('Gender'),
        DropDownMethod(['Male', 'Female', 'Others'], _selectedGender),
        TextMethod("Email"),
        MyTextField(
          controller: _InvestorsemailController,
          hint: 'Email',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            // Add email validation if needed
            return null;
          },
        ),
        TextMethod("Contact"),
        MyTextField(
          controller: _InvestorsphoneController,
          hint: 'Contact',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your contact phone number';
            }
            // Add phone validation if needed
            return null;
          },
        ),
        TextMethod('Address'),
        MyTextField(
          controller: _InvestorsAddressController,
          hint: 'Enter Your Address',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your organization/company name';
            }
            return null;
          },
        ),
        TextMethod('Graduation Type'),
        MyTextField(
          controller: _InvestorsGraduationController,
          hint: 'graduation',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('College/University'),
        MyTextField(
          controller: _InvestorsCollegeController,
          hint: 'college',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('Branch'),
        MyTextField(
          controller: _InvestorsBranchController,
          hint: 'branch',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('Year Of Study'),
        MyTextField(
          controller: _InvestorsYearOfStudyController,
          hint: 'Year Of Study',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('Pursuing/Passed'),
        MyTextField(
          controller: _InvestorsPassedOutOrNotController,
          hint: 'Pursuing/Passed Year Passed out',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('Skills'),
        MyTextField(
          controller: _InvestorsSkillsController,
          hint: 'skills',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),

        TextMethod('Achivements'),
        MyTextField(
          controller: _InvestorsAchivementController,
          hint: 'Enter your Achivements',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('Goal'),
        MyTextField(
          controller: _InvestorsGoalsController,
          hint: 'Enter your Goal',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('LinkedIn Account'),
        MyTextField(
          controller: _InvestorsLinkedinPersonalController,
          hint: 'linkedin',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your graduation type';
            }
            return null;
          },
        ),

        // Add more fields for index 2
        // ...
      ];
    } else if (widget.communityIndex == 5) {
      formFields = [
        TextMethod("Full Name"),
        MyTextField(
          controller: _StudentnameController,
          hint: 'name',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.name,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        TextMethod('Gender'),
        DropDownMethod(['Male', 'Female', 'Others'], _selectedGender),
        TextMethod("Email"),
        MyTextField(
          controller: _StudentemailController,
          hint: 'Email',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            // Add email validation if needed
            return null;
          },
        ),
        TextMethod("Contact"),
        MyTextField(
          controller: _StudentphoneController,
          hint: 'Contact',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your contact phone number';
            }
            // Add phone validation if needed
            return null;
          },
        ),
        TextMethod('Address'),
        MyTextField(
          controller: StudentAddressController,
          hint: 'Enter Your Address',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your organization/company name';
            }
            return null;
          },
        ),
        TextMethod('Graduation Type'),
        MyTextField(
          controller: StudentGraduationController,
          hint: 'graduation',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('College/University'),
        MyTextField(
          controller: StudentCollegeController,
          hint: 'college',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('Branch'),
        MyTextField(
          controller: StudentBranchController,
          hint: 'branch',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('Year Of Study'),
        MyTextField(
          controller: StudentYearOfStudyController,
          hint: 'Year Of Study',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('Pursuing/Passed'),
        MyTextField(
          controller: StudentPassedOutOrNotController,
          hint: 'Pursuing/Passed Year Passed out',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('Skills'),
        MyTextField(
          controller:StudentSkillsController,
          hint: 'skills',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),

        TextMethod('Achivements'),
        MyTextField(
          controller: StudentAchivementController,
          hint: 'Enter your Achivements',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('Goal'),
        MyTextField(
          controller: StudentGoalsController,
          hint: 'Enter your Goal',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.url,
          validator: (value) {
            // Optional field, no validation needed
            return null;
          },
        ),
        TextMethod('LinkedIn Account'),
        MyTextField(
          controller: StudentLinkedinPersonalController,
          hint: 'linkedin',
          obscure: false,
          selection: true,
          keyboardtype: TextInputType.text,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your graduation type';
            }
            return null;
          },
        ),

        // Add more fields for index 2
        // ...
      ];
    }

    return Scaffold(
      backgroundColor: AppTheme.light ? Colors.white : Colors.black,
      appBar: AppBar(
        backgroundColor: AppTheme.light ? Colors.white : Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: !AppTheme.light ? Colors.white : Colors.black,
            )),
        title: Text(
          'Join Community Form',
          style: TextStyle(
            color: !AppTheme.light ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ...formFields, // Display form fields based on community index
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: !AppTheme.light
                      ? Colors.white
                      : Colors.black, // Set the background color here
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // _joinCommunity();
                    Navigator.pop(context); // Navigate back after joining
                  }
                },
                child: Text(
                  "Join",
                  style: TextStyle(
                    color: AppTheme.light ? Colors.white : Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget DropDownMethod(List<String> list, String? eventString) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.r)),
        child: DropdownButtonFormField<String>(
            value: eventString,
            items: list.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                eventString = newValue!;
              });
            },
            decoration: InputDecoration(
              hintText: '  Select Option',
              //prefixIcon: Icon(Icons.color_lens),
            ),
            validator: (value) {
              if (_StartupsGroupBussinessNameController == '  Select Option') {
                if (value == null) {
                  return 'Please select a valid Option';
                }
              }
              return null;
            }),
      ),
    );
  }

  Text TextMethod(String text) {
    return Text(
      text,
      style: TextStyle(
          color: !AppTheme.light ? Colors.white : Colors.black,
          fontFamily: 'InterRegular',
          fontSize: 15.sp,
          fontWeight: FontWeight.w600),
    );
  }

  void _joinCommunity() {
    // Save data to Firestore based on the entered data
    FirebaseFirestore.instance
        .collection('communities')
        .doc(widget.communityId)
        .update({
      'members': FieldValue.arrayUnion([widget.userId]),
    }).then((_) {
      FirebaseFirestore.instance
          .collection('communities')
          .doc(widget.communityId)
          .collection('members')
          .doc(widget.userId)
          .set({
        'name': _influencernameController.text,
        'email': _influenceremailController.text,
        'phone': _influencerphoneController.text,
        'graduationType': _graduationTypeController.text,
        'college': _influencerAgeController.text,
        'persuing': _influencerProfessionController.text,
        // Add more fields to save based on the form
        // ...
      });
    });
  }
}
