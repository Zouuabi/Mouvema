import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudFiresore {
  final _firestore = FirebaseFirestore.instance;
  String collectionrRef = 'users';
  String documentRef = '';

  Future<void> addNewUserInformations({
    required String uid,
    required String imageLink,
    required String email,
    required String userName,
    required String birthDate,
  }) async {
    print('addnewuser run');
    Map<String, dynamic> user = {
      'uid': uid,
      'image': imageLink,
      'email': email,
      'username': userName,
      'birthdate': birthDate
    };

    await _firestore.collection(collectionrRef).doc(uid).set(user);
    print('user added ');
  }
}
