import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  String _selectedCategory = 'Overall';
  String _selectedTimeframe = 'Weekly';
  
  final List<String> _categories = ['Overall', 'Speed', 'Strength', 'Endurance', 'Flexibility'];
  final List<String> _timeframes = ['Weekly', 'Monthly', 'All-time'];

  final List<Map<String, dynamic>> _leaderboardData = [
    {
      'rank': 1,
      'name': 'Arjun Sharma',
      'location': 'Mumbai, Maharashtra',
      'score': 2847,
      'improvement': '+12%',
      'badge': 'Elite',
      'badgeColor': AppColors.neonGreen,
      'isCurrentUser': false,
    },
    {
      'rank': 2,
      'name': 'Priya Patel',
      'location': 'Delhi, NCR',
      'score': 2786,
      'improvement': '+8%',
      'badge': 'Elite',
      'badgeColor': AppColors.neonGreen,
      'isCurrentUser': false,
    },
    {
      'rank': 3,
      'name': 'Vikram Singh',
      'location': 'Bengaluru, Karnataka',
      'score': 2723,
      'improvement': '+15%',
      'badge': 'Elite',
      'badgeColor': AppColors.neonGreen,
      'isCurrentUser': false,
    },
    {
      'rank': 4,
      'name': 'Ananya Reddy',
      'location': 'Hyderabad, Telangana',
      'score': 2658,
      'improvement': '+6%',
      'badge': 'Advanced',
      'badgeColor': AppColors.electricBlue,
      'isCurrentUser': false,
    },
    {
      'rank': 5,
      'name': 'Rahul Kumar',
      'location': 'Chennai, Tamil Nadu',
      'score': 2594,
      'improvement': '+10%',
      'badge': 'Advanced',
      'badgeColor': AppColors.electricBlue,
      'isCurrentUser': false,
    },
    {
      'rank': 42,
      'name': 'You',
      'location': 'Pune, Maharashtra',
      'score': 1987,
      'improvement': '+18%',
      'badge': 'Rising Star',
      'badgeColor': AppColors.warmOrange,
      'isCurrentUser': true,
    },
  ];

  Color _getRankColor(int rank) {
    if (rank == 1) return AppColors.neonGreen;
    if (rank == 2) return AppColors.electricBlue;
    if (rank == 3) return AppColors.warmOrange;
    if (rank <= 10) return AppColors.royalPurple;
    return AppColors.secondaryText;
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _leaderboardData.firstWhere(
      (entry) => entry['isCurrentUser'] == true,
      orElse: () => _leaderboardData.last,
    );

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
                flexibleSpace: FlexibleSpaceBar(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Leaderboard',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Compete with athletes across India',
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
                    // Filter Categories
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _categories.map((category) {
                                final isSelected = _selectedCategory == category;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap: () => setState(() => _selectedCategory = category),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: isSelected 
                                            ? AppColors.neonGreen 
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected 
                                              ? AppColors.neonGreen 
                                              : AppColors.glassBorder,
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        category,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: isSelected 
                                              ? Colors.black 
                                              : Colors.white,
                                          fontWeight: isSelected 
                                              ? FontWeight.w600 
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Timeframe',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: _timeframes.map((timeframe) {
                              final isSelected = _selectedTimeframe == timeframe;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _selectedTimeframe = timeframe),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      right: timeframe != _timeframes.last ? 8 : 0,
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: isSelected 
                                          ? AppColors.electricBlue 
                                          : AppColors.glassSurface,
                                      border: Border.all(
                                        color: isSelected 
                                            ? AppColors.electricBlue 
                                            : AppColors.glassBorder,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        timeframe,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: isSelected 
                                              ? Colors.white 
                                              : AppColors.secondaryText,
                                          fontWeight: isSelected 
                                              ? FontWeight.w600 
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Current User Position
                    GlassCard(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.warmOrange.withOpacity(0.15),
                              AppColors.warmOrange.withOpacity(0.05),
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [AppColors.royalPurple, AppColors.electricBlue],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.royalPurple.withOpacity(0.3),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Your Position',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        currentUser['location'],
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: AppColors.secondaryText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '#${currentUser['rank']}',
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.warmOrange,
                                      ),
                                    ),
                                    Text(
                                      '${currentUser['score']} pts',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: currentUser['badgeColor'].withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: currentUser['badgeColor'].withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    currentUser['badge'],
                                    style: TextStyle(
                                      color: currentUser['badgeColor'],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.neonGreen.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.trending_up,
                                        size: 14,
                                        color: AppColors.neonGreen,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        currentUser['improvement'],
                                        style: const TextStyle(
                                          color: AppColors.neonGreen,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Top 3 Podium
                    GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text(
                              'Top Performers',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // 2nd Place
                                _buildPodiumPosition(_leaderboardData[1], 2),
                                // 1st Place
                                _buildPodiumPosition(_leaderboardData[0], 1),
                                // 3rd Place
                                _buildPodiumPosition(_leaderboardData[2], 3),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Full Leaderboard
                    Text(
                      'Full Rankings',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    ..._leaderboardData.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildLeaderboardCard(entry),
                    )),
                    
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

  Widget _buildPodiumPosition(Map<String, dynamic> entry, int position) {
    final colors = [AppColors.neonGreen, AppColors.electricBlue, AppColors.warmOrange];
    final heights = [120.0, 100.0, 80.0];
    final color = colors[position - 1];
    final height = heights[position - 1];
    
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withOpacity(0.7)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Stack(
            children: [
              const Center(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '$position',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          entry['name'].split(' ').first,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '${entry['score']}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 60,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color.withOpacity(0.8), color.withOpacity(0.4)],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardCard(Map<String, dynamic> entry) {
    return GlassCard(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: entry['isCurrentUser'] ? BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.warmOrange.withOpacity(0.1),
              AppColors.warmOrange.withOpacity(0.05),
            ],
          ),
        ) : null,
        child: Row(
          children: [
            // Rank
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getRankColor(entry['rank']).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '#${entry['rank']}',
                  style: TextStyle(
                    color: _getRankColor(entry['rank']),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.royalPurple, AppColors.electricBlue],
                ),
                shape: BoxShape.circle,
                border: entry['isCurrentUser'] 
                    ? Border.all(color: AppColors.warmOrange, width: 2)
                    : null,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry['name'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry['location'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: entry['badgeColor'].withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          entry['badge'],
                          style: TextStyle(
                            color: entry['badgeColor'],
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.neonGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.trending_up,
                              size: 10,
                              color: AppColors.neonGreen,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              entry['improvement'],
                              style: const TextStyle(
                                color: AppColors.neonGreen,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Score
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${entry['score']}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _getRankColor(entry['rank']),
                  ),
                ),
                Text(
                  'points',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}