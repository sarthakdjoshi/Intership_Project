import 'package:cloud_firestore/cloud_firestore.dart';

class Product_Model {
  final String id;
  final List<dynamic> images;
  final String category;
  final String Sub_category;
  final String discount;
  final String product_all;
  final String product_color;
  final String product_desc;
  final String product_price;
  final String product_name;
  final String product_newprice;
  final String product_title1;
  final String product_title1_delail;
  final String product_title2;
  final String product_title2_delail;
  final String product_title3;
  final String product_title3_delail;
  final String product_title4;
  final String product_title4_delail;

  Product_Model({
    required this.discount,
    required this.product_all,
    required this.product_color,
    required this.product_desc,
    required this.product_newprice,
    required this.product_title1,
    required this.product_title1_delail,
    required this.product_title2,
    required this.product_title2_delail,
    required this.product_title3,
    required this.product_title3_delail,
    required this.product_title4,
    required this.product_title4_delail,
    required this.id,
    required this.images,
    required this.category,
    required this.Sub_category,
    required this.product_price,
    required this.product_name,
  });

  factory Product_Model.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Product_Model(
      id: snapshot.id,
      category: data['category'],
      images: data['images'],
      Sub_category: data['Sub_category'],
      product_price: data['product_price'],
      product_name: data['product_name'],
      discount: data['discount'],
      product_all: data['product_all'],
      product_color: data['product_color'],
      product_desc: data['product_desc'],
      product_newprice: data['product_newprice'],
      product_title1: data['product_title1'],
      product_title1_delail: data['product_title1_delail'],
      product_title2: data['product_title2'],
      product_title2_delail: data['product_title2_delail'],
      product_title3: data['product_title3'],
      product_title3_delail: data['product_title3_delail'],
      product_title4: data['product_title4'],
      product_title4_delail: data['product_title4_delail'],
    );
  }
}
