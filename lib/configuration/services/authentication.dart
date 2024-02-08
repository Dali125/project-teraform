import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projectTeraform/configuration/models/rigistration_model.dart';

import '../models/user_model.dart';

///This is a class where all functions to do with authentication should be made
///Such as login, logout, signup and more
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  /// create user
  Future<UserModel?> signUpUser(
      String email,
      String password,
      RegistrationModel myModel
      ) async {
    try {
      final UserCredential userCredential =
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final UserCredential currentUser = await _firebaseAuth.
      signInWithEmailAndPassword(email: email.trim(), password: password.trim());
      final User? firebaseUser = currentUser.user;
      if (firebaseUser != null) {

        await FirebaseFirestore.instance.collection('users')
        .add({
          'email': firebaseUser.email,
          'user_id': firebaseUser.uid,
          'birth_date': myModel.birthdate,
          'first_name' : myModel.firstName,
          'last_name' : myModel.lastName,
        });
        return UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? '',
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      log('$e');
    }
    return null;
  }
  /// create user
  Future<UserModel?> signUpsUser(
      String email,
      String password,
      ) async {
    try {
      final UserCredential userCredential =
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        return UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? '',
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
    return null;
  }


  ///Signs in the user
  Future<UserModel?> signInUser(
      String email,
      String password,
      ) async{
    try {
      final UserCredential userCredential =
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {

        return UserModel(
            id: firebaseUser.uid,
            email: firebaseUser.email,
            displayName: firebaseUser.displayName

        );
      }
    } on FirebaseAuthException catch(e){
      log('$e');
    }
    return null;
    }

  ///signOutUser
  Future<void> signOutUser() async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseAuth.instance.signOut();
    }
  }
// ... (other methods)}
}