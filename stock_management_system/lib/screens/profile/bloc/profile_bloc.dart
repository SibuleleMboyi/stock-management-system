import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stock_management_system/blocs/blocs.dart';
import 'package:stock_management_system/models/models.dart';
import 'package:stock_management_system/repositories/repositories.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final AuthBloc _authBloc;
  List adminCredentials;
  String managerEmail;
  User user;

  ProfileBloc({
    @required AuthRepository authRepository,
    @required UserRepository userRepository,
    @required AuthBloc authBloc,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        _authBloc = authBloc,
        super(ProfileState.initial());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileLoadInitialInfo) {
      yield* _mapProfileLoadInitialInfo(event);
    } else if (event is ManagerEmailChanged) {
      yield* _mapManagerEmailChanged(event);
    } else if (event is AdminEmailChanged) {
      yield* _mapAdminEmailChanged(event);
    } else if (event is AdminEmailPasswordChanged) {
      yield* _mapAdminEmailPasswordChanged(event);
    } else if (event is UsernameChanged) {
      yield* _mapUsernameChanged(event);
    } else if (event is SubmitChanges) {
      yield* _mapSubmitChanges(event);
    } else if (event is Reset) {
      yield* _mapReset(event);
    } else if (event is LogOut) {
      yield* _mapLogOut(event);
    } else if (event is ToogleViewPassword) {
      yield* _mapToogleViewPassword(event);
    }
  }

  Stream<ProfileState> _mapProfileLoadInitialInfo(
      ProfileLoadInitialInfo event) async* {
    yield state.copyWith(status: ProfileStatus.submitting);
    try {
      String initAdminEmail = '';
      String initAdminEmailPassword = '';
      String initManagerEmail = '';
      String initUsername = '';
      final currentUserId = _authBloc.state.user.uid;
      user = await _userRepository.getUserWithId(userId: currentUserId);

      final adminCredentials =
          await _userRepository.getBuiltInAdminEmailAccount();
      final managerEmail = await _userRepository.getBuiltInManagerUserEmail();

      if (adminCredentials.isNotEmpty && managerEmail != '') {
        initAdminEmail = adminCredentials[0];
        initAdminEmailPassword = adminCredentials[1];
        initManagerEmail = managerEmail;
      }
      initUsername = user.username;
      yield state.copyWith(
        user: user,
        adminEmail: initAdminEmail,
        adminPassword: initAdminEmailPassword,
        managerEmail: initManagerEmail,
        username: initUsername,
        status: ProfileStatus.initial,
      );
    } catch (err) {
      yield state.copyWith(
          status: ProfileStatus.error,
          failure:
              const Failure(message: 'We were un able to load this profile.'));
    }
  }

  Stream<ProfileState> _mapManagerEmailChanged(
      ManagerEmailChanged event) async* {
    yield state.copyWith(
        status: ProfileStatus.initial, managerEmail: event.managerEmail);
  }

  Stream<ProfileState> _mapAdminEmailChanged(AdminEmailChanged event) async* {
    yield state.copyWith(
        status: ProfileStatus.initial, adminEmail: event.adminEmail);
  }

  Stream<ProfileState> _mapAdminEmailPasswordChanged(
      AdminEmailPasswordChanged event) async* {
    yield state.copyWith(
        status: ProfileStatus.initial, adminPassword: event.adminEmailPassword);
  }

  Stream<ProfileState> _mapUsernameChanged(UsernameChanged event) async* {
    yield state.copyWith(
        status: ProfileStatus.initial, username: event.username);
  }

  Stream<ProfileState> _mapSubmitChanges(SubmitChanges event) async* {
    if (state.status == ProfileStatus.submitting) return;
    final adminCredentials =
        await _userRepository.getBuiltInAdminEmailAccount();
    final managerEmail = await _userRepository.getBuiltInManagerUserEmail();
    ////////////////////////////////////////////////////////////////////
    // Error Handling                                                 //
    ////////////////////////////////////////////////////////////////////
    if ((managerEmail == '' && state.managerEmail == '') ||
        (adminCredentials.length == 0 &&
            (state.adminEmail == '' || state.adminPassword == ''))) {
      yield state.copyWith(
        status: ProfileStatus.error,
        failure: Failure(
          message:
              'Please register Manager Email, Admin Email and Admin Email Password.\nEnable less secure apps to access Gmail.',
        ),
      );
    } else if (adminCredentials.length != 0 &&
        (state.username == user.username &&
            state.adminEmail == adminCredentials[0] &&
            state.adminPassword == adminCredentials[1] &&
            state.managerEmail == managerEmail)) {
      yield state.copyWith(
        status: ProfileStatus.error,
        failure: Failure(
          message: 'Nothing to update.',
        ),
      );
    } else {
      ////////////////////////////////////////////////////////////////////
      // Updating Data                                                  //
      ////////////////////////////////////////////////////////////////////
      yield state.copyWith(status: ProfileStatus.submitting);
      try {
        /* if (state.password != '') {
        await _authRepository.updatePassword(password: state.password);
      } */

        print('Admin Email: ' + state.adminEmail);
        print('Admin Password: ' + state.adminPassword);
        final updatedUser = state.user.copyWith(
          username: state.username != '' ? state.username : user.username,
        );

        await _userRepository.updateUser(user: updatedUser);

        await _userRepository.builtInManagerUserEmail(
            email:
                state.managerEmail != '' ? state.managerEmail : managerEmail);
        await _userRepository.builtInAdminEmailAccount(
          email:
              state.adminEmail != '' ? state.adminEmail : adminCredentials[0],
          password: state.adminPassword != ''
              ? state.adminPassword
              : adminCredentials[1],
        );

        yield state.copyWith(status: ProfileStatus.success);
      } on Failure catch (err) {
        yield state.copyWith(
          failure: Failure(code: err.code, message: err.message),
          status: ProfileStatus.error,
        );
      }
    }
  }

  Stream<ProfileState> _mapToogleViewPassword(ToogleViewPassword event) async* {
    yield state.copyWith(
        status: ProfileStatus.initial, isPassVisible: !event.isVisible);
  }

  Stream<ProfileState> _mapReset(Reset event) async* {
    yield ProfileState.initial();
  }

  Stream<ProfileState> _mapLogOut(LogOut event) async* {
    await _authRepository.logOut();
  }
}
