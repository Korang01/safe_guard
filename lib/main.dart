import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:safe_guard/src/core/states/onboarding/state_notifiers.dart';
import 'package:safe_guard/src/ui/views/main_page_navigator/main_page_navigator_wrapper.dart';

import 'config/theme/theme.dart';
import 'firebase_options.dart';
import 'src/core/database/shared_preference.dart';
import 'src/core/states/main_page_data/state_notifiers.dart';
import 'src/ui/views/welcome/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalPreference.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final ProviderContainer container = ProviderContainer();
  container.read(onbaordingProvider.notifier).checkOnboardingState();
  if (LocalPreference.isLoggedIn) {
    await container.read(mainPageStateProvider.notifier).fetchUserInfo();
  }
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const SafeGuardRoot(),
    ),
  );
}

class SafeGuardRoot extends ConsumerWidget {
  const SafeGuardRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeModeProvider);
    return MaterialApp(
      darkTheme: darkTheme,
      theme: lightTheme,
      themeMode: theme,
      home: const AuthenticationSwitcher(),
    );
  }
}

class AuthenticationSwitcher extends ConsumerWidget {
  const AuthenticationSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardState = ref.watch(onbaordingProvider);
    if (onboardState is Authenticated) {
      return const MainPageNavigationWrapper();
    } else {
      return const WelcomeView();
    }
  }
}
