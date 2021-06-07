import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

abstract class BaseAuthRepository {
  // continously gets the state of the current user i.e If the user is loggedIn or loggedOut
  Stream<auth.User> get user;

  Future<auth.User> signUpWithEmailAndPassword({
    String username,
    String email,
    String password,
    String userType,
  });

  Future<auth.User> logInWithEmailAndPassword({
    String email,
    String password,
  });

  Future<void> updatePassword({@required String password});

  Future<void> logOut();
}
