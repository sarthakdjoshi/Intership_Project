import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pratice/Model/category-model.dart';
import 'package:pratice/Screen/Category/editcategory.dart';

import 'category.dart';

class Category_Screen extends StatefulWidget {
  const Category_Screen({super.key});

  @override
  State<Category_Screen> createState() => _Category_ScreenState();
}

class _Category_ScreenState extends State<Category_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Category(),
                ),
              );
            },
            child: const Icon(
              Icons.add,
              color: Colors.redAccent,
            ),
          ),
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
                      hintText: "Enter Category Name",
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
              stream: FirebaseFirestore.instance.collection("Category").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text("Error:${snapshot.hasError}");
                }
                else {
                  final List<CategoryModel> users = snapshot.data!.docs.map((
                      doc) => CategoryModel.fromFirestore(doc)).toList();
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      var user = users[index];
                      return Card(
                        child: Column(
                          children: [
                            Text(user.Category_Name,style: TextStyle(fontSize: 25,color: Colors.indigo),),
                            Image(image: NetworkImage(user.Image),width: 200,height: 200,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CupertinoButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("Category")
                                        .doc(user.id)
                                        .delete();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(
                                            "${user.Category_Name} was Deleted"),
                                          duration: const Duration(seconds: 2),));
                                  },
                                  child: const Text("Delete"),
                                ),
                                CupertinoButton(
                                  onPressed: () {
                                    Navigator.push(context,MaterialPageRoute(builder: (context) =>Edit_Category(name1: user,)));
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
