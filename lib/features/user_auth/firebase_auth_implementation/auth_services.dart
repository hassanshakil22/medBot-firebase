import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authProject/global/widgets/toast.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseAuthServices {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential credentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = credentials.user;
      await user?.updateDisplayName(username);

      return credentials.user;
    } on FirebaseAuthException catch (e) {
      if (e.code.isNotEmpty) {
        print("Error Code: ${e.code}");
        print("Error Message: ${e.message}");
        showToast(message: e.code);
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credentials = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credentials.user;
    } on FirebaseAuthException catch (e) {
      print("Error Code: ${e.code}");
      print("Error Message: ${e.message}");
      showToast(message: e.code);
      // if (e.code.isNotEmpty) {
      // }

      print("some error occured $e");
    }
    return null;
  }
}
