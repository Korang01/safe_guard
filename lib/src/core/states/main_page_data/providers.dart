part of 'state_notifiers.dart';

final mainPageStateProvider = StateNotifierProvider<MainPageStateNotifier, MainPageStates>(
  (ref) => MainPageStateNotifier(ref: ref),
);
