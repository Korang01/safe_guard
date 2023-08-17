import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:safe_guard/src/core/models/registration_request_data.dart';
import 'package:safe_guard/src/core/repository/repositories.dart';
import 'package:safe_guard/src/core/states/main_page_data/state_notifiers.dart';
import 'package:safe_guard/src/core/states/onboarding/state_notifiers.dart';

import '../../database/shared_preference.dart';

part 'providers.dart';
part 'states.dart';

class AuthenticationStateNotifier extends StateNotifier<AuthenticationStates> {
  AuthenticationStateNotifier({required this.ref}) : super(AuthenticationInitial());
  final AuthenticationRepository _authenticationRepository = AuthenticationRepository();
  final Ref ref;

  /// perform email sign in
  Future<void> emailSignIn({required String email, required String password}) async {
    try {
      /// Set authentication state to loading
      state = AuthenticationLoading();

      /// attempt login with firebase via authentication repository
      final response = await _authenticationRepository.emailSignIn(email: email, password: password);

      /// check if login attempt was successful
      if (response.status) {
        /// write user ID to local storage
        await LocalPreference.writeStringToStorage(
          key: LocalPreference.KEY_USER_ID,
          value: response.data!,
        );

        /// Set onboarding state state to onboarded
        await ref.read(onbaordingProvider.notifier).setAuthenticated();

        /// fetch main page data if authentication is successful
        await ref.read(mainPageStateProvider.notifier).fetchUserInfo();

        /// set authentication state to success afterwards
        state = AuthenticationSuccess();
      } else {
        /// set authentication state to failure if login attempt is unsuccessful
        state = AuthenticationFailure(error: response.message);
      }
    } catch (err) {
      /// set authentication state to failure if an unknown error occurs
      state = AuthenticationFailure(error: err.toString());
    }
  }

  /// perform email registration
  Future<void> emailRegistration({required RegistrationRequestData data}) async {
    try {
      /// Set authentication state to loading
      state = AuthenticationLoading();

      /// attempt login with firebase via authentication repository
      final response = await _authenticationRepository.emailRegistration(data: data);

      /// check if login attempt was successful
      if (response.status) {
        /// write user ID to local storage
        await LocalPreference.writeStringToStorage(key: LocalPreference.KEY_USER_ID, value: response.data!);

        /// Set onboarding state state to onboarded
        await ref.read(onbaordingProvider.notifier).setAuthenticated();

        /// fetch main page data if authentication is successful
        await ref.read(mainPageStateProvider.notifier).fetchUserInfo();

        /// set authentication state to success afterwards
        state = AuthenticationSuccess();
      } else {
        /// set authentication state to failure if login attempt is unsuccessful
        state = AuthenticationFailure(error: response.message);
      }
    } catch (err) {
      /// set authentication state to failure if an unknown error occurs
      state = AuthenticationFailure(error: err.toString());
    }
  }

  Future<void> googleSignIn() async {
    try {
      /// Set authentication state to loading
      state = AuthenticationLoading();

      /// attempt login with firebase via authentication repository
      final response = await _authenticationRepository.loginWithGoogle();

      /// check if login attempt was successful
      if (response.status) {
        /// write user ID to local storage
        await LocalPreference.writeStringToStorage(
          key: LocalPreference.KEY_USER_ID,
          value: response.data!,
        );

        /// Set onboarding state state to onboarded
        await ref.read(onbaordingProvider.notifier).setAuthenticated();

        /// fetch main page data if authentication is successful
        await ref.read(mainPageStateProvider.notifier).fetchUserInfo();

        /// set authentication state to success afterwards
        state = AuthenticationSuccess();
      } else {
        /// set authentication state to failure if login attempt is unsuccessful
        state = AuthenticationFailure(error: response.message);
      }
    } catch (err) {
      /// set authentication state to failure if an unknown error occurs
      state = AuthenticationFailure(error: err.toString());
    }
  }

  Future<void> signOut() async {
    state = AuthenticationLoading();
    await _authenticationRepository.signOut();
    ref.read(onbaordingProvider.notifier).setUnAuthenticated();
    state = AuthenticationLogoutSuccess();
  }

  Future<void> forgotPassword({required String email}) async {
    state = AuthenticationLoading();
    final response = await _authenticationRepository.forgotPassword(email: email);
    if (response.status) {
      state = AuthenticationForgotPasswordSuccess();
    } else {
      state = AuthenticationForgotPasswordFailure(error: response.message);
    }
  }
}
