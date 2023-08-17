part of 'state_notifiers.dart';

abstract class MainPageStates extends Equatable {}

class MainPageInitial extends MainPageStates {
  @override
  List<Object?> get props => [];
}

class MainPageLoading extends MainPageStates {
  @override
  List<Object?> get props => [];
}

class MainPageSuccess extends MainPageStates {
  @override
  List<Object?> get props => [];
}

class MainPageFailure extends MainPageStates {
  MainPageFailure({this.error});
  final String? error;
  @override
  List<Object?> get props => [error];
}
