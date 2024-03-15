import 'package:cloud_firestore/cloud_firestore.dart';

class User_Model {
  final String id;
  final String Uid;
  final String email;
  final String Name;
  final String Mobile;
  final String street1;
  final String street2;
  final String landmark;
  final String pincode;
  final String imageurl;

  User_Model({
    required this.id,
    required this.Uid,
    required this.email,
    required this.Name,
    required this.Mobile,
    required this.street1,
    required this.street2,
    required this.landmark,
    required this.pincode,
    required this.imageurl,
  });

  factory User_Model.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return User_Model(
      id: snapshot.id,
      Uid: data['Uid'],
      email: data['email'],
      Name: data['Name'],
      Mobile: data['Mobile'],
      street1: data['street1'],
      street2: data['street2'],
      landmark: data['landmark'],
      pincode: data['pincode'],
      imageurl: data['imageurl'],
    );
  }
}
