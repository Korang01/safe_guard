import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../database/shared_preference.dart';

part 'states.dart';

class OnboardingStateNotifier extends StateNotifier<OnboardingStates> {
  OnboardingStateNotifier() : super(UnAuthenticated());
  void checkOnboardingState() {
    if (LocalPreference.isLoggedIn) {
      state = Authenticated();
    } else if (!LocalPreference.isLoggedIn) {
      state = UnAuthenticated();
    } else {
      state = UnAuthenticated();
    }
  }

  Future<void> setAuthenticated() async {
    await LocalPreference.writeBoolToStorage(key: LocalPreference.KEY_IS_LOGIN, value: true);
    checkOnboardingState();
  }

  Future<void> setUnAuthenticated() async {
    await LocalPreference.writeBoolToStorage(key: LocalPreference.KEY_IS_LOGIN, value: false);
    checkOnboardingState();
  }

  /// checks the state of the welcome cubit
  // Future<void> setWelcomeComplete() async {
  //   await LocalPreference.writeBoolToStorage(key: LocalPreference.KEY_ON_BOARDED, value: true);
  //   emit(WelcomeComplete());
  // }
}

final onbaordingProvider = StateNotifierProvider((ref) => OnboardingStateNotifier());
