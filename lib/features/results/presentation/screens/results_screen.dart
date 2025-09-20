import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class ResultsScreen extends StatelessWidget {
  final String resultId;

  const ResultsScreen({
    super.key,
    required this.resultId,
  });

  Map<String, dynamic> _getMockResults(String resultId) {
    // Extract test type from resultId
    String testType = 'sprint_test';
    if (resultId.contains('push_up')) testType = 'push_up_test';
    if (resultId.contains('flexibility')) testType = 'flexibility_test';
    if (resultId.contains('jump')) testType = 'jump_test';
    if (resultId.contains('agility')) testType = 'agility_test';
    if (resultId.contains('endurance')) testType = 'endurance_test';

    final Map<String, Map<String, dynamic>> mockResults = {
      'sprint_test': {
        'testName': '100m Sprint Test',
        'overallScore': 87,
        'grade': 'A-',
        'pointsEarned': 15,
        'completedAt': DateTime.now().subtract(const Duration(minutes: 5)),
        'metrics': {
          'Top Speed': {'value': '28.4', 'unit': 'km/h', 'percentile': 85},
          'Acceleration': {'value': '4.2', 'unit': 'm/s²', 'percentile': 90},
          'Sprint Time': {'value': '12.8', 'unit': 'seconds', 'percentile': 78},
          'Form Score': {'value': '92', 'unit': '%', 'percentile': 95},
        },
        'insights': [
          'Excellent acceleration in the first 30 meters',
          'Maintain form consistency for better top speed',
          'Strong finish - kept speed through the line'
        ],
        'recommendations': [
          'Focus on stride length drills',
          'Work on arm drive technique',
          'Add interval training to routine'
        ],
      },
      'push_up_test': {
        'testName': 'Push-up Endurance',
        'overallScore': 73,
        'grade': 'B',
        'pointsEarned': 10,
        'completedAt': DateTime.now().subtract(const Duration(minutes: 3)),
        'metrics': {
          'Total Reps': {'value': '28', 'unit': 'reps', 'percentile': 70},
          'Form Score': {'value': '85', 'unit': '%', 'percentile': 80},
          'Endurance': {'value': '2.5', 'unit': 'min', 'percentile': 65},
          'Power Output': {'value': '425', 'unit': 'watts', 'percentile': 75},
        },
        'insights': [
          'Good initial strength and form',
          'Fatigue affected form in final reps',
          'Consistent pace throughout test'
        ],
        'recommendations': [
          'Build core strength for better stability',
          'Practice slow, controlled movements',
          'Increase training volume gradually'
        ],
      },
    };

    return mockResults[testType] ?? mockResults['sprint_test']!;
  }

  @override
  Widget build(BuildContext context) {
    final results = _getMockResults(resultId);
    
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
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {
                      // Share results functionality
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Test Results',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        results['testName'],
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
                    // Overall Score Card
                    GlassCard(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Score Circle
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.neonGreen.withOpacity(0.3),
                                      AppColors.neonGreen.withOpacity(0.1),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: AppColors.neonGreen,
                                    width: 3,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${results['overallScore']}',
                                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                        color: AppColors.neonGreen,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'SCORE',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.neonGreen,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(width: 32),
                              
                              // Grade and Points
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: AppColors.electricBlue.withOpacity(0.2),
                                      border: Border.all(
                                        color: AppColors.electricBlue,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      'GRADE ${results['grade']}',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: AppColors.electricBlue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 12),
                                  
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.stars,
                                        color: AppColors.warmOrange,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '+${results['pointsEarned']} Points',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          color: AppColors.warmOrange,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 8),
                                  
                                  Text(
                                    'Completed ${_formatTime(results['completedAt'])}',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Detailed Metrics
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.analytics,
                                color: AppColors.electricBlue,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Detailed Metrics',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          ...results['metrics'].entries.map<Widget>((entry) {
                            final metricName = entry.key;
                            final metricData = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildMetricCard(
                                metricName,
                                metricData['value'],
                                metricData['unit'],
                                metricData['percentile'],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // AI Insights
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.psychology,
                                color: AppColors.neonGreen,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'AI Insights',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          ...results['insights'].map<Widget>((insight) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    margin: const EdgeInsets.only(top: 8),
                                    decoration: const BoxDecoration(
                                      color: AppColors.neonGreen,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      insight,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Recommendations
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.recommend,
                                color: AppColors.warmOrange,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Recommendations',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          ...results['recommendations'].map<Widget>((recommendation) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.warmOrange.withOpacity(0.1),
                                  border: Border.all(
                                    color: AppColors.warmOrange.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.lightbulb_outline,
                                      color: AppColors.warmOrange,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        recommendation,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: NeonButton(
                            onPressed: () => context.go('/personalized-solution'),
                            variant: NeonButtonVariant.secondary,
                            child: const Text('Get 3D Solution'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: NeonButton(
                            onPressed: () => context.go('/tests'),
                            variant: NeonButtonVariant.primary,
                            child: const Text('Try Again'),
                          ),
                        ),
                      ],
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

  Widget _buildMetricCard(String name, String value, String unit, int percentile) {
    Color getPercentileColor(int percentile) {
      if (percentile >= 90) return AppColors.neonGreen;
      if (percentile >= 70) return AppColors.electricBlue;
      if (percentile >= 50) return AppColors.warmOrange;
      return AppColors.brightRed;
    }

    final color = getPercentileColor(percentile);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.glassSurface,
        border: Border.all(
          color: AppColors.glassBorder,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        unit,
                        style: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: color.withOpacity(0.2),
                  border: Border.all(
                    color: color,
                    width: 1,
                  ),
                ),
                child: Text(
                  '${percentile}th',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'percentile',
                style: TextStyle(
                  color: AppColors.mutedText,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}