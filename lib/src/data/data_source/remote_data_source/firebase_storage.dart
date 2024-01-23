import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
///
class CloudStorage {
  final firebaseStorage = FirebaseStorage.instance;

  Future<String> storeImage(
      {required String child,
      required String uid,
      required Uint8List image}) async {
    Reference ref = firebaseStorage.ref().child(child).child(uid);
    UploadTask task = ref.putData(image);
    var snapshot = await task;

    return snapshot.ref.getDownloadURL();
  }
}
