import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/pull_to_refresh.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _chartsController;
  late Animation<double> _headerFade;
  late Animation<double> _chartsScale;
  
  String _selectedTimeframe = '3M';
  final List<String> _timeframes = ['1W', '1M', '3M', '6M', '1Y'];
  
  List<PerformanceData> _performanceData = [];
  Map<String, double> _categoryScores = {};
  List<WorkoutFrequency> _workoutFrequency = [];
  List<ProgressMilestone> _milestones = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadAnalyticsData();
    _startAnimations();
  }

  void _initializeAnimations() {
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _chartsController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _headerFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    ));
    
    _chartsScale = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _chartsController,
      curve: Curves.elasticOut,
    ));
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _headerController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _chartsController.forward();
  }

  void _loadAnalyticsData() {
    _performanceData = _generatePerformanceData();
    _categoryScores = _generateCategoryScores();
    _workoutFrequency = _generateWorkoutFrequency();
    _milestones = _generateMilestones();
  }

  List<PerformanceData> _generatePerformanceData() {
    return [
      PerformanceData(DateTime.now().subtract(const Duration(days: 90)), 65),
      PerformanceData(DateTime.now().subtract(const Duration(days: 75)), 68),
      PerformanceData(DateTime.now().subtract(const Duration(days: 60)), 72),
      PerformanceData(DateTime.now().subtract(const Duration(days: 45)), 70),
      PerformanceData(DateTime.now().subtract(const Duration(days: 30)), 75),
      PerformanceData(DateTime.now().subtract(const Duration(days: 15)), 78),
      PerformanceData(DateTime.now(), 82),
    ];
  }

  Map<String, double> _generateCategoryScores() {
    return {
      'Speed & Agility': 89,
      'Strength & Power': 76,
      'Endurance': 82,
      'Flexibility': 94,
      'Balance': 71,
    };
  }

  List<WorkoutFrequency> _generateWorkoutFrequency() {
    return [
      WorkoutFrequency('Mon', 2),
      WorkoutFrequency('Tue', 1),
      WorkoutFrequency('Wed', 3),
      WorkoutFrequency('Thu', 2),
      WorkoutFrequency('Fri', 4),
      WorkoutFrequency('Sat', 3),
      WorkoutFrequency('Sun', 1),
    ];
  }

  List<ProgressMilestone> _generateMilestones() {
    return [
      ProgressMilestone(
        date: DateTime.now().subtract(const Duration(days: 7)),
        title: 'Personal Best in Sprint',
        description: 'Achieved 12.8s in 100m sprint',
        improvement: '+0.3s',
        category: 'Speed',
      ),
      ProgressMilestone(
        date: DateTime.now().subtract(const Duration(days: 14)),
        title: 'Elite Rank Achieved',
        description: 'Reached top 5% in strength category',
        improvement: 'Top 5%',
        category: 'Strength',
      ),
      ProgressMilestone(
        date: DateTime.now().subtract(const Duration(days: 21)),
        title: 'Consistency Streak',
        description: '30-day workout streak completed',
        improvement: '30 days',
        category: 'General',
      ),
    ];
  }

  @override
  void dispose() {
    _headerController.dispose();
    _chartsController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(seconds: 1));
    _loadAnalyticsData();
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
                  
                  // Timeframe Selection
                  _buildTimeframeSelector(),
                  
                  const SizedBox(height: 32),
                  
                  // Performance Overview
                  _buildPerformanceOverview(),
                  
                  const SizedBox(height: 24),
                  
                  // Performance Trend Chart
                  _buildPerformanceTrendChart(),
                  
                  const SizedBox(height: 24),
                  
                  // Category Breakdown
                  _buildCategoryBreakdown(),
                  
                  const SizedBox(height: 24),
                  
                  // Workout Frequency
                  _buildWorkoutFrequency(),
                  
                  const SizedBox(height: 24),
                  
                  // Progress Milestones
                  _buildProgressMilestones(),
                  
                  const SizedBox(height: 24),
                  
                  // AI Insights
                  _buildAIInsights(),
                  
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
                      'Performance Analytics',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Deep insights into your progress',
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
                  Icons.analytics,
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

  Widget _buildTimeframeSelector() {
    return Row(
      children: _timeframes.map((timeframe) {
        final isSelected = _selectedTimeframe == timeframe;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedTimeframe = timeframe;
              });
              HapticFeedback.lightImpact();
              _loadAnalyticsData();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(
                right: timeframe != _timeframes.last ? 8 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.neonGradient : null,
                color: isSelected ? null : AppColors.glassSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? Colors.transparent : AppColors.glassBorder,
                  width: 1,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppColors.neonGlowGreen.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ] : null,
              ),
              child: Center(
                child: Text(
                  timeframe,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.grey300,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms);
  }

  Widget _buildPerformanceOverview() {
    return Row(
      children: [
        Expanded(
          child: _buildOverviewCard(
            title: 'Overall Score',
            value: '82%',
            change: '+7%',
            icon: Icons.trending_up,
            color: AppColors.neonGreen,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildOverviewCard(
            title: 'Tests This Month',
            value: '18',
            change: '+3',
            icon: Icons.assignment_turned_in,
            color: AppColors.electricBlue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildOverviewCard(
            title: 'Best Category',
            value: 'Flexibility',
            change: '94%',
            icon: Icons.emoji_events,
            color: AppColors.warmOrange,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms);
  }

  Widget _buildOverviewCard({
    required String title,
    required String value,
    required String change,
    required IconData icon,
    required Color color,
  }) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.neonGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    change,
                    style: const TextStyle(
                      color: AppColors.neonGreen,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.grey400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceTrendChart() {
    return AnimatedBuilder(
      animation: _chartsScale,
      builder: (context, child) {
        return Transform.scale(
          scale: _chartsScale.value,
          child: GlassCard(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Performance Trend',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 10,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: AppColors.glassBorder,
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${value.toInt()}%',
                                  style: const TextStyle(
                                    color: AppColors.grey400,
                                    fontSize: 12,
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, meta) {
                                final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                                final index = value.toInt();
                                if (index >= 0 && index < months.length) {
                                  return Text(
                                    months[index],
                                    style: const TextStyle(
                                      color: AppColors.grey400,
                                      fontSize: 12,
                                    ),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: _performanceData.asMap().entries.map((entry) {
                              return FlSpot(entry.key.toDouble(), entry.value.score);
                            }).toList(),
                            isCurved: true,
                            gradient: AppColors.purpleBlueGradient,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 4,
                                  color: AppColors.neonGreen,
                                  strokeWidth: 2,
                                  strokeColor: Colors.white,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.royalPurple.withOpacity(0.3),
                                  AppColors.royalPurple.withOpacity(0.1),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ],
                        minX: 0,
                        maxX: _performanceData.length.toDouble() - 1,
                        minY: 0,
                        maxY: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryBreakdown() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Breakdown',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 60,
                  sections: _categoryScores.entries.map((entry) {
                    final colors = [
                      AppColors.neonGreen,
                      AppColors.electricBlue,
                      AppColors.warmOrange,
                      AppColors.royalPurple,
                      AppColors.brightRed,
                    ];
                    final colorIndex = _categoryScores.keys.toList().indexOf(entry.key);
                    final color = colors[colorIndex % colors.length];
                    
                    return PieChartSectionData(
                      color: color,
                      value: entry.value,
                      title: '${entry.value.toInt()}%',
                      radius: 50,
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: _categoryScores.entries.map((entry) {
                final colors = [
                  AppColors.neonGreen,
                  AppColors.electricBlue,
                  AppColors.warmOrange,
                  AppColors.royalPurple,
                  AppColors.brightRed,
                ];
                final colorIndex = _categoryScores.keys.toList().indexOf(entry.key);
                final color = colors[colorIndex % colors.length];
                
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      entry.key,
                      style: const TextStyle(
                        color: AppColors.grey300,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    ).animate(delay: 600.ms).fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildWorkoutFrequency() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 150,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 5,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < _workoutFrequency.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                _workoutFrequency[index].day,
                                style: const TextStyle(
                                  color: AppColors.grey400,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: AppColors.grey400,
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: AppColors.glassBorder,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  barGroups: _workoutFrequency.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.count.toDouble(),
                          gradient: AppColors.purpleBlueGradient,
                          width: 20,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: 800.ms).fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildProgressMilestones() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Milestones',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _milestones.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final milestone = _milestones[index];
            return _buildMilestoneCard(milestone, index);
          },
        ),
      ],
    ).animate(delay: 1000.ms).fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildMilestoneCard(ProgressMilestone milestone, int index) {
    final colors = [
      AppColors.neonGreen,
      AppColors.electricBlue,
      AppColors.warmOrange,
    ];
    final color = colors[index % colors.length];
    
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
                Icons.emoji_events,
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
                    milestone.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    milestone.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.grey400,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          milestone.improvement,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(milestone.date),
                        style: const TextStyle(
                          color: AppColors.grey500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: (index * 100 + 1100).ms)
        .fadeIn(duration: 600.ms)
        .slideX(begin: 0.1, end: 0, curve: Curves.easeOut);
  }

  Widget _buildAIInsights() {
    return GlassCard(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.royalPurple.withOpacity(0.1),
              AppColors.electricBlue.withOpacity(0.05),
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
                    gradient: AppColors.purpleBlueGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonGlowPurple.withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'AI Performance Insights',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInsightItem(
              icon: Icons.trending_up,
              title: 'Improving Trend',
              description: 'Your overall performance has improved by 17% over the last 3 months. Keep up the excellent work!',
              color: AppColors.neonGreen,
            ),
            const SizedBox(height: 16),
            _buildInsightItem(
              icon: Icons.center_focus_strong,
              title: 'Focus Area',
              description: 'Consider spending more time on strength training to balance your fitness profile.',
              color: AppColors.warmOrange,
            ),
            const SizedBox(height: 16),
            _buildInsightItem(
              icon: Icons.schedule,
              title: 'Optimal Training',
              description: 'Your performance peaks on Fridays. Schedule important tests accordingly.',
              color: AppColors.electricBlue,
            ),
          ],
        ),
      ),
    ).animate(delay: 1400.ms).fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildInsightItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.grey300,
                  height: 1.4,
                ),
              ),
            ],
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

class PerformanceData {
  final DateTime date;
  final double score;

  PerformanceData(this.date, this.score);
}

class WorkoutFrequency {
  final String day;
  final int count;

  WorkoutFrequency(this.day, this.count);
}

class ProgressMilestone {
  final DateTime date;
  final String title;
  final String description;
  final String improvement;
  final String category;

  ProgressMilestone({
    required this.date,
    required this.title,
    required this.description,
    required this.improvement,
    required this.category,
  });
}