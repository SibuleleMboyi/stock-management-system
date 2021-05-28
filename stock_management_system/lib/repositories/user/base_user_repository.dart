import 'package:stock_management_system/models/user_model.dart';

abstract class BaseUserRepository {
  Future<User> getUserWithId({String userId});
}
