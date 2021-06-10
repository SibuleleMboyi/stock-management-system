part of 'profile_bloc.dart';

enum ProfileStatus { initial, submitting, success, error }

@immutable
class ProfileState extends Equatable {
  final User user;
  final String adminEmail;
  final String adminPassword;
  final String managerEmail;
  final String username;
  final String password;
  final bool isPassVisible;
  final ProfileStatus status;
  final Failure failure;

  ProfileState({
    @required this.user,
    @required this.adminEmail,
    @required this.adminPassword,
    @required this.managerEmail,
    @required this.username,
    @required this.password,
    @required this.isPassVisible,
    @required this.status,
    @required this.failure,
  });

  @override
  List<Object> get props => [
        user,
        adminEmail,
        adminPassword,
        managerEmail,
        username,
        password,
        isPassVisible,
        status,
        failure,
      ];

  factory ProfileState.initial() {
    return ProfileState(
      user: User.empty,
      adminEmail: '',
      adminPassword: '',
      managerEmail: '',
      username: '',
      password: '',
      isPassVisible: true,
      status: ProfileStatus.initial,
      failure: Failure(),
    );
  }

  ProfileState copyWith({
    User user,
    String adminEmail,
    String adminPassword,
    String managerEmail,
    String username,
    String password,
    bool isPassVisible,
    ProfileStatus status,
    Failure failure,
  }) {
    return ProfileState(
      user: user ?? this.user,
      adminEmail: adminEmail ?? this.adminEmail,
      adminPassword: adminPassword ?? this.adminPassword,
      managerEmail: managerEmail ?? this.managerEmail,
      username: username ?? this.username,
      password: password ?? this.password,
      isPassVisible: isPassVisible ?? this.isPassVisible,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
