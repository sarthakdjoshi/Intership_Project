import 'package:flutter/material.dart';
import 'package:pratice/Product/Add_product.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context,MaterialPageRoute(builder: (context) => const Add_Product(),));
          }, icon: const Icon(Icons.add))
        ],
      ),
      
      body: const Center(
        child: Text("Product"),
      ),
    );
  }
}
