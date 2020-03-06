import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fun_chat/screens/home_screen.dart';
import 'package:fun_chat/screens/login_screen.dart';
import 'package:fun_chat/screens/profile_screen.dart';
import 'package:fun_chat/screens/signup_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget _getScreenId() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData)
          return HomeScreen();
        else
          return LoginScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fun Chat",
      theme: ThemeData(
        primaryColor: Color(0xFFFFC107),
        accentColor: Color(0xFFFEF9EB),
      ),
      home: _getScreenId(),
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
      },
    );
  }
}
