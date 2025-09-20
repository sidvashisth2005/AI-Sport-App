import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/personalized_solution_model.dart';

class PersonalizedSolutionScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> testResult;

  const PersonalizedSolutionScreen({
    super.key,
    required this.testResult,
  });

  @override
  ConsumerState<PersonalizedSolutionScreen> createState() => _PersonalizedSolutionScreenState();
}

class _PersonalizedSolutionScreenState extends ConsumerState<PersonalizedSolutionScreen>
    with TickerProviderStateMixin {
  Timer? _timer;
  int _remainingSeconds = 300; // 5 minutes
  bool _isTimerRunning = true;
  bool _showSolution = false;
  
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  PersonalizedSolution? _solution;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _initializeAnimations();
    _generateSolution();
  }

  void _initializeAnimations() {
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _isTimerRunning = false;
          _showSolution = true;
          timer.cancel();
        }
      });
    });
  }

  void _generateSolution() {
    // Simulate AI processing based on test results
    final testType = widget.testResult['testType'] ?? 'general';
    final score = widget.testResult['score'] ?? 70;
    
    _solution = PersonalizedSolution(
      id: 'sol_${DateTime.now().millisecondsSinceEpoch}',
      testType: testType,
      userScore: score.toDouble(),
      recommendations: _generateRecommendations(testType, score),
      exercises: _generateExercises(testType, score),
      nutritionPlan: _generateNutritionPlan(testType, score),
      recoveryPlan: _generateRecoveryPlan(testType, score),
      targetMetrics: _generateTargetMetrics(testType, score),
      estimatedImprovementTime: _calculateImprovementTime(score),
      difficultyLevel: _calculateDifficultyLevel(score),
      createdAt: DateTime.now(),
    );
  }

  List<String> _generateRecommendations(String testType, int score) {
    switch (testType.toLowerCase()) {
      case 'pushup':
        return score < 50 
          ? [
              'Focus on building upper body strength with assisted push-ups',
              'Incorporate planks and wall push-ups to build foundation',
              'Gradually increase repetitions by 2-3 per week',
              'Include rest days for muscle recovery',
            ]
          : [
              'Progress to advanced push-up variations (diamond, one-arm)',
              'Increase volume with multiple sets throughout the day',
              'Add weighted push-ups for strength building',
              'Focus on explosive movements for power development',
            ];
      case 'sprint':
        return score < 50
          ? [
              'Start with interval training to build speed endurance',
              'Focus on proper running form and technique',
              'Include dynamic warm-ups before every session',
              'Gradually increase sprint distance and frequency',
            ]
          : [
              'Incorporate advanced sprint drills and plyometrics',
              'Add resistance training for explosive power',
              'Focus on race strategy and mental preparation',
              'Include recovery protocols for optimal performance',
            ];
      default:
        return [
          'Maintain consistent training schedule',
          'Focus on progressive overload principles',
          'Include variety in your workout routine',
          'Monitor progress and adjust intensity accordingly',
        ];
    }
  }

  List<Exercise3D> _generateExercises(String testType, int score) {
    return [
      Exercise3D(
        id: 'ex_foundation_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Foundation Builder',
        description: 'Core strengthening exercise tailored to your current level',
        modelUrl: 'https://example.com/models/foundation.glb',
        animationUrl: 'https://example.com/animations/foundation.anim',
        instructionSteps: [
          'Start in a comfortable position',
          'Focus on proper form',
          'Maintain steady breathing',
          'Complete full range of motion',
        ],
        duration: 30,
        sets: 3,
        reps: score < 50 ? 8 : 15,
        difficulty: score < 50 ? 'beginner' : 'intermediate',
        targetMuscles: ['core', 'abs'],
        equipment: ['mat'],
      ),
      Exercise3D(
        id: 'ex_progressive_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Progressive Challenge',
        description: 'Intermediate exercise to push your limits',
        modelUrl: 'https://example.com/models/progressive.glb',
        animationUrl: 'https://example.com/animations/progressive.anim',
        instructionSteps: [
          'Warm up properly before starting',
          'Increase intensity gradually',
          'Monitor your heart rate',
          'Cool down after completion',
        ],
        duration: 45,
        sets: 4,
        reps: score < 50 ? 10 : 20,
        difficulty: 'intermediate',
        targetMuscles: ['chest', 'shoulders', 'triceps'],
        equipment: ['dumbbell'],
      ),
      Exercise3D(
        id: 'ex_peak_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Peak Performance',
        description: 'Advanced exercise for maximum results',
        modelUrl: 'https://example.com/models/peak.glb',
        animationUrl: 'https://example.com/animations/peak.anim',
        instructionSteps: [
          'Ensure proper warm-up',
          'Use maximum effort',
          'Focus on explosive movements',
          'Allow adequate rest between sets',
        ],
        duration: 60,
        sets: 5,
        reps: score < 50 ? 6 : 12,
        difficulty: 'advanced',
        targetMuscles: ['full body'],
        equipment: ['barbell', 'plates'],
      ),
    ];
  }

  NutritionPlan _generateNutritionPlan(String testType, int score) {
    return NutritionPlan(
      dailyCalories: score < 50 ? 2200 : 2800,
      proteinGrams: score < 50 ? 120 : 160,
      carbGrams: score < 50 ? 220 : 280,
      fatGrams: score < 50 ? 80 : 100,
      waterLiters: 3.5,
      meals: [
        'High-protein breakfast with complex carbohydrates',
        'Pre-workout snack with quick energy sources',
        'Post-workout recovery meal within 30 minutes',
        'Balanced dinner with lean protein and vegetables',
      ],
    );
  }

  RecoveryPlan _generateRecoveryPlan(String testType, int score) {
    return RecoveryPlan(
      sleepHours: 8,
      restDays: score < 50 ? 3 : 2,
      stretchingMinutes: 20,
      massageFrequency: 'Weekly',
      activitiesRecommended: [
        'Light yoga or stretching',
        'Low-intensity swimming',
        'Walking or light cycling',
        'Meditation and breathing exercises',
      ],
    );
  }

  Map<String, double> _generateTargetMetrics(String testType, int score) {
    return {
      '1_week': score + 5,
      '2_weeks': score + 12,
      '1_month': score + 25,
      '3_months': score + 50,
    };
  }

  int _calculateImprovementTime(int score) {
    return score < 30 ? 8 : score < 60 ? 6 : 4; // weeks
  }

  String _calculateDifficultyLevel(int score) {
    return score < 30 ? 'Beginner' : score < 70 ? 'Intermediate' : 'Advanced';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepCharcoal,
      appBar: AppBar(
        backgroundColor: AppColors.deepCharcoal,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Personalized Solution',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _showSolution ? _buildSolutionView() : _buildTimerView(),
    );
  }

  Widget _buildTimerView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.neonGreen.withOpacity(0.3),
                          AppColors.royalPurple.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                      border: Border.all(
                        color: AppColors.neonGreen,
                        width: 2,
                      ),
                    ),
                    child: AnimatedBuilder(
                      animation: _rotationAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotationAnimation.value,
                          child: Icon(
                            Icons.psychology,
                            size: 80,
                            color: AppColors.neonGreen,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Text(
              'Generating Your Personalized Solution',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Our AI is analyzing your test results and creating a customized improvement plan just for you.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            GlassCard(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer,
                          color: AppColors.electricBlue,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _formattedTime,
                          style: TextStyle(
                            color: AppColors.electricBlue,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: (300 - _remainingSeconds) / 300,
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.neonGreen),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${((300 - _remainingSeconds) / 300 * 100).toInt()}% Complete',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            if (!_isTimerRunning)
              NeonButton(
                text: 'View Your Solution',
                onPressed: () {
                  setState(() {
                    _showSolution = true;
                  });
                },
                type: NeonButtonType.accent,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolutionView() {
    if (_solution == null) return const SizedBox();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSolutionHeader(),
                const SizedBox(height: 20),
                _build3DModelViewer(),
                const SizedBox(height: 20),
                _buildRecommendations(),
                const SizedBox(height: 20),
                _buildExercisePlan(),
                const SizedBox(height: 20),
                _buildNutritionPlan(),
                const SizedBox(height: 20),
                _buildRecoveryPlan(),
                const SizedBox(height: 20),
                _buildProgressTargets(),
                const SizedBox(height: 100), // Bottom padding
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSolutionHeader() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology,
                  color: AppColors.neonGreen,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Personalized Solution',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Based on your ${_solution!.testType} test results',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildMetricChip('Level', _solution!.difficultyLevel),
                const SizedBox(width: 12),
                _buildMetricChip('Timeline', '${_solution!.estimatedImprovementTime} weeks'),
                const SizedBox(width: 12),
                _buildMetricChip('Score', '${_solution!.userScore.toInt()}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.royalPurple.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.royalPurple),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _build3DModelViewer() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.view_in_ar,
                  color: AppColors.electricBlue,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  '3D Movement Analysis',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.electricBlue.withOpacity(0.3)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: AnimatedBuilder(
                      animation: _rotationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotationAnimation.value * 0.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.accessibility_new,
                                color: AppColors.neonGreen,
                                size: 80,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '3D Model Viewer',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.electricBlue.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'AR Ready',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Interactive 3D model showing optimal form and movement patterns based on your performance data.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
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
                const SizedBox(width: 8),
                const Text(
                  'Key Recommendations',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...(_solution!.recommendations.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.neonGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildExercisePlan() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.fitness_center,
                  color: AppColors.royalPurple,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Exercise Plan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...(_solution!.exercises.map((exercise) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.royalPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.royalPurple.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      exercise.description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildExerciseMetric('Sets', '${exercise.sets}'),
                        const SizedBox(width: 16),
                        _buildExerciseMetric('Reps', '${exercise.reps}'),
                        const SizedBox(width: 16),
                        _buildExerciseMetric('Duration', '${exercise.duration}s'),
                      ],
                    ),
                  ],
                ),
              );
            }).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseMetric(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionPlan() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.restaurant,
                  color: AppColors.neonGreen,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Nutrition Plan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildNutritionMetric('Calories', '${_solution!.nutritionPlan.dailyCalories}'),
                const SizedBox(width: 16),
                _buildNutritionMetric('Protein', '${_solution!.nutritionPlan.proteinGrams}g'),
                const SizedBox(width: 16),
                _buildNutritionMetric('Water', '${_solution!.nutritionPlan.waterLiters}L'),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Meal Recommendations:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...(_solution!.nutritionPlan.meals.map((meal) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: AppColors.neonGreen,
                      size: 8,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        meal,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionMetric(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.neonGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.neonGreen.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecoveryPlan() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.spa,
                  color: AppColors.electricBlue,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Recovery Plan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildRecoveryMetric('Sleep', '${_solution!.recoveryPlan.sleepHours}h'),
                const SizedBox(width: 16),
                _buildRecoveryMetric('Rest Days', '${_solution!.recoveryPlan.restDays}'),
                const SizedBox(width: 16),
                _buildRecoveryMetric('Stretching', '${_solution!.recoveryPlan.stretchingMinutes}m'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecoveryMetric(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.electricBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.electricBlue.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressTargets() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: AppColors.warmOrange,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Progress Targets',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...(_solution!.targetMetrics.entries.map((entry) {
              final timeframe = entry.key.replaceAll('_', ' ');
              final target = entry.value.toInt();
              final improvement = target - _solution!.userScore.toInt();
              
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.warmOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.warmOrange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        timeframe.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Target: $target',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.neonGreen,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '+$improvement',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList()),
          ],
        ),
      ),
    );
  }
}