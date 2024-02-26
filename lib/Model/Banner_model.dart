import 'package:cloud_firestore/cloud_firestore.dart';
class Banner_Model{
  final String id;
  final String Banner_Name;
  final String Image;


  Banner_Model({
    required this.id,
    required this.Banner_Name,
    required this.Image,
  });

  factory Banner_Model.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Banner_Model(
      id: snapshot.id, Banner_Name: data['Banner_Name'], Image: data['Image'],

    );
  }
}


