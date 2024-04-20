import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onelink/Screens/Home/BottomNavPage.dart';
import 'package:onelink/Screens/ONboardingScreens/Onboarding.dart';
import 'package:provider/provider.dart';
import 'Get/fetchdata.dart';
import 'Get/themeprovider.dart';
import 'components/Notifications.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
  NotificationServices notificationServices = NotificationServices();


  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.foregroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      if (kDebugMode) {
        print('device token');
        print(value);
      }

    UserFetchController();
    checkIfLoggedIn();
      });
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
      home: isLoggedIn ? HomeScreen() : Onboarding(),
    );
  }
}