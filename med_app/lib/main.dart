import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:med_app/screens/event.screen.dart';
import 'package:med_app/screens/launch_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future testData() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    var data = await db.collection('event_details').get();
    var details = data.docs.toList();
    details.forEach((e) {
      print(e.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    testData();

    return MaterialApp(
      title: 'Events',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: LaunchScreen(),
    );
  }
}
