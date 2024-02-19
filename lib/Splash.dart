import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pratice/home.dart';
import 'package:pratice/login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
User? user=FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 2),currentuser);
  }
void currentuser(){
    if(user==null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(),));
    }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset("assets/Icons/splash.png")),
    );
  }
}
