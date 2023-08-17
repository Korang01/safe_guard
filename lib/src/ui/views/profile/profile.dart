import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe_guard/src/core/repository/repositories.dart';
import 'package:safe_guard/src/core/states/authentication/state_notifier.dart';
import 'package:safe_guard/src/core/states/user/state_notifiers.dart';
import 'package:safe_guard/src/ui/views/profile/edit_profile.dart';
import 'package:safe_guard/utils/extensions/padding.dart';
import 'package:safe_guard/utils/platform/image.dart';

import '../../../../utils/overlays/authentication_loading_overlay/loading_screen.dart';
import '../../../core/states/main_page_data/state_notifiers.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(userStateProvider);
    ref.listen(authenticationStateProvider, (previous, state) {
      if (state is AuthenticationLoading) {
        AuthenticationLoadingScreen.instance().show(context: context);
      } else {
        AuthenticationLoadingScreen.instance().hide();
      }
      if (state is AuthenticationLogoutSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign out successful'),
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
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          ref.read(mainPageStateProvider.notifier).fetchUserInfo();
        },
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(),
            if (user is UserSuccess)
              SliverList.list(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colorScheme.primary),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 32,
                              child: user.user.imageUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(400),
                                      child: CachedNetworkImage(
                                          imageUrl: user.user.imageUrl ?? '', height: 64, width: 64, fit: BoxFit.fill),
                                    )
                                  : null,
                            ),
                            TextButton.icon(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const EditProfileView(),
                                    ),
                                  );
                                },
                                label: const Text('Edit'),
                                icon: const Icon(Iconsax.edit)),
                          ],
                        ).paddingOnly(bottom: 16),
                        Text(user.user.fullName ?? 'No name', style: theme.textTheme.titleMedium),
                        Text(user.user.email, style: theme.textTheme.bodyMedium).paddingOnly(bottom: 4),
                      ],
                    ),
                  ).paddingOnly(bottom: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colorScheme.primary),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Table(
                          children: [
                            buildProfileTable(
                              context: context,
                              leadingText: 'Age',
                              trailingText: user.user.dateOfBirth != null
                                  ? '${(DateTime.now().difference(
                                        user.user.dateOfBirth!,
                                      )).abs().inDays ~/ 365} years'
                                  : 'N/A',
                            ),
                            buildProfileTable(
                                context: context,
                                leadingText: 'Height (cm)',
                                trailingText: '${user.user.height ?? 'N/A'}'),
                            buildProfileTable(
                                context: context,
                                leadingText: 'Weight (kg)',
                                trailingText: '${user.user.weight ?? 'N/A'}'),
                            buildProfileTable(
                              context: context,
                              leadingText: 'Known allergies',
                              trailingText: user.user.allergies
                                      ?.map((e) => e)
                                      .toString()
                                      .replaceAll('(', '')
                                      .replaceAll(')', '') ??
                                  'N/A',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).paddingOnly(bottom: 32),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colorScheme.primary),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () async {
                            XFile? file = await ImagePickerUtil.openGallery();
                            await UserRepository().uploadImage(file: file!);
                          },
                          title: const Text('Account'),
                          subtitle: const Text('Manage you account and details'),
                          trailing: const Icon(Iconsax.arrow_circle_right),
                        ),
                        const ListTile(
                          title: Text('Preferences'),
                          subtitle: Text('Customize your app preferences to get the best experience'),
                          trailing: Icon(Iconsax.arrow_circle_right),
                        ),
                      ],
                    ),
                  ).paddingOnly(bottom: 32),
                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.colorScheme.error),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        onTap: () async {
                          ref.read(authenticationStateProvider.notifier).signOut();
                        },
                        textColor: theme.colorScheme.error,
                        iconColor: theme.colorScheme.error,
                        title: const Text('Sign out'),
                        trailing: const Icon(Iconsax.logout),
                      )).paddingOnly(bottom: 32)
                ],
              ).sliverPaddingSymmetric(horizontal: 20)
            else if (user is UserLoading)
              const SliverFillRemaining(
                child: CircularProgressIndicator.adaptive(),
              )
            else if (user is UserFailure)
              SliverFillRemaining(
                child: Text(user.error ?? "Unknown error occurred"),
              )
          ],
        ),
      ),
    );
  }
}

TableRow buildProfileTable({required BuildContext context, required String leadingText, required String trailingText}) {
  final theme = Theme.of(context);
  return TableRow(children: [
    Text(leadingText, style: theme.textTheme.bodyMedium),
    Text(trailingText, style: theme.textTheme.bodyLarge),
  ]);
}
