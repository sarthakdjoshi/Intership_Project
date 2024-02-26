import 'package:cloud_firestore/cloud_firestore.dart';
class Product_Model{
  final String id;
  final List<dynamic> images;
  final String category;
  final String Sub_category;
  final String product_price;
  final String product_name;


  Product_Model({
    required this.id,
    required this.images,
    required this.category,
    required this.Sub_category,
    required this.product_price,
    required this.product_name,
  });

  factory Product_Model.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Product_Model(
      id: snapshot.id,
      category: data['category'],
      images: data['images'],
      Sub_category: data['Sub_category'],
      product_price: data['product_price'],
      product_name:data['product_name'],
    );
  }
}


