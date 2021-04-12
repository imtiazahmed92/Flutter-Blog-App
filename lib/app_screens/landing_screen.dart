import 'package:blog_app/app_screens/authentic_screen.dart';
import 'package:blog_app/app_screens/home_screen.dart';
import 'package:blog_app/widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          User  user = snapshot.data;
          if(user == null)
            return  AuthenticScreen();
          return HomeScreen();
        }
        else  {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Center(
              child: circularProgress(),
            ),
          );
        }
      },

    );
  }
}
