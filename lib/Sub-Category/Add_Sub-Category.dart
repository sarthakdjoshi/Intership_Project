import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Model/category-model.dart';

class Add_Sub_Category extends StatefulWidget{
  const Add_Sub_Category({super.key});

  @override
  State<Add_Sub_Category> createState() => _Add_Sub_CategoryState();
}

class _Add_Sub_CategoryState extends State<Add_Sub_Category> {
  CategoryModel? selectedCategory;
  String Categoty = 'Select Category'; //dropdown
  List<String> options = ['Select Category', 'Hoodie', 'Shoes'];
  var name = TextEditingController();
  File? profilepic;
  var uniquefilename = DateTime.now().millisecondsSinceEpoch.toString();
  var imageurl = "";
  bool isloading = false;

  void adddata() async {
    if (profilepic != null) {
      setState(() {
        isloading = true;
      });
      var ref = FirebaseStorage.instance
          .ref()
          .child("Category")
          .child(uniquefilename);
      try {
        await ref.putFile(profilepic!);
        imageurl = await ref.getDownloadURL();
        print("Image Url:$imageurl");
        FirebaseFirestore.instance.collection("Sub-Category").add({
          "Category_Name": Categoty.trim().toString(),
          "Sub_Category": name.text.trim().toString(),
          "Image": imageurl
        }).then((value) {
          name.clear();
          profilepic = null;
          setState(() {
            isloading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Category Added SucessFully"),
            duration: Duration(seconds: 2),
          ));
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text("Add_Sub_Category"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection("Category").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                final List<CategoryModel> categories = snapshot.data!.docs.map((doc) => CategoryModel.fromFirestore(doc)).toList();

                return DropdownButton<CategoryModel>(
                  hint: const Text('Select a category'),
                  value: selectedCategory,
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                  items: categories.map((category) {
                    return DropdownMenuItem<CategoryModel>(
                      value: category,
                      child: Text(category.Category_Name),
                    );
                  }).toList(),
                );
              }
            },
          ),
          SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Add Your  Sub-Category",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.indigo,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: name,
                      decoration: InputDecoration(
                        hintText: "Enter Sub-Category  Name",
                        hintStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.indigo,
                            fontWeight: FontWeight.w900),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    (profilepic == null)
                        ? Image.asset("assets/Icons/Images.jpg")
                        : SizedBox(
                        width: 200,
                        height: 200,
                        child: Image(image: FileImage(profilepic!))),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            try {
                              XFile? selecetedimage = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (selecetedimage != null) {
                                print("Image");
                                File cf = File(selecetedimage.path);
                                setState(() {
                                  profilepic = cf;
                                });
                              } else {
                                print("No Image");
                              }
                            } catch (e) {
                              print(e.toString());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                              backgroundColor: Colors.white70),
                          child: const Text(
                            "Choose Your Image",
                            style: TextStyle(color: Colors.indigo),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          var Name = name.text.trim().toString();
                          if (Name.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Enter Sub-Category Name")));
                          } else if (profilepic == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Choose Photo")));
                          } else if (Categoty == "Select Category") {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Choose Sub-Category")));
                          } else {
                            adddata();
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content:
                                Text("Please Wait")));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            backgroundColor: Colors.indigo),
                        child: (isloading)
                            ? const CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        )
                            : const Text(
                          "Add Brand",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ],
      ),
    );

  }
}