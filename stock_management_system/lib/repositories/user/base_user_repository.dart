import 'package:flutter/material.dart';
import 'package:stock_management_system/models/user_model.dart';

abstract class BaseUserRepository {
  Future<User> getUserWithId({@required String userId});
  Future<void> updateUser({@required User user});
  Future<void> builtInAdminEmailAccount(
      {@required String email, @required String password});
  Future<void> builtInManagerUserEmail({@required String email});
  Future<String> getBuiltInManagerUserEmail();
  Future<List> getBuiltInAdminEmailAccount();
}
