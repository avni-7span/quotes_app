import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AuthenticationRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  static final AuthenticationRepository _singleton =
      AuthenticationRepository._internal();

  factory AuthenticationRepository() => _singleton;

  AuthenticationRepository._internal()
      : _firebaseAuth = firebase_auth.FirebaseAuth.instance;

  Future<firebase_auth.UserCredential> loginWithEmailPassword(
      {required String email, required String password}) async {
    final user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user;
  }

  Future<firebase_auth.UserCredential> signUpWithEmailPassword(
      {required String email, required String password}) async {
    final user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user;
  }
}
