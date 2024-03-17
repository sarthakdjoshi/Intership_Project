import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_admin/Model/User_Model.dart';
import 'package:flutter/material.dart';

class All_Users extends StatefulWidget {
  const All_Users({super.key});

  @override
  State<All_Users> createState() => _All_UsersState();
}

class _All_UsersState extends State<All_Users> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All_User"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection("User").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.data == null) {
            return const Text("No data available");
          } else {
            final List<User_Model> users = snapshot.data!.docs
                .map((doc) => User_Model.fromFirestore(doc))
                .toList();
            return ListView.builder(
              itemCount: users.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                var user = users[index];
                return SizedBox(
                  width: 300,
                  child: InkWell(
                    onTap: () {},
                    child: ListTile(
                      title: Text(
                        user.Name,
                        style: const TextStyle(fontSize: 20),
                      ),
                      subtitle: Text(
                        user.Mobile,
                        style: const TextStyle(fontSize: 20),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.imageurl),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm TO Delete"),
                                content: const Text(
                                    'Are you sure you want to delete this Users?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("NO"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection("User")
                                          .doc(user.id)
                                          .delete();
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text("${user.Name} was Deleted"),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    child: const Text("Yes"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
