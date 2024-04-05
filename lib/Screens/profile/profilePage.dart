import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:onelink/Auth/SignUp.dart';
import 'package:onelink/Screens/profile/editProfile.dart';
import 'package:provider/provider.dart';
import '../../Get/fetchdata.dart';
import '../../Models/xx.dart';
import '../../components/myButton.dart';
import '../../constants/constants.dart';
import 'package:intl/intl.dart';

class ProfilePageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userFetchController = Provider.of<UserFetchController>(context);

    return Scaffold(
      appBar:AppBar(backgroundColor: Color(0xFF888BF4),title: Text("Profile",style: GoogleFonts.aladin(fontSize: MediaQuery.of(context).size.width*0.05)),) ,
      body: userFetchController.isDataFetched
          ? buildProfileBody(userFetchController.myUser, context)
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildProfileBody(UserModel1 myUser, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  Text(
                    "posts: ${myUser.postCount ?? '0'}",
                    style: GoogleFonts.aladin(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ), Text(
                    "Jobs Created: ${myUser.JobCount ?? '0'}",
                    style: GoogleFonts.aladin(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ), Text(
                    "Events Created: ${myUser.EventCount ?? '0'}",
                    style: GoogleFonts.aladin(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],),
            ),
          ),
          Container(
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(
                    myUser.profilePhotoUrl ??
                        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png',
                  ),
                ),
                Text(
                  myUser.name ?? '',
                  style: GoogleFonts.aladin(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),
          buildProfileInfo(Bootstrap.phone, myUser.phoneNumber ?? ''),
          buildProfileInfo(Bootstrap.envelope, myUser.email ?? ''),
          buildProfileInfo(
            Bootstrap.calendar_date,
            myUser.dateOfbirth != null
                ? DateFormat('yyyy-MM-dd').format(DateTime.parse(myUser.dateOfbirth!))
                : '',
          ),
          SizedBox(height: 16),
          MyButton(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return EditProfilePage();
              }));
            },
            text: 'Edit Profile',
            color:Color(0xFF888BF4),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget buildProfileInfo(IconData icon, dynamic data) {
    String phoneNumber = data.toString(); // Convert data to string
    return Card(
      color: Colors.grey[250],
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          phoneNumber,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}