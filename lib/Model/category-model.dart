import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String? id;
  final String Image;
  final String Category_Name;

  CategoryModel({
    required this.id,
    required this.Image,
    required this.Category_Name,
  });

  factory CategoryModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return CategoryModel(
      id: snapshot.id,
      Category_Name: data['Category_Name'],
      Image: data['Image'],
    );
  }
}
