import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stock_management_system/config/configs.dart';
import 'package:stock_management_system/models/user_model.dart';
import 'package:stock_management_system/repositories/user/base_user_repository.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<User> getUserWithId({@required String userId}) async {
    final doc =
        await _firebaseFirestore.collection(Paths.users).doc(userId).get();

    /// we convert the 'doc'(document) that we get from Firestore to our user model.
    return doc.exists ? User.fromDocument(doc) : User.empty;
  }
}
