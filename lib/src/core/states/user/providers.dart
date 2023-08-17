part of 'state_notifiers.dart';

final userStateProvider = StateNotifierProvider<UserStateNotifier, UserStates>(
  (ref) => UserStateNotifier(),
);
