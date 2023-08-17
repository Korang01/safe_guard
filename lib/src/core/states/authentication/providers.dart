part of 'state_notifier.dart';

final authenticationStateProvider = StateNotifierProvider<AuthenticationStateNotifier, AuthenticationStates>(
  (ref) => AuthenticationStateNotifier(ref: ref),
);
