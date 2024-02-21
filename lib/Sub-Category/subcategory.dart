import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pratice/Model/Sub-Category-Model.dart';
import 'package:pratice/Sub-Category/Add_Sub-Category.dart';
import 'package:pratice/Sub-Category/edit_sub_category.dart';
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
        backgroundColor: Colors.indigo,
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Add_Sub_Category(),));
          }, icon: const Icon(Icons.add,size: 23,))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection("Sub-Category").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text("Error:${snapshot.hasError}");
                }
                else {
                  final List<Sub_CategoryModel> users = snapshot.data!.docs.map((
                      doc) => Sub_CategoryModel.fromFirestore(doc)).toList();
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      var user = users[index];
                      return Card(
                        child: Column(
                          children: [
                            Text(
                              "Category-${user.Category_Name}",style: const TextStyle(fontSize: 25,color: Colors.indigo),),
                            Text("Sub Category-${user.Sub_Category}",style: const TextStyle(fontSize: 25,color: Colors.indigo),),
                            Image(image: NetworkImage(user.Image),width: 200,height: 200,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CupertinoButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("Sub-Category")
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
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Edit_Sub_Category(name1: user),));
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


