import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class TestDetailScreen extends StatelessWidget {
  final String testId;

  const TestDetailScreen({
    super.key,
    required this.testId,
  });

  Map<String, dynamic> _getTestData(String testId) {
    final Map<String, Map<String, dynamic>> testDatabase = {
      'sprint_test': {
        'name': '100m Sprint Test',
        'description': 'Measure your top running speed over 100 meters with AI-powered motion analysis',
        'category': 'Speed',
        'duration': '5 min',
        'difficulty': 'Intermediate',
        'icon': Icons.directions_run,
        'color': AppColors.neonGreen,
        'points': 15,
        'instructions': [
          'Find a straight, flat 100-meter track or path',
          'Ensure your phone camera can capture your entire sprint',
          'Start from a stationary position behind the start line',
          'Sprint at maximum speed for the entire 100 meters',
          'Slow down gradually after crossing the finish line'
        ],
        'equipment': ['Phone with camera', '100m measured distance', 'Running shoes'],
        'tips': [
          'Warm up with light jogging for 5-10 minutes',
          'Practice your starting stance',
          'Focus on pumping your arms and maintaining form',
          'Don\'t look back during the sprint'
        ],
        'metrics': ['Top Speed', 'Acceleration', 'Sprint Time', 'Form Analysis'],
      },
      'push_up_test': {
        'name': 'Push-up Endurance',
        'description': 'Test your upper body strength and endurance with proper form tracking',
        'category': 'Strength',
        'duration': '3 min',
        'difficulty': 'Beginner',
        'icon': Icons.fitness_center,
        'color': AppColors.electricBlue,
        'points': 10,
        'instructions': [
          'Position yourself in a standard push-up position',
          'Keep your body in a straight line from head to heels',
          'Lower your body until your chest nearly touches the ground',
          'Push back up to the starting position',
          'Continue for the full test duration'
        ],
        'equipment': ['Phone with camera', 'Exercise mat (optional)'],
        'tips': [
          'Keep your core engaged throughout',
          'Maintain proper breathing rhythm',
          'Focus on form over speed',
          'If you can\'t continue, take a brief rest and resume'
        ],
        'metrics': ['Total Reps', 'Form Score', 'Endurance Rating', 'Power Output'],
      },
      'flexibility_test': {
        'name': 'Sit-and-Reach Test',
        'description': 'Assess your lower back and hamstring flexibility',
        'category': 'Flexibility',
        'duration': '2 min',
        'difficulty': 'Beginner',
        'icon': Icons.accessibility_new,
        'color': AppColors.royalPurple,
        'points': 8,
        'instructions': [
          'Sit on the floor with legs straight and feet against a wall',
          'Place your hands together and slowly reach forward',
          'Hold the furthest comfortable position for 2 seconds',
          'Return to starting position and repeat',
          'Perform 3 measured attempts'
        ],
        'equipment': ['Phone with camera', 'Wall or measuring device'],
        'tips': [
          'Warm up with gentle stretches first',
          'Don\'t bounce or force the movement',
          'Breathe steadily throughout the test',
          'Stop if you feel pain'
        ],
        'metrics': ['Maximum Reach', 'Flexibility Score', 'Range of Motion', 'Improvement Potential'],
      },
    };

    return testDatabase[testId] ?? {
      'name': 'Unknown Test',
      'description': 'Test details not available',
      'category': 'General',
      'duration': 'N/A',
      'difficulty': 'Unknown',
      'icon': Icons.help,
      'color': AppColors.mutedText,
      'points': 0,
      'instructions': ['Test instructions not available'],
      'equipment': ['Equipment list not available'],
      'tips': ['Tips not available'],
      'metrics': ['Metrics not available'],
    };
  }

  @override
  Widget build(BuildContext context) {
    final testData = _getTestData(testId);
    
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
                      // Share test functionality
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        testData['name'],
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        testData['category'],
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
                    // Test Overview
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    colors: [
                                      testData['color'].withOpacity(0.3),
                                      testData['color'].withOpacity(0.1),
                                    ],
                                  ),
                                ),
                                child: Icon(
                                  testData['icon'],
                                  color: testData['color'],
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      testData['description'],
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        _buildInfoChip(
                                          testData['duration'], 
                                          Icons.timer, 
                                          AppColors.electricBlue
                                        ),
                                        const SizedBox(width: 8),
                                        _buildInfoChip(
                                          testData['difficulty'], 
                                          Icons.signal_cellular_alt, 
                                          AppColors.warmOrange
                                        ),
                                        const SizedBox(width: 8),
                                        _buildInfoChip(
                                          '${testData['points']} pts', 
                                          Icons.stars, 
                                          AppColors.neonGreen
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Instructions
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.list_alt,
                                color: AppColors.neonGreen,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Instructions',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...testData['instructions'].asMap().entries.map<Widget>((entry) {
                            final index = entry.key;
                            final instruction = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: AppColors.neonGreen,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      instruction,
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
                    
                    // Equipment Needed
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.inventory_2,
                                color: AppColors.electricBlue,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Equipment Needed',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: testData['equipment'].map<Widget>((equipment) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: AppColors.electricBlue.withOpacity(0.2),
                                  border: Border.all(
                                    color: AppColors.electricBlue.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  equipment,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.electricBlue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Tips
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb,
                                color: AppColors.warmOrange,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Pro Tips',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...testData['tips'].map<Widget>((tip) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: AppColors.warmOrange,
                                    size: 8,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      tip,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.secondaryText,
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
                    
                    // Metrics Measured
                    GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.analytics,
                                color: AppColors.royalPurple,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Metrics Measured',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: testData['metrics'].map<Widget>((metric) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: AppColors.royalPurple.withOpacity(0.2),
                                  border: Border.all(
                                    color: AppColors.royalPurple.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  metric,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.royalPurple,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Start Test Button
                    NeonButton(
                      onPressed: () => context.go('/recording/$testId'),
                      variant: NeonButtonVariant.primary,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.play_arrow, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Start Test',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildInfoChip(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.2),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}