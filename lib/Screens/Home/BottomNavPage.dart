import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:onelink/Screens/Notifications/Notificationsd.dart';
import 'package:onelink/Tabs/EventTab/EventTab.dart';
import 'package:onelink/Tabs/JobPage/jobTAb.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onelink/Tabs/Community%20Page/CommunityTab.dart';
import 'package:onelink/Tabs/SearchTab/SearchTab.dart';
import 'package:uuid/uuid.dart';
import '../../Get/fetchdata.dart';
import '../../Tabs/FeedPaGE/FeedPage.dart';
import '../../Widgets/Drawer/drawer.dart';
import '../Add Post/adddPost.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomeTab(),
    CommunityList(),
    JobTab(),
    EventTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch user data immediately when HomeScreen is initialized
    Provider.of<UserFetchController>(context, listen: false).fetchUserData();
  }

  Uuid uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
      title:  Text("Ts Bridge Edu",style: GoogleFonts.aladin(fontSize: 15),),
        actions: [
          Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            child: IconButton(
              icon: const FaIcon(Bootstrap.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SearchPage();
                    },
                  ),
                );
              },
            ),
          ),
        ),
          Consumer<UserFetchController>(
            builder: (context, userController, _) {
              if (userController.isDataFetched) {
                // User data is fetched, you can access it here
                var myUser = userController.myUser;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    child: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.camera),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AddPostScreen(
                                uid: myUser.userId!,
                                username: myUser.name!,
                                profImage: myUser.profilePhotoUrl!,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              child: IconButton(
                icon: const FaIcon(FontAwesomeIcons.bell),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Notifications();
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex], // Use directly from the list
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        iconSize: 20,
        elevation: 1,
        items: [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.peopleGroup),
            label: 'Communiy',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesome.joget_brand),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(Clarity.event_outline_badged),
            label: 'Events',
          ),
        ],
      ),
    );
  }
}
