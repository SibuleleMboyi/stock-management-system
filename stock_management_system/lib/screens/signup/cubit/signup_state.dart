part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, success, error }

@immutable
class SignupState extends Equatable {
  final String username;
  final String email;
  final String password;
  final String userType;
  final SignupStatus status;
  final Failure failure;

  SignupState({
    @required this.email,
    @required this.password,
    @required this.username,
    @required this.userType,
    @required this.status,
    @required this.failure,
  });

  bool get isFormValid =>
      username.isNotEmpty &&
      email.isNotEmpty &&
      password.isNotEmpty &&
      userType.isNotEmpty;

  factory SignupState.initial() {
    return SignupState(
      username: null,
      email: null,
      password: null,
      userType: null,
      status: SignupStatus.initial,
      failure: const Failure(),
    );
  }

  @override
  List<Object> get props =>
      [username, email, password, userType, status, failure];

  SignupState copyWith({
    String username,
    String email,
    String password,
    String userType,
    SignupStatus status,
    Failure failure,
  }) {
    return SignupState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      userType: userType ?? this.userType,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
