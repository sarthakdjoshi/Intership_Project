import 'package:cloud_firestore/cloud_firestore.dart';

class Sub_CategoryModel {
  final String id;
  final String Image;
  final String Category_Name;
  final String Sub_Category;

  Sub_CategoryModel({
    required this.id,
    required this.Image,
    required this.Category_Name,
    required this.Sub_Category,
  });

  factory Sub_CategoryModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Sub_CategoryModel(
      id: snapshot.id,
      Category_Name: data['Category_Name'],
      Image: data['Image'],
      Sub_Category: data['Sub_Category'],
    );
  }
}
