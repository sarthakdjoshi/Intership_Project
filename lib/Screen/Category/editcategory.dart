import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/Screen/Category/categoryscreen.dart';

import '../../Appcolor.dart';
import '../../Model/category-model.dart';

class Edit_Category extends StatefulWidget {
  final CategoryModel category;

  const Edit_Category({super.key, required this.category});

  @override
  _Edit_CategoryState createState() => _Edit_CategoryState();
}

class _Edit_CategoryState extends State<Edit_Category> {
  final TextEditingController name = TextEditingController();
  File? profilepic;

  bool isloading = false;

  @override
  void initState() {
    super.initState();
    name.text = widget.category.Category_Name;
  }

  Future<void> _updateCategory() async {
    setState(() {
      isloading = true;
    });

    try {
      String imageUrl = widget.category.Image; // Default to existing image
      if (profilepic != null) {
        // Upload new image if selected
        Reference ref = FirebaseStorage.instance
            .ref()
            .child("Category")
            .child(DateTime.now().millisecondsSinceEpoch.toString());
        await ref.putFile(profilepic!);
        imageUrl = await ref.getDownloadURL();
      }

      // Update category data
      await FirebaseFirestore.instance
          .collection("Category")
          .doc(widget.category.id)
          .update({
        "Category_Name": name.text.trim(),
        "Image": imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Category updated successfully"),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Category_Screen()),
      );
    } catch (error) {
      print("Error updating category: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to update category. Please try again."),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Category"),
        backgroundColor: AppColors.lightBlue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text("Edit Your Category",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.indigo,
                            fontWeight: FontWeight.w900)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: name,
                    decoration: InputDecoration(
                      hintText: "Enter Name",
                      hintStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.indigo,
                          fontWeight: FontWeight.w900),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  (profilepic != null)
                      ? Center(
                          child: Image.file(
                          profilepic!,
                          width: 200,
                          height: 200,
                        ))
                      : Center(
                          child: Image.network(
                          widget.category.Image,
                          width: 200,
                          height: 200,
                        )),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final XFile? pickedImage = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (pickedImage != null) {
                              setState(() {
                                profilepic = File(pickedImage.path);
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              backgroundColor: Colors.white70),
                          child: const Text(
                            "Select Image",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _updateCategory,
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              backgroundColor: Colors.indigo),
                          child: (isloading)
                              ? const CircularProgressIndicator()
                              : const Text(
                                  "Update",
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
