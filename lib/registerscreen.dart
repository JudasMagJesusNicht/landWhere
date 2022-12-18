// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterScreen({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  //text Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Method to pass new user to FireBase
  Future signUp() async{
    if(passwordConfirmed()){
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
    }
  }

  // Method comparing both password inputs
  bool passwordConfirmed(){
    if(_passwordController.text.trim() == _confirmPasswordController.text.trim()){
      return true;
    }else{
      return false;
    }
  }
// Method to dispose Textcontrollers
  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 130,
                      height: 130,
                      child: Image(image: AssetImage('./assets/landWhereLogoFull.png'))
                  ),
                  SizedBox(height: 10,),
                  Text(
                      'Registrieren',
                    style: GoogleFonts.rubikMonoOne(color: Colors.deepOrangeAccent, fontSize: 35),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    'Bitte gib deine Daten ein: ',
                    style: GoogleFonts.rubikMonoOne(color: Colors.black, fontSize: 14),
                  ),
                  SizedBox(height: 50,),
                  //Email TextField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            style: TextStyle(color: Colors.black54),
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle:  GoogleFonts.rubikMonoOne(color: Colors.black26),
                            ),
                          ),
                        )),
                  ),

                  SizedBox(height: 10,),

                  //Password TextField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            style: TextStyle(color: Colors.black54),
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle:  GoogleFonts.rubikMonoOne(color: Colors.black26),
                            ),
                          ),
                        )),
                  ),
                  SizedBox(height: 10,),
                  // Confirm Password TextField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextField(
                            style: TextStyle(color: Colors.black54),
                            controller: _confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              hintStyle:  GoogleFonts.rubikMonoOne(color: Colors.black26),
                            ),
                          ),
                        )),
                  ),
                  SizedBox(height: 20),

                  //LoginButton
                  ElevatedButton(
                    child: Text(
                        'Registrieren',
                      style: GoogleFonts.rubikMonoOne(color: Colors.white),
                    ),
                    onPressed: signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,

                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'I am a Member.  ',
                        style: GoogleFonts.rubikMonoOne(color: Colors.black,fontSize: 10),
                      ),
                      GestureDetector(
                        onTap: widget.showLoginPage,
                        child: Text(
                          'Login Now!',
                          style: GoogleFonts.rubikMonoOne(color: Colors.blueGrey,fontSize: 10),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}
