import 'package:flutter/material.dart';
import 'package:stock_management_system/blocs/blocs.dart';
import 'package:stock_management_system/repositories/repositories.dart';

class PreloadData {
  final UserRepository _userRepository;
  final AuthBloc _authBloc;
  PreloadData({
    @required UserRepository userRepository,
    @required AuthBloc authBloc,
  })  : _userRepository = userRepository,
        _authBloc = authBloc;

  Future<List> loadInitialData() async {
    final list = await _userRepository.getBuiltInAdminEmailAccount();
    final String managerEmail =
        await _userRepository.getBuiltInManagerUserEmail();
    final currentUserId = _authBloc.state.user.uid;
    final user = await _userRepository.getUserWithId(userId: currentUserId);

    return [list, managerEmail, user];
  }
}
