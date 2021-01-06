import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireBaseService {

  FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore= FirebaseFirestore.instance;
  String getUserId(){
    return _firebaseAuth.currentUser.uid;
  }
  final CollectionReference productRef = FirebaseFirestore.instance.collection("Products");

  final CollectionReference usersRef = FirebaseFirestore.instance.collection("Users");

}