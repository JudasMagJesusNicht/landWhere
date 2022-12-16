 import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatelessWidget {
  const Profile({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 30, right: 15),
        child: ListView(
          children: [
            Text(
              'Profil konfigurieren',
              style: GoogleFonts.rubikMonoOne(color: Colors.black, fontSize: 24),
            ),
            Stack(
              children: [
                Container(
                  width: 140,
                  height: 140,
                )
              ],
            )
          ],
        ),
      )


    );
  }
}
