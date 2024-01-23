import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
///
class FirebaseAuthentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    // final GoogleSignInAccount? googleSignInAccount =
    //     await _googleSignIn.signIn();

    // final GoogleSignInAuthentication googleSignInAuthentication =
    //     await googleSignInAccount!.authentication;
    // final AuthCredential credential = GoogleAuthProvider.credential(
    //   accessToken: googleSignInAuthentication.accessToken,
    //   idToken: googleSignInAuthentication.idToken,
    // );

    // await _auth.signInWithCredential(credential);
  }

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
    // await _googleSignIn.signOut();
  }
}
