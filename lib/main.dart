import "dart:io";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:google_mobile_ads/google_mobile_ads.dart";
import "package:provider/provider.dart";
import 'package:rabbit/Screens/TabChannelScreen.dart';
import "Constants/NotificationClass.dart";
import "Provider/GlobalProvider.dart";
import "TabScreen.dart";
import "firebase_options.dart";

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

late FirebaseMessaging messaging;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFFd9d9ff),
    systemNavigationBarColor: Color(0xFFd9d9ff),
  ));

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  MobileAds.instance.initialize();

  runApp(const MyApp());
}

// To initialise when app is in background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final NotificationService notificationService;

  @override
  void initState() {
    addToken();
    requestPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalProvider>(create: (context) => GlobalProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: ThemeData(fontFamily: 'Poppins',
            useMaterial3: true,
            colorSchemeSeed: Color(0xFFd9d9ff),
            // filledButtonTheme: FilledButtonThemeData(
            //     style: ButtonStyle(
            //       backgroundColor:MaterialStateProperty.all(CustomColors.primary) ,
            //     ))
        ),
        debugShowCheckedModeBanner: false,
        home: TabScreen(),
      ),
    );
  }

  Future<void> addToken() async {
    final token = Platform.isAndroid ? await FirebaseMessaging.instance.getToken() : await FirebaseMessaging.instance.getAPNSToken();

    debugPrint("FCM_token $token");

    final collectionReference = FirebaseFirestore.instance.collection('notificationTokens');
    var docSnapshot = await collectionReference.doc(token).get();
    if (!docSnapshot.exists) {
      collectionReference.doc(token).set({'token': token});
      debugPrint("data_docSnapshot_added");
    } else {
      collectionReference.doc(token).update({'token': token});
      debugPrint("data_docSnapshot_Updated");
    }
  }

  void requestPermission() async {
    messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
      handleAllCases();
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      handleAllCases();
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> handleAllCases() async {
    notificationService = NotificationService();

    notificationService.initializePlatformNotifications();

    // To initialise when app is closed
    FirebaseMessaging.instance.getInitialMessage().then((message) {});

    // To initialise when app is open
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        showNotification(message);
        debugPrint("Message_payload_here_2ndCase...${message.notification?.body}");
      }
    });

    // To initialise when app is open
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   if (message.notification != null) {
    //
    //     debugPrint("Message_payload_here_Open... ${message.data}");
    //   }
    // });
  }

  void showNotification(RemoteMessage message) async {
    await notificationService.showLocalNotification(message: message);
  }
}
