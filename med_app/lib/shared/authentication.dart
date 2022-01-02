import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_core/firebase_core.dart";
import "dart:async";

class Authentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> login(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;
    return user?.uid ?? "";
  }

  Future<String> signUp(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;
    return user?.uid ?? "";
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<User?> getUser() async {
    User? user = await _firebaseAuth.currentUser;
    return user;
  }
}
