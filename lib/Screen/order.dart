import 'package:flutter/material.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: const Center(
        child: Text("Order"),
      ),
    );
  }
}
