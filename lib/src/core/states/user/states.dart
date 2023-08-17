part of 'state_notifiers.dart';

abstract class UserStates extends Equatable {}

class UserInitial extends UserStates {
  @override
  List<Object?> get props => [];
}

class UserLoading extends UserStates {
  @override
  List<Object?> get props => [];
}

class UserUpdateLoading extends UserStates {
  @override
  List<Object?> get props => [];
}

class UserSuccess extends UserStates {
  UserSuccess({required this.user});
  final SafeGuardUser user;
  @override
  List<Object?> get props => [user];
}

class UserFailure extends UserStates {
  UserFailure({this.error});
  final String? error;
  @override
  List<Object?> get props => [error];
}
