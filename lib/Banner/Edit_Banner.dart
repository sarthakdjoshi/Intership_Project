import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pratice/Model/Banner_model.dart';
class Edit_Banner extends StatefulWidget {
  final Banner_Model banner;

  const Edit_Banner({super.key, required this.banner});

  @override
  State<Edit_Banner> createState() => _Edit_BannerState();
}

class _Edit_BannerState extends State<Edit_Banner> {
  bool abc = false;
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
          .child("Banner")
          .child(uniquefilename);
      try {
        await ref.putFile(profilepic!);
        imageurl = await ref.getDownloadURL();
        print("Image Url:$imageurl");
        FirebaseFirestore.instance.collection("Banner").doc(widget.banner.id).update({
          "Banner_Name": name.text.trim().toString(),
          "Image": imageurl
        }).then((value) {
          name.clear();
          profilepic = null;
          setState(() {
            isloading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Banner Added Successfully"),
            duration: Duration(seconds: 2),
          ));
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    name.text = widget.banner.Banner_Name;
    imageurl = widget.banner.Image; // Set the image URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit_Banner"),
        backgroundColor: Colors.lightGreenAccent,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Edit Your Banner Name",
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
                    hintText: "Enter Banner Name",
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
                    ? Image.network(imageurl)
                    : SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.file(profilepic!),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        XFile? selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (selectedImage != null) {
                          print("Image");
                          File cf = File(selectedImage.path);
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
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      backgroundColor: Colors.white70,
                    ),
                    child: const Text(
                      "Choose Your Image",
                      style: TextStyle(color: Colors.indigo),
                    ),
                  ),
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
                            const SnackBar(content: Text("Enter Banner Name")));
                      } else if (profilepic == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Choose Photo")));
                      } else {
                        adddata();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      backgroundColor: Colors.indigo,
                    ),
                    child: (isloading)
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Update",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

