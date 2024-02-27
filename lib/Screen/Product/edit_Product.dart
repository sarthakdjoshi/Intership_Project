import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pratice/Model/Sub-Category-Model.dart';
import 'package:pratice/Model/category-model.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import '../../Model/Product_Model.dart';

class Edit_Product extends StatefulWidget {
  final Product_Model product;
  const Edit_Product({super.key, required this.product});

  @override
  State<Edit_Product> createState() => _Edit_ProductState();
}

class _Edit_ProductState extends State<Edit_Product> {
  bool abc = true;
  String imageUrl = '';
  List<File>? selectedImage = [];
  bool isLoading = false;
  String? selectedCategory;
  String? selectedSubCategory;
  var product_name = TextEditingController();
  var product_price = TextEditingController();

  Future<void> add() async {
    if (selectedImage != null) {
      List<String> imageUrls = [];
      for (var imageFile in selectedImage!) {
        var ref = FirebaseStorage.instance.ref().child("Product").child(const Uuid().v1());
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
        await FirebaseFirestore.instance.collection("Product").doc(widget.product.id).update({
          "category": selectedCategory.toString(),
          "Sub_category": selectedSubCategory.toString(),
          "product_name": product_name.text.trim().toString(),
          "product_price": product_price.text.trim().toString(),
          "images": imageUrls,
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Product Added")));
        print(imageUrls);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    abc = false;
    selectedImage = widget.product.images.cast<File>();
    selectedCategory = widget.product.category;
    selectedSubCategory = widget.product.Sub_category;
    product_name.text = widget.product.product_name;
    product_price.text = widget.product.product_price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit_Product"),
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
                      child: (abc)
                          ? Image.file(selectedImage![index], height: 100, width: 100)
                          : Image.network(widget.product.images[index]),
                    );
                  },
                ),
              )
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
                    selectedImage = file.map((file) => File(file.path)).toList();
                    setState(() {

                      print(selectedImage);
                    });
                  },
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
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
                    selectedSubCategory = null; // Reset selected subcategory when category changes
                  });
                },
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
              const SizedBox(height: 10),
              TextField(
                controller: product_name,
                decoration: const InputDecoration(
                  hintText: "Product Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: product_price,
                decoration: const InputDecoration(
                  hintText: "Product Price",
                  border: OutlineInputBorder(borderRadius: BorderRadius.zero),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (selectedImage != null) {
                    add();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please Wait")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Choose Image")));
                  }
                },
                child: const Text("Update Product"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryDropdown extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const CategoryDropdown({required this.selectedCategory, required this.onChanged, super.key});

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

class SubCategoryDropdown extends StatelessWidget {
  final String? selectedSubCategory;
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const SubCategoryDropdown({required this.selectedSubCategory, required this.selectedCategory, required this.onChanged, super.key});

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
          if (selectedCategory == null || subCategory.Category_Name == selectedCategory) {
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
