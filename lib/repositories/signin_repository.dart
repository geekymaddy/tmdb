import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/strings.dart';

class SignInRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signInUser({
    required String email,
    required String password,
  }) async {
    String result = Strings.signInFailed;
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        result = Strings.signInSuccess;
      }
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case Strings.invalidEmailCase:
          result = Strings.invalidEmail;
          break;
        case Strings.userDisabledCase:
          result = Strings.userDisabled;
          break;
        case Strings.userNotFoundCase:
          result = Strings.userNotFound;
          break;
        case Strings.wrongPasswordCase:
          result = Strings.wrongPassword;
          break;
        case Strings.operationNotAllowedCase:
          result = Strings.operationNotAllowed;
          break;

        default:
          result = Strings.signInFailed;
      }
    }
    return result;
  }
}
