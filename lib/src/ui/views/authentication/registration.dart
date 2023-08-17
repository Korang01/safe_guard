import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:safe_guard/src/core/models/registration_request_data.dart';
import 'package:safe_guard/src/core/states/authentication/state_notifier.dart';
import 'package:safe_guard/src/ui/views/authentication/sign_in.dart';
import 'package:safe_guard/utils/extensions/alignment.dart';
import 'package:safe_guard/utils/extensions/dismiss_keyboard.dart';
import 'package:safe_guard/utils/extensions/padding.dart';
import 'package:safe_guard/utils/extensions/spacing.dart';
import 'package:safe_guard/utils/mixins/input_validation_mixins.dart';

import '../../../../utils/overlays/authentication_loading_overlay/loading_screen.dart';
import '../welcome/rich_text_widget/rich_text.dart';

class RegistrationView extends ConsumerStatefulWidget {
  const RegistrationView({super.key});

  @override
  ConsumerState createState() => _RegistrationViewState();
}

class _RegistrationViewState extends ConsumerState<RegistrationView> with InputValidationMixin {
  late final TextEditingController nameTextController;
  late final TextEditingController emailTextController;
  late final TextEditingController passwordTextController;
  late final TextEditingController retypePassword;

  final ValueNotifier<bool?> formIsValid = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    nameTextController = TextEditingController();
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    retypePassword = TextEditingController();
  }

  void validate() {
    formIsValid.value = nameTextController.text.trim().isNotEmpty &&
        isEmailValid(email: emailTextController.text) &&
        isPasswordValid(password: passwordTextController.text) &&
        passwordTextController.text == retypePassword.text;
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
            content: Text('Account creation successful'),
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
          Text('Sign up', style: theme.textTheme.titleLarge).paddingOnly(top: 48),
          Text("Tell us more about yourself to get started", style: theme.textTheme.bodyMedium).paddingOnly(bottom: 32),
          TextField(
            controller: nameTextController,
            onChanged: (_) {
              validate();
            },
            decoration: const InputDecoration(labelText: 'Full name'),
          ).paddingOnly(bottom: 16),
          TextField(
            controller: emailTextController,
            onChanged: (_) {
              validate();
            },
            decoration: const InputDecoration(labelText: 'Email'),
          ).paddingOnly(bottom: 16),
          TextField(
            controller: passwordTextController,
            obscureText: true,
            onChanged: (_) {
              validate();
            },
            decoration: const InputDecoration(labelText: 'Password'),
          ).paddingOnly(bottom: 16),
          TextField(
            controller: retypePassword,
            obscureText: true,
            onChanged: (_) {
              validate();
            },
            decoration: const InputDecoration(labelText: 'Confirm password'),
          ).paddingOnly(bottom: 24),
          ValueListenableBuilder(
              valueListenable: formIsValid,
              builder: (context, isValid, _) {
                return FilledButton(
                  onPressed: isValid == true
                      ? () async {
                          await ref.read(authenticationStateProvider.notifier).emailRegistration(
                                data: RegistrationRequestData(
                                  email: emailTextController.text,
                                  password: passwordTextController.text,
                                  fullName: nameTextController.text,
                                ),
                              );
                        }
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: theme.colorScheme.error,
                              content: const Text('Please fill all fields'),
                            ),
                          );
                        },
                  child: const Text('Register'),
                );
              }).paddingOnly(bottom: 24),
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
              BaseText.plain(text: 'Already have an account?  '),
              BaseText.custom(
                text: 'Sign in here',
                onTapped: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const LoginView(),
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
