import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:safe_guard/src/ui/views/authentication/registration.dart';
import 'package:safe_guard/src/ui/views/authentication/sign_in.dart';
import 'package:safe_guard/utils/extensions/alignment.dart';
import 'package:safe_guard/utils/extensions/padding.dart';

class WelcomeView extends ConsumerStatefulWidget {
  const WelcomeView({super.key});

  @override
  ConsumerState createState() => _WelcomeViewState();
}

class _WelcomeViewState extends ConsumerState<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/welcome.svg'),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const RegistrationView(),
                    ),
                  );
                },
                child: const Text('Sign up'),
              ).paddingOnly(right: 8).expanded(),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const LoginView(),
                    ),
                  );
                },
                child: const Text('Sign in'),
              ).paddingOnly(left: 8).expanded()
            ],
          )
        ],
      ).paddingSymmetric(horizontal: 20),
    );
  }
}
