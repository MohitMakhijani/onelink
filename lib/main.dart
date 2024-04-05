//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import 'package:onelink/Screens/ONboardingScreens/Onboarding.dart';
// import 'package:provider/provider.dart';
//
// import 'AuthProider.dart';
// import 'Get/fetchdata.dart';
// import 'Get/themeprovider.dart';
// import 'Screens/Home/BottomNavPage.dart';
//
//
// void main() async {
//
//   WidgetsFlutterBinding.ensureInitialized();
//   await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//   await Firebase.initializeApp(
//     options: FirebaseOptions(
//       storageBucket: "onelink-81367.appspot.com",
//       apiKey: "AIzaSyBhF1pSbNIZcHZPahbru6e4wo-CbnReWnw",
//       appId: "1:406735724106:android:4f89ba67a0bdae98a050b3",
//       messagingSenderId: "406735724106",
//       projectId: "onelink-81367",
//     ),
//   );
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => UserFetchController()),
//         ChangeNotifierProvider(create: (_) => ThemeProvider()),
//         ChangeNotifierProvider(create: (_) => AuthenticationProvider()), // Add AuthProvider here// Add AuthProvider here
//       ],
//       child: MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: Provider.of<ThemeProvider>(context).themeData,
//       debugShowCheckedModeBanner: false,
//       home: Consumer<AuthenticationProvider>(
//         builder: (context, authProvider, _) {
//           return authProvider.isLoggedIn? HomeScreen() : Onboarding();
//         },
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onelink/Auth/OTP%20SUCESS.dart';
import 'package:onelink/Auth/SignUp.dart';
import 'package:onelink/Screens/Home/BottomNavPage.dart';
import 'package:onelink/Screens/ONboardingScreens/Onboarding.dart';
import 'package:onelink/Screens/profile/SetUpProfile/setupProfilePage.dart';
import 'package:onelink/Tabs/FeedPaGE/FeedPage.dart';
import 'package:provider/provider.dart';
import 'Get/fetchdata.dart';
import 'Get/themeprovider.dart';



void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: FirebaseOptions(
      storageBucket: "onelink-81367.appspot.com",
      apiKey: "AIzaSyBhF1pSbNIZcHZPahbru6e4wo-CbnReWnw",
      appId: "1:406735724106:android:4f89ba67a0bdae98a050b3",
      messagingSenderId: "406735724106",
      projectId: "onelink-81367",
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserFetchController()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child:  MyApp(),
    ),
  );
}
class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var isLoggedIn = false;
  var auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    checkIfLoggedIn();
  }

  void checkIfLoggedIn() {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLoggedIn = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).themeData,
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? HomeScreen( ) : Onboarding(),
    );
  }
}