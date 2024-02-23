import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pratice/home.dart';
import 'package:pratice/signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var e_mail = TextEditingController();
  var pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: 200,
                    child: Image.asset("assets/Icons/Login-add.gif")),
                TextField(
                  controller: e_mail,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    hintText: "Enter Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: pass,
                  obscureText: true,
                  obscuringCharacter: "*",
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.key),
                    hintText: "Enter Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        var email = e_mail.text.trim().toString();
                        var password = pass.text.trim().toString();
                        try {
                          UserCredential user=await  FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: email, password: password);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Home(),
                                ));
                          
                        } on FirebaseAuthException catch (e) {
                          print(e.code.toString());
                          if(e.code.toString()=="channel-error"){
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter User email or password")));

                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero)),
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Dont Have Account?"),
                    const SizedBox(
                      width: 10,
                    ),
                    CupertinoButton(
                        child: const Text(
                          "Register",
                          style: TextStyle(color: Colors.indigo),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Signup(),
                              ));
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
