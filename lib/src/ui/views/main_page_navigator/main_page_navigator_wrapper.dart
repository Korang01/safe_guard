import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:safe_guard/src/ui/views/home/home.dart';
import 'package:safe_guard/src/ui/views/profile/profile.dart';

class MainPageNavigationWrapper extends ConsumerStatefulWidget {
  const MainPageNavigationWrapper({super.key});

  @override
  ConsumerState createState() => _MainPageNavigationWrapperState();
}

class _MainPageNavigationWrapperState extends ConsumerState<MainPageNavigationWrapper> {
  int currentPage = 0;
  final List<Widget> pages = [
    const HomeView(),
    const ProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(IconlyLight.home), selectedIcon: Icon(IconlyBold.home), label: 'Home'),
          NavigationDestination(
              icon: Icon(IconlyLight.profile), selectedIcon: Icon(IconlyBold.profile), label: 'Profile'),
        ],
        selectedIndex: currentPage,
        onDestinationSelected: (newIndex) {
          setState(() {
            currentPage = newIndex;
          });
        },
      ),
      body: IndexedStack(index: currentPage, children: pages),
    );
  }
}
