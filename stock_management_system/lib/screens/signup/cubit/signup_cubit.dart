import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:stock_management_system/models/models.dart';
import 'package:stock_management_system/repositories/auth/auth_repository.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository _authRepository;

  SignupCubit({
    @required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(SignupState.initial());

  void usernameChanged(String value) {
    emit(state.copyWith(username: value, status: SignupStatus.initial));
  }

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SignupStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SignupStatus.initial));
  }

  void userTypeChanged(String value) {
    emit(state.copyWith(userType: value, status: SignupStatus.initial));
  }

  void onSelectedItemChanged(String value) {
    emit(state.copyWith(userType: value));
  }

  void signUpWithCredentials() async {
    if (!state.isFormValid || state.status == SignupStatus.submitting) {
      return;
    }
    try {
      await _authRepository.signUpWithEmailAndPassword(
        username: state.username,
        email: state.email,
        password: state.password,
        userType: state.userType,
      );
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: SignupStatus.error));
    }
  }
}
