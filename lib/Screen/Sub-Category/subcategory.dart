import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_admin/Screen/Sub-Category/Add_Sub-Category.dart';
import 'package:ecommerce_admin/Screen/Sub-Category/edit_sub_category.dart';

import '../../Appcolor.dart';
import '../../Model/Sub-Category-Model.dart';

class Sub_Category extends StatefulWidget {
  const Sub_Category({super.key});

  @override
  State<Sub_Category> createState() => _Sub_CategoryState();
}

class _Sub_CategoryState extends State<Sub_Category> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sub-Category"),
        backgroundColor: AppColors.lightBlue,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddSubCategoryScreen(),
                    ));
              },
              icon: const Icon(
                Icons.add,
                size: 23,
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("Sub-Category")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text("Error:${snapshot.hasError}");
                } else {
                  final List<Sub_CategoryModel> users = snapshot.data!.docs
                      .map((doc) => Sub_CategoryModel.fromFirestore(doc))
                      .toList();
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      var user = users[index];
                      return Card(
                        child: Column(
                          children: [
                            Text(
                              user.Sub_Category,
                              style: const TextStyle(
                                  fontSize: 25, color: Colors.indigo),
                            ),
                            Image(
                              image: NetworkImage(user.Image),
                              width: 200,
                              height: 200,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CupertinoButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              const Text("Confirm TO Delete"),
                                          content: const Text(
                                              'Are you sure you want to delete this category?'),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("NO")),
                                            TextButton(
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection(
                                                          "Sub-Category")
                                                      .doc(user.id)
                                                      .delete();
                                                  Navigator.of(context).pop();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        "${user.Sub_Category} was Deleted",
                                                      ),
                                                      duration: const Duration(
                                                          seconds: 2),
                                                    ),
                                                  );
                                                },
                                                child: const Text("Yes")),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text("Delete"),
                                ),
                                CupertinoButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Edit_Sub_Category(name1: user),
                                        ));
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
