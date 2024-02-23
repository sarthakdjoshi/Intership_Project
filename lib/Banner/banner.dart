import 'package:flutter/material.dart';
import 'package:pratice/Banner/Add_Banner.dart';

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
        backgroundColor: Colors.indigo,
        centerTitle: true,
        actions: [
          IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Add_Banner(),)), icon: const Icon(Icons.add))
        ],
      ),
      body: const Center(
        child: Text("Banners"),
      ),
    );
  }
}
