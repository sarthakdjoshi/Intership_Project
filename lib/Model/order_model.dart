import 'package:cloud_firestore/cloud_firestore.dart';

class Order_Model {
  final String id;
  final String Uid;
  final List<dynamic> product_name;
  final String product_price;
  final String user_name;
  final String Payment_Method;
  final String orderid;
  final String orderstatus;

  Order_Model({
    required this.id,
    required this.Uid,
    required this.product_name,
    required this.product_price,
    required this.user_name,
    required this.Payment_Method,
    required this.orderid,
    required this.orderstatus,
  });

  factory Order_Model.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Order_Model(
      id: snapshot.id,
      Uid: data['Uid'],
      product_name: data['product_name'],
      product_price: data['product_price'],
      user_name: data['user_name'],
      Payment_Method: data['Payment_Method'] ?? "",
      orderid: data['orderid'],
      orderstatus: data['orderstatus']??"",
    );
  }
}
