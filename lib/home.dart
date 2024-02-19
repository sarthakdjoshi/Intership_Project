import 'package:flutter/material.dart';
import 'package:pratice/Screen/Category/categoryscreen.dart';
import 'package:pratice/Screen/allUser.dart';
import 'package:pratice/Screen/banner.dart';
import 'package:pratice/Screen/order.dart';
import 'package:pratice/Screen/product.dart';
import 'package:pratice/Screen/subcategory.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List Names = [
    "Category",
    "Subcategory",
    "Product",
    "Banners",
    "Users Order",
    "All Users"
  ];
  List images = [
    Image.asset("assets/Icons/Category.png"),
    Image.asset("assets/Icons/sub-category.png"),
    Image.asset("assets/Icons/Product.png"),
    Image.asset("assets/Icons/Banner.png"),
    Image.asset("assets/Icons/order.png"),
    Image.asset("assets/Icons/user.png"),
  ];
  List nav = [
    const Category_Screen(),
    const Sub_Category(),
    const Product(),
    const Banners(),
    const Order(),
    const All_Users()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Welcome"),
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
        body: Column(children: [
          const Text(
            "E-Commerce",
            style: TextStyle(
                fontSize: 40,
                color: Colors.indigo,
                fontWeight: FontWeight.w900),
          ),
          Expanded(
              child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0,
                  children: List.generate(6, (index) {
                    return Card(
                      color: Colors.white70,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => nav[index],));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: images[index],
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              Names[index],
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    );
                  }))),
        ]));
  }
}
