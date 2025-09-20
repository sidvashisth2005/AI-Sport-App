import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/pull_to_refresh.dart';

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _achievementsController;
  late Animation<double> _headerFade;
  late Animation<Offset> _achievementsSlide;
  
  String _selectedCategory = 'all';
  final List<String> _categories = ['all', 'speed', 'strength', 'endurance', 'consistency', 'milestones'];
  
  List<Achievement> _achievements = [];
  List<Achievement> _recentAchievements = [];
  Map<String, int> _categoryStats = {};

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadAchievements();
    _startAnimations();
  }

  void _initializeAnimations() {
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _achievementsController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _headerFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    ));
    
    _achievementsSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _achievementsController,
      curve: Curves.easeOut,
    ));
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _headerController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _achievementsController.forward();
  }

  void _loadAchievements() {
    _achievements = _generateAchievements();
    _recentAchievements = _achievements.where((achievement) => achievement.isRecent).toList();
    _categoryStats = _generateCategoryStats();
  }

  List<Achievement> _generateAchievements() {
    return [
      Achievement(
        id: '1',
        title: 'Speed Demon',
        description: 'Complete 100m sprint under 13 seconds',
        category: 'speed',
        icon: Icons.flash_on,
        color: AppColors.neonGreen,
        isUnlocked: true,
        isRecent: true,
        unlockedDate: DateTime.now().subtract(const Duration(days: 2)),
        progress: 1.0,
        requirement: 'Sprint time: < 13.0s',
        reward: '500 XP + Speed Badge',
        rarity: AchievementRarity.epic,
      ),
      Achievement(
        id: '2',
        title: 'Iron Will',
        description: 'Maintain workout streak for 30 days',
        category: 'consistency',
        icon: Icons.fitness_center,
        color: AppColors.electricBlue,
        isUnlocked: true,
        isRecent: false,
        unlockedDate: DateTime.now().subtract(const Duration(days: 15)),
        progress: 1.0,
        requirement: 'Workout streak: 30 days',
        reward: '750 XP + Consistency Badge',
        rarity: AchievementRarity.legendary,
      ),
      Achievement(
        id: '3',
        title: 'Perfect Form',
        description: 'Achieve 95%+ form score in any test',
        category: 'technique',
        icon: Icons.stars,
        color: AppColors.warmOrange,
        isUnlocked: true,
        isRecent: true,
        unlockedDate: DateTime.now().subtract(const Duration(days: 5)),
        progress: 1.0,
        requirement: 'Form score: ≥ 95%',
        reward: '300 XP + Technique Badge',
        rarity: AchievementRarity.rare,
      ),
      Achievement(
        id: '4',
        title: 'Endurance Champion',
        description: 'Complete Cooper test with elite score',
        category: 'endurance',
        icon: Icons.directions_run,
        color: AppColors.royalPurple,
        isUnlocked: false,
        isRecent: false,
        progress: 0.75,
        requirement: 'Cooper test: > 2800m',
        reward: '600 XP + Endurance Badge',
        rarity: AchievementRarity.epic,
      ),
      Achievement(
        id: '5',
        title: 'Power House',
        description: 'Achieve vertical jump over 60cm',
        category: 'strength',
        icon: Icons.trending_up,
        color: AppColors.brightRed,
        isUnlocked: false,
        isRecent: false,
        progress: 0.85,
        requirement: 'Vertical jump: > 60cm',
        reward: '400 XP + Power Badge',
        rarity: AchievementRarity.rare,
      ),
      Achievement(
        id: '6',
        title: 'Rising Star',
        description: 'Reach top 100 in national leaderboard',
        category: 'milestones',
        icon: Icons.star,
        color: AppColors.neonGreen,
        isUnlocked: false,
        isRecent: false,
        progress: 0.42,
        requirement: 'National rank: ≤ 100',
        reward: '1000 XP + Rising Star Title',
        rarity: AchievementRarity.legendary,
      ),
      Achievement(
        id: '7',
        title: 'Flexibility Master',
        description: 'Score perfect in sit-and-reach test',
        category: 'flexibility',
        icon: Icons.accessibility_new,
        color: AppColors.lightLavender,
        isUnlocked: true,
        isRecent: false,
        unlockedDate: DateTime.now().subtract(const Duration(days: 30)),
        progress: 1.0,
        requirement: 'Sit-and-reach: +20cm',
        reward: '350 XP + Flexibility Badge',
        rarity: AchievementRarity.uncommon,
      ),
      Achievement(
        id: '8',
        title: 'Test Master',
        description: 'Complete all test categories',
        category: 'milestones',
        icon: Icons.emoji_events,
        color: AppColors.warmOrange,
        isUnlocked: false,
        isRecent: false,
        progress: 0.6,
        requirement: 'Complete: 5/5 categories',
        reward: '1500 XP + Master Title',
        rarity: AchievementRarity.legendary,
      ),
    ];
  }

  Map<String, int> _generateCategoryStats() {
    return {
      'Total': _achievements.length,
      'Unlocked': _achievements.where((a) => a.isUnlocked).length,
      'In Progress': _achievements.where((a) => !a.isUnlocked && a.progress > 0).length,
      'Locked': _achievements.where((a) => !a.isUnlocked && a.progress == 0).length,
    };
  }

  @override
  void dispose() {
    _headerController.dispose();
    _achievementsController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(seconds: 1));
    _loadAchievements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.backgroundGradient,
          ),
        ),
        child: SafeArea(
          child: PullToRefresh(
            onRefresh: _handleRefresh,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(),
                  
                  const SizedBox(height: 24),
                  
                  // Stats Overview
                  _buildStatsOverview(),
                  
                  const SizedBox(height: 24),
                  
                  // Recent Achievements
                  if (_recentAchievements.isNotEmpty) ...[
                    _buildRecentAchievements(),
                    const SizedBox(height: 24),
                  ],
                  
                  // Category Filter
                  _buildCategoryFilter(),
                  
                  const SizedBox(height: 24),
                  
                  // Achievements Grid
                  _buildAchievementsGrid(),
                  
                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AnimatedBuilder(
      animation: _headerFade,
      builder: (context, child) {
        return Opacity(
          opacity: _headerFade.value,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.pop();
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.glassSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.glassBorder,
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Achievements',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your athletic milestones',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.grey300,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppColors.purpleBlueGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonGlowPurple.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsOverview() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Total',
            value: '${_categoryStats['Total']}',
            color: AppColors.electricBlue,
            icon: Icons.emoji_events,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Unlocked',
            value: '${_categoryStats['Unlocked']}',
            color: AppColors.neonGreen,
            icon: Icons.check_circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'In Progress',
            value: '${_categoryStats['In Progress']}',
            color: AppColors.warmOrange,
            icon: Icons.hourglass_empty,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Locked',
            value: '${_categoryStats['Locked']}',
            color: AppColors.grey500,
            icon: Icons.lock,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms);
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.grey400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recently Unlocked',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _recentAchievements.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final achievement = _recentAchievements[index];
              return _buildRecentAchievementCard(achievement, index);
            },
          ),
        ),
      ],
    ).animate(delay: 400.ms).fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildRecentAchievementCard(Achievement achievement, int index) {
    return GlassCard(
      onTap: () => _showAchievementDetails(achievement),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              achievement.color.withOpacity(0.2),
              achievement.color.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    achievement.color,
                    achievement.color.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: achievement.color.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                achievement.icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              achievement.title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ).animate(delay: (index * 200 + 500).ms)
        .fadeIn(duration: 600.ms)
        .slideX(begin: 0.2, end: 0, curve: Curves.easeOut);
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
              HapticFeedback.lightImpact();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.purpleBlueGradient : null,
                color: isSelected ? null : AppColors.glassSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.transparent : AppColors.glassBorder,
                  width: 1,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppColors.neonGlowPurple.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ] : null,
              ),
              child: Center(
                child: Text(
                  category.toUpperCase(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.grey300,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ).animate(delay: 600.ms).fadeIn(duration: 600.ms);
  }

  Widget _buildAchievementsGrid() {
    final filteredAchievements = _selectedCategory == 'all'
        ? _achievements
        : _achievements.where((achievement) => achievement.category == _selectedCategory).toList();

    return AnimatedBuilder(
      animation: _achievementsSlide,
      builder: (context, child) {
        return SlideTransition(
          position: _achievementsSlide,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: filteredAchievements.length,
            itemBuilder: (context, index) {
              final achievement = filteredAchievements[index];
              return _buildAchievementCard(achievement, index);
            },
          ),
        );
      },
    );
  }

  Widget _buildAchievementCard(Achievement achievement, int index) {
    return GlassCard(
      onTap: () => _showAchievementDetails(achievement),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: achievement.isUnlocked
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    achievement.color.withOpacity(0.15),
                    achievement.color.withOpacity(0.05),
                  ],
                )
              : null,
        ),
        child: Column(
          children: [
            // Achievement Icon
            Stack(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: achievement.isUnlocked
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              achievement.color,
                              achievement.color.withOpacity(0.7),
                            ],
                          )
                        : LinearGradient(
                            colors: [AppColors.grey600, AppColors.grey500],
                          ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: achievement.isUnlocked ? [
                      BoxShadow(
                        color: achievement.color.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ] : null,
                  ),
                  child: Icon(
                    achievement.icon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                if (!achievement.isUnlocked)
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: AppColors.grey600,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                // Rarity indicator
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _getRarityColor(achievement.rarity),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Achievement Title
            Text(
              achievement.title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: achievement.isUnlocked ? Colors.white : AppColors.grey500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 8),
            
            // Achievement Description
            Text(
              achievement.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: achievement.isUnlocked ? AppColors.grey300 : AppColors.grey600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const Spacer(),
            
            // Progress or Date
            if (achievement.isUnlocked) ...[
              Text(
                'Unlocked ${_formatDate(achievement.unlockedDate!)}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: achievement.color,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ] else if (achievement.progress > 0) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: achievement.progress,
                  backgroundColor: AppColors.grey700,
                  valueColor: AlwaysStoppedAnimation<Color>(achievement.color),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${(achievement.progress * 100).toInt()}% Complete',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: achievement.color,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ] else ...[
              Text(
                'Locked',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.grey600,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    ).animate(delay: (index * 100 + 800).ms)
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0), curve: Curves.elasticOut);
  }

  Color _getRarityColor(AchievementRarity rarity) {
    switch (rarity) {
      case AchievementRarity.common:
        return AppColors.grey500;
      case AchievementRarity.uncommon:
        return AppColors.neonGreen;
      case AchievementRarity.rare:
        return AppColors.electricBlue;
      case AchievementRarity.epic:
        return AppColors.royalPurple;
      case AchievementRarity.legendary:
        return AppColors.warmOrange;
    }
  }

  void _showAchievementDetails(Achievement achievement) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Achievement Icon (Large)
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: achievement.isUnlocked
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  achievement.color,
                                  achievement.color.withOpacity(0.7),
                                ],
                              )
                            : LinearGradient(
                                colors: [AppColors.grey600, AppColors.grey500],
                              ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: achievement.isUnlocked ? [
                          BoxShadow(
                            color: achievement.color.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ] : null,
                      ),
                      child: Icon(
                        achievement.icon,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Title and Rarity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            achievement.title,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getRarityColor(achievement.rarity).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            achievement.rarity.name.toUpperCase(),
                            style: TextStyle(
                              color: _getRarityColor(achievement.rarity),
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Description
                    Text(
                      achievement.description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.grey300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Requirements
                    _buildDetailSection('Requirements', achievement.requirement),
                    
                    const SizedBox(height: 20),
                    
                    // Reward
                    _buildDetailSection('Reward', achievement.reward),
                    
                    const SizedBox(height: 20),
                    
                    // Progress or Unlock Date
                    if (achievement.isUnlocked) ...[
                      _buildDetailSection(
                        'Unlocked',
                        _formatDate(achievement.unlockedDate!),
                      ),
                    ] else if (achievement.progress > 0) ...[
                      const SizedBox(height: 20),
                      Text(
                        'Progress: ${(achievement.progress * 100).toInt()}%',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: achievement.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: achievement.progress,
                          backgroundColor: AppColors.grey700,
                          valueColor: AlwaysStoppedAnimation<Color>(achievement.color),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.grey300,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.glassSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.glassBorder,
              width: 1,
            ),
          ),
          child: Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String category;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final bool isRecent;
  final DateTime? unlockedDate;
  final double progress;
  final String requirement;
  final String reward;
  final AchievementRarity rarity;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    required this.isUnlocked,
    required this.isRecent,
    this.unlockedDate,
    required this.progress,
    required this.requirement,
    required this.reward,
    required this.rarity,
  });
}

enum AchievementRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
}