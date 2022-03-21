import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;

  Future signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      return null;
    }
  }
}
