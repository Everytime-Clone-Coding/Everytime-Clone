import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:everytime/landingpage.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'mainpages/timetables/timetableProvider.dart';
// ignore_for_file: prefer_const_constructors

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth.instance.authStateChanges().listen((User? user) async {
    if (user != null) {
      await _addUserToDatabase(user);
    }
  });

  runApp(const MyApp());
}

Future<void> _addUserToDatabase(User user) async {
  DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');

  try {
    DatabaseEvent event = await usersRef.child(user.uid).once();
    DataSnapshot snapshot = event.snapshot;

    if (!snapshot.exists) {
      await usersRef.child(user.uid).set({
        'userId': user.uid,
      });
    }
  } catch (error) {
    print('Error adding user to database: $error');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TimeTableProvider(),
      child: GetMaterialApp(
        title: 'DanGom Life',
        home: LandingPage(),
      ),
    );
  }
}
