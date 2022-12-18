// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoggedInScreen extends StatefulWidget {
  const LoggedInScreen({Key? key}) : super(key: key);

  @override
  _LoggedInScreenState createState() => _LoggedInScreenState();
}

class _LoggedInScreenState extends State<LoggedInScreen> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 130,
                height: 130,
                child: Image(image: AssetImage('./assets/landWhereLogoFull.png')),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Eingeloggt als:',
              style: GoogleFonts.rubikMonoOne(color: Colors.black),
            ),
            Text(
              '${user.email!}',
              style: GoogleFonts.rubikMonoOne(color: Colors.black),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
              ),
              child: Text(
                'Beginne deine Reise',
                style: GoogleFonts.rubikMonoOne(color: Colors.black),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
              ),
              child: Text(
                'Ausloggen',
                style: GoogleFonts.rubikMonoOne(color: Colors.black),
              ),
            )
          ],
        )),
      ),
    );
  }
}
