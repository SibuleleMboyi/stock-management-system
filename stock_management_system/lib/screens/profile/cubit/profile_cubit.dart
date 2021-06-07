import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stock_management_system/blocs/blocs.dart';
import 'package:stock_management_system/models/models.dart';
import 'package:stock_management_system/repositories/repositories.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final AuthBloc _authBloc;
  List<String> _adminCredentials;
  String _managerEmail;
  ProfileCubit({
    @required AuthRepository authRepository,
    @required UserRepository userRepository,
    @required AuthBloc authBloc,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        _authBloc = authBloc,
        super(ProfileState.initial()) {
    loadExtraData();
  }

  void loadExtraData() async {
    final list = await _userRepository.getBuiltInAdminEmailAccount();
    final String managerEmail =
        await _userRepository.getBuiltInManagerUserEmail();
    final currentUserId = _authBloc.state.user.uid;
    final user = await _userRepository.getUserWithId(userId: currentUserId);

    _adminCredentials = list;
    _managerEmail = managerEmail;

    emit(
      state.copyWith(
        user: user,
        adminEmail: list[0],
        adminPassword: list[1],
        managerEmail: managerEmail,
        status: ProfileStatus.initial,
      ),
    );
  }

  void usernameChanged(String value) {
    emit(state.copyWith(username: value, status: ProfileStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: ProfileStatus.initial));
  }

  void adminEmailChanged(String value) {
    emit(state.copyWith(adminEmail: value, status: ProfileStatus.initial));
  }

  void managerEmailChanged(String value) {
    emit(state.copyWith(managerEmail: value, status: ProfileStatus.initial));
  }

  void adminPasswordChanged(String value) {
    emit(state.copyWith(adminPassword: value, status: ProfileStatus.initial));
  }

  void logOut() async {
    await _authRepository.logOut();
  }

  void submit() async {
    // print(state.user.username);
    if (state.status == ProfileStatus.submitting) return;

    if (_managerEmail == null || _adminCredentials.isEmpty) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          failure: Failure(
            message:
                'Please register Manager Email, Admin Email and Admin Password and  \n Enable less secure apps to access Gmail.',
          ),
        ),
      );
    }

    emit(state.copyWith(status: ProfileStatus.submitting));
    try {
      /* if (state.password != '') {
        await _authRepository.updatePassword(password: state.password);
      } */

      print('Admin Email: ' + state.adminEmail);
      print('Admin Password: ' + state.adminPassword);
      final updatedUser = state.user.copyWith(
        username: state.username,
      );

      await _userRepository.updateUser(user: updatedUser);

      await _userRepository.builtInManagerUserEmail(email: state.managerEmail);
      await _userRepository.builtInAdminEmailAccount(
        email: state.adminEmail,
        password: state.adminPassword,
      );

      emit(state.copyWith(status: ProfileStatus.success));
    } on Failure catch (err) {
      emit(
        state.copyWith(
          failure: Failure(code: err.code, message: err.message),
          status: ProfileStatus.error,
        ),
      );
    }
  }

  void reset() {
    emit(ProfileState.initial());
  }
}
