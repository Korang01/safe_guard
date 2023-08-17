part of 'state_notifiers.dart';

///
sealed class OnboardingStates extends Equatable {}

class Authenticated extends OnboardingStates {
  @override
  List<Object?> get props => [];
}

class UnAuthenticated extends OnboardingStates {
  @override
  List<Object?> get props => [];
}

// class NotWelcomed extends OnboardingStates {
//   @override
//   List<Object?> get props => [];
// }
