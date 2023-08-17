import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:safe_guard/src/core/states/authentication/state_notifier.dart';
import 'package:safe_guard/utils/extensions/padding.dart';
import 'package:safe_guard/utils/mixins/input_validation_mixins.dart';
import 'package:safe_guard/utils/overlays/authentication_loading_overlay/loading_screen.dart';

class ForgotPasswordView extends ConsumerStatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  ConsumerState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordView> with InputValidationMixin {
  late final TextEditingController emailTextController;
  final ValueNotifier<bool?> formIsValid = ValueNotifier(null);
  @override
  void initState() {
    super.initState();
    emailTextController = TextEditingController();
  }

  void validate() {
    formIsValid.value = isEmailValid(email: emailTextController.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ref.listen(authenticationStateProvider, (previous, state) {
      if (state is AuthenticationLoading) {
        AuthenticationLoadingScreen.instance().show(context: context);
      } else if (state is AuthenticationForgotPasswordSuccess) {
        AuthenticationLoadingScreen.instance().hide();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email successfully sent'),
          ),
        );
        Navigator.of(context).pop();
      } else {
        AuthenticationLoadingScreen.instance().hide();
      }
    });
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Forgot password', style: theme.textTheme.titleLarge).paddingOnly(top: 48),
          Text(
            "Please enter your email in the field below. A password reset link link will be sent through the email",
            style: theme.textTheme.bodyMedium,
          ).paddingOnly(bottom: 24),
          TextField(
            controller: emailTextController,
            onChanged: (_) {
              validate();
            },
            decoration: const InputDecoration(labelText: 'Email'),
          ).paddingOnly(bottom: 24),
          ValueListenableBuilder(
              valueListenable: formIsValid,
              builder: (context, valid, _) {
                return FilledButton(
                  onPressed: valid == true
                      ? () async {
                          await ref.read(authenticationStateProvider.notifier).forgotPassword(
                                email: emailTextController.text,
                              );
                        }
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: theme.colorScheme.error,
                              content: const Text('Please provide a valid email address'),
                            ),
                          );
                        },
                  child: const Text('Send link'),
                ).paddingOnly(bottom: 120);
              }),
        ],
      ).paddingSymmetric(horizontal: 20),
    );
  }
}
