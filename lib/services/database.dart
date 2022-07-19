import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ required this.uid });

  //collection reference
  final CollectionReference carCollection = FirebaseFirestore.instance.collection('cars');


  Future updateUserData(String name, int phone, String address) async {
    return await carCollection.doc(uid).set({
      'name' : name,
      'phone' : phone,
      'address' : address,
    });
  }

}