import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import 'brand_art.dart';

class MainShell extends StatelessWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        indicatorColor: AppColors.honeyGold.withValues(alpha: 0.45),
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: BrandImage.hexagon(size: 48, zoom: 1.45),
            selectedIcon: BrandImage.hexagon(size: 52, zoom: 1.45),
            label: '재고',
          ),
          NavigationDestination(
            icon: BrandImage.honeyJar(size: 48, zoom: 1.45),
            selectedIcon: BrandImage.honeyJar(size: 52, zoom: 1.45),
            label: '장바구니',
          ),
          NavigationDestination(
            icon: BrandImage.settings(size: 48, zoom: 1.45),
            selectedIcon: BrandImage.settings(size: 52, zoom: 1.45),
            label: '설정',
          ),
        ],
      ),
    );
  }
}
