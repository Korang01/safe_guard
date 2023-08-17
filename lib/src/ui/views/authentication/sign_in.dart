import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:safe_guard/src/core/states/authentication/state_notifier.dart';
import 'package:safe_guard/src/ui/views/authentication/forgot_password.dart';
import 'package:safe_guard/src/ui/views/authentication/registration.dart';
import 'package:safe_guard/src/ui/views/welcome/rich_text_widget/rich_text.dart';
import 'package:safe_guard/utils/extensions/alignment.dart';
import 'package:safe_guard/utils/extensions/dismiss_keyboard.dart';
import 'package:safe_guard/utils/extensions/padding.dart';
import 'package:safe_guard/utils/extensions/spacing.dart';
import 'package:safe_guard/utils/overlays/authentication_loading_overlay/loading_screen.dart';

import '../../../../utils/mixins/input_validation_mixins.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> with InputValidationMixin {
  late final TextEditingController emailTextController;
  late final TextEditingController passwordTextController;
  final ValueNotifier<bool?> formIsValid = ValueNotifier(null);

  bool obscurePassword = true;
  @override
  void initState() {
    super.initState();
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
  }

  void validate() {
    formIsValid.value = isEmailValid(email: emailTextController.text) &&
        isPasswordValid(
          password: passwordTextController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ref.listen(authenticationStateProvider, (previous, state) {
      if (state is AuthenticationLoading) {
        AuthenticationLoadingScreen.instance().show(context: context);
      } else {
        AuthenticationLoadingScreen.instance().hide();
      }
      if (state is AuthenticationSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful'),
          ),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else if (state is AuthenticationFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: theme.colorScheme.error,
            content: Text(state.error!),
          ),
        );
      }
    });
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text('Sign in', style: theme.textTheme.titleLarge).paddingOnly(top: 48),
          Text("First let's make sure you're you", style: theme.textTheme.bodyMedium).paddingOnly(bottom: 24),
          TextField(
            controller: emailTextController,
            onChanged: (_) {
              validate();
            },
            decoration: const InputDecoration(labelText: 'Email'),
          ).paddingOnly(bottom: 16),
          TextField(
            controller: passwordTextController,
            onChanged: (_) {
              validate();
            },
            obscureText: obscurePassword,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
                icon: Icon(obscurePassword ? Iconsax.eye : Iconsax.eye_slash),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ForgotPasswordView(),
                ),
              );
            },
            child: const Text('Forgot password?'),
          ).centerRightAlign(),
          FilledButton(
            onPressed: () {
              ref.read(authenticationStateProvider.notifier).emailSignIn(
                    email: emailTextController.text,
                    password: passwordTextController.text,
                  );
            },
            child: const Text('Login'),
          ).paddingOnly(bottom: 24),
          Row(
            children: [
              const Divider().expanded(),
              const Text('OR').paddingSymmetric(horizontal: 16),
              const Divider().expanded(),
            ],
          ).paddingOnly(bottom: 24),
          // OutlinedButton.icon(
          //   onPressed: () {},
          //   icon: SvgPicture.asset('assets/images/apple-logo.svg', height: 18),
          //   label: const Text('Continue with Apple'),
          // ).paddingOnly(bottom: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(
                side: BorderSide(color: theme.primaryColor),
              ),
            ),
            onPressed: () async {
              await ref.read(authenticationStateProvider.notifier).googleSignIn();
            },
            icon: SvgPicture.asset('assets/images/google-icon.svg', height: 18),
            label: const Text('Continue with Google'),
          ),
          const Spacer(),
          RichTextWidget(
            texts: [
              BaseText.plain(text: "Don't have an account?  "),
              BaseText.custom(
                text: "Sign up here",
                onTapped: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const RegistrationView(),
                    ),
                    (route) => route.isFirst,
                  );
                },
              ),
            ],
            textAlign: TextAlign.center,
          ).paddingOnly(bottom: 12).safeArea()
        ],
      ).paddingSymmetric(horizontal: 20),
    ).dismissFocus();
  }
}
