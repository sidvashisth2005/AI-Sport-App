import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/app_providers.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _hapticFeedbackEnabled = true;
  bool _darkModeEnabled = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.deepCharcoal,
              AppColors.royalPurple,
              AppColors.electricBlue,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 120,
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Customize your experience',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                ),
              ),
              
              // Content
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // App Preferences
                    _buildSectionHeader('App Preferences'),
                    const SizedBox(height: 16),
                    _buildSwitchSetting(
                      icon: Icons.dark_mode,
                      title: 'Dark Mode',
                      subtitle: 'Use dark theme (recommended)',
                      value: _darkModeEnabled,
                      onChanged: (value) => setState(() => _darkModeEnabled = value),
                      color: AppColors.royalPurple,
                    ),
                    const SizedBox(height: 12),
                    _buildSwitchSetting(
                      icon: Icons.volume_up,
                      title: 'Sound Effects',
                      subtitle: 'Play sounds for interactions',
                      value: _soundEnabled,
                      onChanged: (value) => setState(() => _soundEnabled = value),
                      color: AppColors.electricBlue,
                    ),
                    const SizedBox(height: 12),
                    _buildSwitchSetting(
                      icon: Icons.vibration,
                      title: 'Haptic Feedback',
                      subtitle: 'Vibrate on touch interactions',
                      value: _hapticFeedbackEnabled,
                      onChanged: (value) => setState(() => _hapticFeedbackEnabled = value),
                      color: AppColors.neonGreen,
                    ),
                    const SizedBox(height: 16),
                    _buildSelectSetting(
                      icon: Icons.language,
                      title: 'Language',
                      subtitle: _selectedLanguage,
                      onTap: _showLanguageDialog,
                      color: AppColors.warmOrange,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Notifications
                    _buildSectionHeader('Notifications'),
                    const SizedBox(height: 16),
                    _buildSwitchSetting(
                      icon: Icons.notifications,
                      title: 'Push Notifications',
                      subtitle: 'Receive updates and reminders',
                      value: _notificationsEnabled,
                      onChanged: (value) => setState(() => _notificationsEnabled = value),
                      color: AppColors.neonGreen,
                    ),
                    const SizedBox(height: 12),
                    _buildSelectSetting(
                      icon: Icons.schedule,
                      title: 'Workout Reminders',
                      subtitle: 'Daily at 8:00 AM',
                      onTap: () {},
                      color: AppColors.electricBlue,
                      enabled: _notificationsEnabled,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Account
                    _buildSectionHeader('Account'),
                    const SizedBox(height: 16),
                    _buildSelectSetting(
                      icon: Icons.person,
                      title: 'Profile Settings',
                      subtitle: 'Manage your profile information',
                      onTap: () => context.go('/profile/edit'),
                      color: AppColors.electricBlue,
                    ),
                    const SizedBox(height: 12),
                    _buildSelectSetting(
                      icon: Icons.lock,
                      title: 'Change Password',
                      subtitle: 'Update your account password',
                      onTap: _showChangePasswordDialog,
                      color: AppColors.warmOrange,
                    ),
                    const SizedBox(height: 12),
                    _buildSelectSetting(
                      icon: Icons.download,
                      title: 'Export Data',
                      subtitle: 'Download your performance data',
                      onTap: () {},
                      color: AppColors.neonGreen,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Support
                    _buildSectionHeader('Support'),
                    const SizedBox(height: 16),
                    _buildSelectSetting(
                      icon: Icons.help_outline,
                      title: 'Help Center',
                      subtitle: 'Get help and support',
                      onTap: () => context.go('/help'),
                      color: AppColors.electricBlue,
                    ),
                    const SizedBox(height: 12),
                    _buildSelectSetting(
                      icon: Icons.feedback,
                      title: 'Send Feedback',
                      subtitle: 'Share your thoughts and suggestions',
                      onTap: () {},
                      color: AppColors.warmOrange,
                    ),
                    const SizedBox(height: 12),
                    _buildSelectSetting(
                      icon: Icons.info_outline,
                      title: 'About',
                      subtitle: 'Version 1.0.0',
                      onTap: _showAboutDialog,
                      color: AppColors.royalPurple,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Sign Out
                    NeonButton(
                      onPressed: _showSignOutDialog,
                      variant: NeonButtonVariant.outline,
                      width: double.infinity,
                      child: const Text('Sign Out'),
                    ),
                    
                    const SizedBox(height: 100), // Bottom padding for nav bar
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSwitchSetting({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color color,
    bool enabled = true,
  }) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: enabled ? onChanged : null,
              activeColor: color,
              activeTrackColor: color.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectSetting({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
    bool enabled = true,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: enabled ? Colors.white : AppColors.mutedText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: enabled ? AppColors.secondaryText : AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: enabled ? AppColors.secondaryText : AppColors.mutedText,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    final languages = ['English', 'हिंदी', 'தமிழ்', 'తెలుగు', 'मराठी'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Select Language',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((language) {
            return ListTile(
              title: Text(
                language,
                style: const TextStyle(color: Colors.white),
              ),
              leading: _selectedLanguage == language
                  ? const Icon(Icons.check, color: AppColors.neonGreen)
                  : null,
              onTap: () {
                setState(() => _selectedLanguage = language);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'You will be redirected to change your password securely.',
          style: TextStyle(color: AppColors.secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          NeonButton(
            onPressed: () => Navigator.pop(context),
            variant: NeonButtonVariant.primary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Sports Talent Assessment',
          style: TextStyle(color: Colors.white),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version 1.0.0',
              style: TextStyle(color: AppColors.secondaryText),
            ),
            SizedBox(height: 12),
            Text(
              'AI-powered sports talent assessment platform for athletes across India.',
              style: TextStyle(color: AppColors.secondaryText),
            ),
            SizedBox(height: 12),
            Text(
              '© 2024 Sports Assessment Platform',
              style: TextStyle(color: AppColors.mutedText, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Sign Out',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: AppColors.secondaryText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          NeonButton(
            onPressed: () async {
              Navigator.pop(context);
              final authService = ref.read(authServiceProvider);
              await authService.signOut();
              if (mounted) {
                context.go('/auth');
              }
            },
            variant: NeonButtonVariant.tertiary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}