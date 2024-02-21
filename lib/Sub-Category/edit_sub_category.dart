import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pratice/Model/Sub-Category-Model.dart';
import 'package:pratice/Screen/Category/categoryscreen.dart';
import 'package:pratice/Sub-Category/subcategory.dart';

import '../../Model/category-model.dart';

class Edit_Sub_Category extends StatefulWidget {
  Sub_CategoryModel name1;

  Edit_Sub_Category({super.key,required this.name1 });

  @override
  State<Edit_Sub_Category> createState() => _Edit_Sub_CategoryState();
}
class _Edit_Sub_CategoryState extends State<Edit_Sub_Category> {
  CategoryModel? selectedCategory;
  var name = TextEditingController();
  File? profilepic;
  var uniquefilename = DateTime.now().millisecondsSinceEpoch.toString();
  var imageurl = "";
  bool isloading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text=widget.name1.Sub_Category;

  }
  Future<void> UpdateData() async {
    if (profilepic != null) {
      setState(() {
        isloading = true;
      });
      var ref = FirebaseStorage.instance
          .ref()
          .child("Sub-Category")
          .child(uniquefilename);
      try {
        await ref.putFile(profilepic!);
        imageurl = await ref.getDownloadURL();
        print("Image Url:$imageurl");
        FirebaseFirestore.instance.collection("Sub-Category").doc(widget.name1.id).update({
          "Sub_Category": name.text.trim().toString(),
          "Image": imageurl
        }).then((value) {
          name.clear();
          setState(() {
            isloading = false;
          });
          Navigator.push(context,MaterialPageRoute(builder:  (context) => const Sub_Category(),));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Category Updated SucessFully"),
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
          title: const Text("Edit Your Sub Categories"),
          backgroundColor: Colors.lightGreenAccent,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Edit Your Sub-Category",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.indigo,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(
                      height: 10,
                    ),
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
                            hint: const Text('Update a category'),
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
                    const SizedBox(
                      height: 10,
                    ),
                    (profilepic != null)
                        ? Image.file(profilepic!,width: 200,height: 200,)
                        : Image.network(widget.name1.Image,width: 200,height: 200,),
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
                                    content: Text("Enter Category Name")));
                          } else if (profilepic == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Choose Photo")));
                          } else {
                            UpdateData();
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
                            ? const CircularProgressIndicator()
                            : const Text(
                          "Update",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
