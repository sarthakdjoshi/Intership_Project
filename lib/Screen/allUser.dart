import 'package:flutter/material.dart';

class All_Users extends StatefulWidget {
  const All_Users({super.key});

  @override
  State<All_Users> createState() => _All_UsersState();
}

class _All_UsersState extends State<All_Users> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All_User"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: const Center(
        child: Text("All-Users"),
      ),
    );
  }
}
