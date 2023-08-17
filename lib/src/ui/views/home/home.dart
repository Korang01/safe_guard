import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:safe_guard/src/core/states/main_page_data/state_notifiers.dart';
import 'package:safe_guard/src/core/states/user/state_notifiers.dart';
import 'package:safe_guard/utils/extensions/padding.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userStateProvider);
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
            backgroundColor: theme.colorScheme.errorContainer,
            foregroundColor: theme.colorScheme.onErrorContainer,
          ),
          onPressed: () {},
          icon: const Icon(Iconsax.info_circle),
          label: const Text('data')),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          ref.read(mainPageStateProvider.notifier).fetchUserInfo();
        },
        child: CustomScrollView(
          slivers: [
            if (user is UserSuccess) ...[
              SliverAppBar(
                centerTitle: false,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      child: user.user.imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(400),
                              child: CachedNetworkImage(
                                  imageUrl: user.user.imageUrl ?? '', height: 64, width: 64, fit: BoxFit.fill),
                            )
                          : null,
                    ).paddingOnly(right: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hey there',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          user.user.fullName ?? 'New user',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SliverList.list(
                children: [
                  Text(
                    'Report an incident to get assistance',
                    style: theme.textTheme.titleMedium,
                  ).paddingOnly(bottom: 24),
                  ...List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: theme.colorScheme.secondaryContainer),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Crime',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ).sliverPaddingSymmetric(horizontal: 20, vertical: 24)
            ] else if (user is UserLoading)
              const SliverFillRemaining(
                child: CircularProgressIndicator.adaptive(),
              )
          ],
        ),
      ),
    );
  }
}
