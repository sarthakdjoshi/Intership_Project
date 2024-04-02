import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Model/order_model.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  String qty = ""; //dropdown
  List<String> options = ["pending", "confirm", "dispatched", "shipped","Cancel"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body:FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('Orders').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final orders = snapshot.data!.docs.map((doc) {
            return Order_Model.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
          }).toList();
          if (orders.isEmpty) {
            return Center(child: Text("No orders found."));
          }

          return ListView.separated(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              var abc = index + 1;
              qty=order.orderstatus;
              return ListTile(
                title: Text('Order ID: ${order.orderid}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Column(
                  children: [
                    Text('Products: ${order.product_name.join(", ")}', style: TextStyle(fontSize: 16)),
                    Text('Payment Mode: ${order.Payment_Method}', style: TextStyle(fontSize: 16)),
                    Text('Product Price: ${order.product_price}', style: TextStyle(fontSize: 16)),
                  ],
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue, // Change leading icon background color
                  child: Text(abc.toString(), style: TextStyle(color: Colors.white)), // Change leading icon text color
                ),
                  trailing: DropdownButton<String>(
                    value: qty,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        qty =newValue;
                        setState(() {});
                        if(qty=="Cancel"){
                          FirebaseFirestore.instance.collection("Orders").doc(order.id).delete();
                        }
                        FirebaseFirestore.instance.collection("Orders").doc(order.id).update(
                            {
                              "orderstatus":qty.toString()
                            });
                      }
                    },
                    items: options.map<DropdownMenuItem<String>>(
                            (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                  ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(height: 3, color: Colors.grey); // Change divider color
            },
          );
        },
      ),
      );
  }
}
