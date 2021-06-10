part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileLoadInitialInfo extends ProfileEvent {
  ProfileLoadInitialInfo();

  @override
  List<Object> get props => [];
}

class ManagerEmailChanged extends ProfileEvent {
  final String managerEmail;

  ManagerEmailChanged({@required this.managerEmail});

  @override
  List<Object> get props => [managerEmail];
}

class AdminEmailChanged extends ProfileEvent {
  final String adminEmail;

  AdminEmailChanged({@required this.adminEmail});

  @override
  List<Object> get props => [adminEmail];
}

class AdminEmailPasswordChanged extends ProfileEvent {
  final String adminEmailPassword;

  AdminEmailPasswordChanged({@required this.adminEmailPassword});

  @override
  List<Object> get props => [adminEmailPassword];
}

class UsernameChanged extends ProfileEvent {
  final String username;

  UsernameChanged({@required this.username});

  @override
  List<Object> get props => [username];
}

class SubmitChanges extends ProfileEvent {}

class Reset extends ProfileEvent {}

class LogOut extends ProfileEvent {}

class ToogleViewPassword extends ProfileEvent {
  final bool isVisible;

  ToogleViewPassword({@required this.isVisible});

  @override
  List<Object> get props => [isVisible];
}
