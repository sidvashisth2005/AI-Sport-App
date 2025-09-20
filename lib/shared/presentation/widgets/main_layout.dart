import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/providers/app_providers.dart';
import 'glass_card.dart';
import '../../../core/router/app_router.dart';

class MainLayout extends ConsumerStatefulWidget {
  final Widget child;
  
  const MainLayout({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  int _selectedIndex = 0;
  
  final List<BottomNavItem> _navItems = [
    BottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
      route: '/home',
    ),
    BottomNavItem(
      icon: Icons.history_outlined,
      activeIcon: Icons.history,
      label: 'History',
      route: '/history',
    ),
    BottomNavItem(
      icon: Icons.leaderboard_outlined,
      activeIcon: Icons.leaderboard,
      label: 'Leaderboard',
      route: '/leaderboard',
    ),
    BottomNavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
      route: '/profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F0F0F),
              AppColors.deepCharcoal,
              Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: widget.child,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 80,
      margin: const EdgeInsets.all(16),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 8),
        borderRadius: 32,
        showShadow: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _navItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = index == _selectedIndex;
            
            return _buildNavItem(item, isSelected, index);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNavItem(BottomNavItem item, bool isSelected, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index, item.route),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected 
              ? AppColors.neonGreen.withOpacity(0.2)
              : Colors.transparent,
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.neonGreen.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ] : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              color: isSelected 
                  ? AppColors.neonGreen 
                  : AppColors.textTertiary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                color: isSelected 
                    ? AppColors.neonGreen 
                    : AppColors.textTertiary,
                fontSize: 10,
                fontWeight: isSelected 
                    ? FontWeight.w600 
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index, String route) {
    setState(() {
      _selectedIndex = index;
    });
    
    ref.read(bottomNavProvider.notifier).setIndex(index);
    context.go(route);
  }
}

class BottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  
  const BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

class AppBarGlass extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final double elevation;
  final bool centerTitle;
  final Color? backgroundColor;
  final double toolbarHeight;
  
  const AppBarGlass({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.elevation = 0,
    this.centerTitle = true,
    this.backgroundColor,
    this.toolbarHeight = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      decoration: BoxDecoration(
        color: (backgroundColor ?? Colors.white).withOpacity(0.08),
        border: const Border(
          bottom: BorderSide(
            color: AppColors.glassBorder,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (leading != null)
                leading!
              else if (automaticallyImplyLeading && Navigator.canPop(context))
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: AppColors.textPrimary,
                  onPressed: () => Navigator.pop(context),
                ),
              
              if (centerTitle) const Spacer(),
              
              if (titleWidget != null)
                titleWidget!
              else if (title != null)
                Text(
                  title!,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              
              if (centerTitle) const Spacer(),
              
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight + MediaQuery.of(NavigatorService.navigatorKey.currentContext!).padding.top);
}

class FloatingGlassAppBar extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final VoidCallback? onBack;
  
  const FloatingGlassAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderRadius: 20,
          child: Row(
            children: [
              if (leading != null)
                leading!
              else if (automaticallyImplyLeading && (Navigator.canPop(context) || onBack != null))
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: AppColors.textPrimary,
                  onPressed: onBack ?? () => Navigator.pop(context),
                ),
              
              const Spacer(),
              
              if (titleWidget != null)
                titleWidget!
              else if (title != null)
                Text(
                  title!,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              
              const Spacer(),
              
              if (actions != null) 
                ...actions!
              else 
                const SizedBox(width: 48), // Balance the back button
            ],
          ),
        ),
      ),
    );
  }
}
