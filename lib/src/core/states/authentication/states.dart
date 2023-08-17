part of 'state_notifier.dart';

///
abstract class AuthenticationStates extends Equatable {}

///
class AuthenticationInitial extends AuthenticationStates {
  @override
  List<Object?> get props => [];
}

///
class AuthenticationLoading extends AuthenticationStates {
  @override
  List<Object?> get props => [];
}

///
class AuthenticationSuccess extends AuthenticationStates {
  @override
  List<Object?> get props => [];
}

///
class AuthenticationForgotPasswordSuccess extends AuthenticationStates {
  @override
  List<Object?> get props => [];
}

///
class AuthenticationForgotPasswordFailure extends AuthenticationStates {
  AuthenticationForgotPasswordFailure({this.error});
  final String? error;
  @override
  List<Object?> get props => [error];
}

///
class AuthenticationLogoutSuccess extends AuthenticationStates {
  @override
  List<Object?> get props => [];
}

///
class AuthenticationFailure extends AuthenticationStates {
  AuthenticationFailure({this.error});
  final String? error;
  @override
  List<Object?> get props => [error];
}
