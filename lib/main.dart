import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat_prishu/screens/chat_screen.dart';
import 'package:flash_chat_prishu/screens/login_screen.dart';
import 'package:flash_chat_prishu/screens/registration_screen.dart';
import 'package:flash_chat_prishu/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    print('1');
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: 'AIzaSyBRCerg9fNTPQyYn1rWlsHSwkcon7vClg4',
      appId: '1:603168456338:android:a765402d584ce463bf304b',
      messagingSenderId: '603168456338',
      projectId: 'flashprisha',
    ));
  } else {
    // await Firebase.initializeApp(
    //     options: FirebaseOptions(
    //         apiKey: "your api key Found in GoogleService-info.plist",
    //         appId: "Your app id found in Firebase",
    //         messagingSenderId: "Your Sender id found in Firebase",
    //         projectId: "Your Project id found in Firebase"));
  }
  // await Firebase.initializeApp(
  //     // options: DefaultFirebaseOptions.currentPlatform,
  //     );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: WelcomeScreen(),
      initialRoute: WelcomeScreen.id,
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        WelcomeScreen.id: (context) => WelcomeScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        LoginScreen.id: (context) => LoginScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen()

        // '/': (context) => WelcomeScreen(),
        // '/login': (context) => LoginScreen(),
        // '/chat': (context) => ChatScreen(),
        // '/registration': (context) => RegistrationScreen()
      },
    );
  }
}
