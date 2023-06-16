import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/signup/usermodel.dart';
import '../utils/strings.dart';

class SignUpRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFireStore = FirebaseFirestore.instance;

  Future<String> signUpUser({
    required String? name,
    required String? email,
    required String? password,
  }) async {
    String result = Strings.signUpFailed;
    try {
      if (email!.isNotEmpty || name!.isNotEmpty || password!.isNotEmpty) {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: email, password: password!);
        if (kDebugMode) {
          print(user.user!.uid);
        }

        UserModel userModel = UserModel(
          email: email,
          name: name!,
          uid: user.user!.uid,
        );

        await _firebaseFireStore.collection('users').doc(user.user!.uid).set(
          userModel.toJson(),
        );
        result = Strings.signUpSuccess;
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
        case Strings.emailAlreadyUsedCase:
          result = Strings.emailAlreadyUsed;

          break;
        default:
          result = Strings.signUpFailed;
      }
    }

    return result;
  }


}
