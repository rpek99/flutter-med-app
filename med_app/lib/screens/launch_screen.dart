import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:med_app/shared/authentication.dart';
import 'login_screen.dart';
import 'event.screen.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  _LauchScreenState createState() => _LauchScreenState();
}

class _LauchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();

    Authentication auth = Authentication();
    auth.getUser().then((user) {
      MaterialPageRoute route;
      if (user != null) {
        route = MaterialPageRoute(builder: (context) => EventScreen());
      } else {
        route = MaterialPageRoute(builder: (context) => LoginScreen());
      }
      Navigator.of(context).pushReplacement(route);
    }).catchError((errorMessage) => print(errorMessage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
