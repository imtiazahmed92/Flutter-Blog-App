import 'package:blog_app/app_screens/authentic_screen.dart';
import 'package:blog_app/app_screens/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Blog App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: LandingScreen(),
    );
  }
}
