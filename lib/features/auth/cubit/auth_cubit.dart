import 'dart:async';

import 'package:absar/features/auth/cubit/auth_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  DocumentSnapshot? userDoc;

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 1));
    authStateChanged();
  }

  void authStateChanged() async {
    final user = _auth.currentUser;
    if (user == null) {
      emit(NotHaveCurrentUser());
    } else {
      await testIfUserIsExists();
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      emit(AuthSuccess());
    } on Exception catch (e) {
      emit(AuthError(
        message: e.toString(),
      ));
      print(e);
    }
  }

  Future<bool?> testIfUserIsExists() async {
    final User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    if (userDoc.exists) {
      getUserData();
      return true;
    } else {
      if (user != null) {
        emit(GetUserError());
        return false;
      }
    }
    return null;
  }

  Future<void> saveMyUser(String name) async {

    final ref = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid);
    await ref.set(
      {
        'name': name,
        'uid': _auth.currentUser!.uid,
        'email': _auth.currentUser!.email,
      },
      SetOptions(merge: true),
    );
    emit(DataCompletedDone());
  }

  Future<void> getUserData() async {
    try {
      emit(GetUserLoading());
      final ref = FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid);
      final doc = await ref.get();
      userDoc = doc;
      emit(GetUserSuccess());
    } on Exception catch (e) {
      emit(GetUserError());
      debugPrint('error in get user data $e');
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await _auth.signOut();
      emit(AuthSignOutSuccess());
    } catch (e) {
      emit(AuthError(
        message: e.toString(),
      ));
    }
  }

}
