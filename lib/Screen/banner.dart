import 'package:flutter/material.dart';

class Banners extends StatefulWidget {
  const Banners({super.key});

  @override
  State<Banners> createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bannerss"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Banners"),
      ),
    );
  }
}
