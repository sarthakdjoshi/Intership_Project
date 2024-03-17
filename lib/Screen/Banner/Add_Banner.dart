import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Add_Banner extends StatefulWidget {
  const Add_Banner({super.key});

  @override
  State<Add_Banner> createState() => _Add_BannerState();
}

class _Add_BannerState extends State<Add_Banner> {
  var name = TextEditingController();
  File? profilepic;
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
          .child(const Uuid().v1());
      try {
        await ref.putFile(profilepic!);
        imageurl = await ref.getDownloadURL();
        print("Image Url:$imageurl");
        FirebaseFirestore.instance.collection("Banner").add({
          "Banner_Name": name.text.trim().toString(),
          "Image": imageurl
        }).then((value) {
          name.clear();
          profilepic = null;
          setState(() {
            isloading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Banner Added SucessFully"),
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
          title: const Text("Add_Banner"),
          backgroundColor: Colors.indigo,
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                            const SnackBar(content: Text("Enter Banner Name")));
                      } else if (profilepic == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Choose Photo")));
                      } else {
                        adddata();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        backgroundColor: Colors.indigo),
                    child: (isloading)
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Add",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                )
              ],
            ),
          )),
        ));
  }
}
