import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pratice/Model/Product_Model.dart';
import 'package:pratice/Screen/Product/Add_product.dart';
import 'package:pratice/Screen/Product/edit_Product.dart';

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
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Add_Product()));
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                Container(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Enter Product Name",
                      hintStyle: const TextStyle(color: Colors.indigo),
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.indigo),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream:
              FirebaseFirestore.instance.collection("Product").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || snapshot.data == null) {
                  return Text("Error:${snapshot.hasError}");
                } else {
                  final List<Product_Model> users = snapshot.data!.docs
                      .map((doc) => Product_Model.fromFirestore(doc))
                      .toList();
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      var user = users[index];
                      return Card(
                        child: Column(
                          children: [

                            Text(
                              user.product_name ?? "",
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.indigo),
                            ),
                            SizedBox(
                              height: 150, // adjust the height as per your UI requirement
                              child: Image.network(user.images[0])
                            ),
                            Text(
                              user.product_price ?? "",
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.indigo),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CupertinoButton(
                                  onPressed: () {
                                    showDialog(context: context, builder:(BuildContext context) {
                                      return AlertDialog(
                                          title: const Text("Confirm TO Delete"),
                                        content: const Text('Are you sure you want to delete this category?'),
                                        actions: [
                                          TextButton(onPressed: (){   Navigator.of(context).pop();}, child: const Text("NO")),
                                          TextButton(onPressed: (){
                                            FirebaseFirestore.instance
                                                .collection("Product")
                                                .doc(user.id)
                                                .delete();
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "${user.category} was Deleted",
                                                ),
                                                duration:
                                                const Duration(seconds: 2),
                                              ),

                                            );
                                          }, child: const Text("Yes")),

                                        ],
                                      );
                                    },);

                                  },
                                  child: const Text("Delete"),
                                ),
                                CupertinoButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Edit_Product(product: user),));
                                  },
                                  child: const Text("Update"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

