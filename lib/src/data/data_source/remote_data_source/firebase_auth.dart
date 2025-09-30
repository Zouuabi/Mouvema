import 'package:firebase_auth/firebase_auth.dart';
///
class FirebaseAuthentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signIn({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<String> getCurrentUserId() async {
    return _auth.currentUser!.uid;
  }

  Future<void> register(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }
}
