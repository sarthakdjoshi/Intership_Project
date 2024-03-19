import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'dart:core';

import '../../Model/Sub-Category-Model.dart';
import '../../Model/category-model.dart';

class Add_Product extends StatefulWidget {
  const Add_Product({super.key});

  @override
  State<Add_Product> createState() => _Add_ProductState();
}

class _Add_ProductState extends State<Add_Product> {
  String imageUrl = '';
  List<File>? selectedImage = [];
  bool isLoading = false;
  String? selectedCategory;
  String? selectedSubCategory;
  var product_name = TextEditingController();
  var product_price = TextEditingController();
  var discount = TextEditingController();
  var product_newprice = TextEditingController();
  var product_color = TextEditingController();
  var product_title1 = TextEditingController();
  var product_title1_delail = TextEditingController();
  var product_title2 = TextEditingController();
  var product_title2_delail = TextEditingController();
  var product_title3 = TextEditingController();
  var product_title3_delail = TextEditingController();
  var product_title4 = TextEditingController();
  var product_title4_delail = TextEditingController();
  var product_desc = TextEditingController();
  var product_all = TextEditingController();

  Future<void> add() async {
    if (selectedImage != null) {
      List<String> imageUrls = [];
      for (var imageFile in selectedImage!) {
        var ref = FirebaseStorage.instance
            .ref()
            .child("Product")
            .child(const Uuid().v1());
        try {
          await ref.putFile(imageFile);
          imageUrl = await ref.getDownloadURL();
          print("Image Url: $imageUrl");
          imageUrls.add(imageUrl);
        } catch (e) {
          print(e.toString());
        }
      }
      try {
        await FirebaseFirestore.instance.collection("Product").add({
          "category": selectedCategory.toString(),
          "Sub_category": selectedSubCategory.toString(),
          "product_name": product_name.text.trim().toString(),
          "product_price": product_price.text.trim().toString(),
          "discount": discount.text.trim().toString(),
          "product_newprice": product_newprice.text.trim().toString(),
          "product_color": product_color.text.trim().toString(),
          "product_title1": product_title1.text.trim().toString(),
          "product_title1_delail": product_title1_delail.text.trim().toString(),
          "product_title2": product_title2.text.trim().toString(),
          "product_title2_delail": product_title2_delail.text.trim().toString(),
          "product_title3": product_title3.text.trim().toString(),
          "product_title3_delail": product_title3_delail.text.trim().toString(),
          "product_title4": product_title4.text.trim().toString(),
          "product_title4_delail": product_title4_delail.text.trim().toString(),
          "product_desc": product_desc.text.trim().toString(),
          "product_all": product_all.text.trim().toString(),
          "images": imageUrls,
          "fav":"no"
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Product Added")));
        print(imageUrls);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add_Product"),
          centerTitle: true,
          backgroundColor: Colors.indigo,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                (selectedImage != null)
                    ? SizedBox(
                        height: 300,
                        width: 300,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedImage?.length,
                          itemBuilder: (context, index) {
                            return Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.file(selectedImage![index],
                                    height: 100, width: 100));
                          },
                        ))
                    : SizedBox(
                        height: 300,
                        width: 300,
                        child: Image.asset("assets/Icons/Images.jpg"),
                      ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      ImagePicker imagePicker = ImagePicker();
                      List<XFile>? file = await imagePicker.pickMultiImage();
                      selectedImage =
                          file.map((file) => File(file.path)).toList();
                      setState(() {
                        print(selectedImage);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    child: const Text(
                      "Select Image",
                      style: TextStyle(color: Colors.deepPurpleAccent),
                    ),
                  ),
                ),
                CategoryDropdown(
                  selectedCategory: selectedCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                SubCategoryDropdown(
                  selectedCategory: selectedCategory,
                  selectedSubCategory: selectedSubCategory,
                  onChanged: (value) {
                    setState(() {
                      selectedSubCategory = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: product_name,
                  decoration: const InputDecoration(
                      hintText: "Product Name",
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero)),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: product_price,
                  decoration: const InputDecoration(
                      hintText: "Product Price",
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero)),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: discount,
                  decoration: const InputDecoration(
                      hintText: "Discount",
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero)),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: product_newprice,
                  decoration: const InputDecoration(
                      hintText: "Product New Price",
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero)),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: product_color,
                  decoration: const InputDecoration(
                      hintText: "Product Colour",
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero)),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: product_title1,
                  decoration: const InputDecoration(
                      hintText: "Product Title1",
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero)),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: product_title1_delail,
                  decoration: const InputDecoration(
                      hintText: "Title1 Detail",
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero)),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: product_title2,
                  decoration: const InputDecoration(
                      hintText: "Product Title2",
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero)),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: product_title2_delail,
                  decoration: const InputDecoration(
                      hintText: "Title2 Detail",
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero)),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: product_title3,
                  decoration: const InputDecoration(
                      hintText: "Product Title3",
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero)),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: product_title3_delail,
                  decoration: const InputDecoration(
                      hintText: "Title3 Detail",
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero)),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: product_title4,
                  decoration: const InputDecoration(
                      hintText: "Product Title4",
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero)),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: product_title4_delail,
                  decoration: const InputDecoration(
                      hintText: "Title 4 Detail",
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero)),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: product_all,
                  decoration: const InputDecoration(
                      hintText: "Product All Detail",
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero)),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: product_desc,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      hintText: "Enter Description",
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.zero)),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (selectedImage != null) {
                        add();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please Wait")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Choose Image")));
                      }
                    },
                    child: const Text("Add Product"))
              ],
            ),
          ),
        ));
  }
}

class CategoryDropdown extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const CategoryDropdown(
      {required this.selectedCategory, required this.onChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Category').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final categoryDocs = snapshot.data!.docs;
        List<CategoryModel> categories = [];

        for (var doc in categoryDocs) {
          final category = CategoryModel.fromFirestore(doc);
          categories.add(category);
        }

        return DropdownButtonFormField<String>(
          value: selectedCategory,
          onChanged: onChanged,
          decoration: const InputDecoration(
            labelText: 'Select Category',
            labelStyle: TextStyle(color: Colors.deepPurpleAccent),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(3)),
            ),
          ),
          items: categories.map((CategoryModel category) {
            return DropdownMenuItem<String>(
              value: category.Category_Name,
              child: Text(
                category.Category_Name,
                style: const TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a Category';
            }
            return null;
          },
        );
      },
    );
  }
}

// class Sub_CategoryDropdown extends StatelessWidget {
//   final String? selectedCategory;
//   final ValueChanged<String?> onChanged;
//
//   const Sub_CategoryDropdown(
//       {required this.selectedCategory, required this.onChanged, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance.collection('Sub-Category').where("Category_Name",isEqualTo: ).snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return const CircularProgressIndicator();
//         }
//
//         final categoryDocs = snapshot.data!.docs;
//         List<Sub_CategoryModel> categories = [];
//
//         for (var doc in categoryDocs) {
//           final category = Sub_CategoryModel.fromFirestore(doc);
//           categories.add(category);
//         }
//
//         return DropdownButtonFormField<String>(
//           value: selectedCategory,
//           onChanged: onChanged,
//           decoration: const InputDecoration(
//             labelText: 'Select Category',
//             labelStyle: TextStyle(color: Colors.deepPurpleAccent),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(3)),
//             ),
//           ),
//           items: categories.map((Sub_CategoryModel category) {
//             return DropdownMenuItem<String>(
//               value: category.Sub_Category,
//               child: Text(
//                 category.Sub_Category,
//                 style: const TextStyle(color: Colors.black),
//               ),
//             );
//           }).toList(),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please select a Category';
//             }
//             return null;
//           },
//         );
//       },
//     );
//   }
// }

class SubCategoryDropdown extends StatelessWidget {
  final String? selectedSubCategory;
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const SubCategoryDropdown({
    required this.selectedSubCategory,
    required this.selectedCategory,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Sub-Category').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final subCategoryDocs = snapshot.data!.docs;
        List<Sub_CategoryModel> subCategories = [];

        for (var doc in subCategoryDocs) {
          final subCategory = Sub_CategoryModel.fromFirestore(doc);

          // Filter subcategories based on the selected category
          if (subCategory.Category_Name == selectedCategory) {
            subCategories.add(subCategory);
          }
        }

        return DropdownButtonFormField<String>(
          value: selectedSubCategory,
          onChanged: onChanged,
          decoration: const InputDecoration(
            labelText: 'Select SubCategory',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(3)),
            ),
          ),
          items: subCategories.map((Sub_CategoryModel subCategory) {
            return DropdownMenuItem<String>(
              value: subCategory.Sub_Category,
              child: Text(
                subCategory.Sub_Category,
                style: const TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a SubCategory';
            }
            return null;
          },
        );
      },
    );
  }
}
