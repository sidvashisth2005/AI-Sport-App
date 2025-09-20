import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class RecordingScreen extends StatefulWidget {
  final String testId;

  const RecordingScreen({
    super.key,
    required this.testId,
  });

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen>
    with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  bool _isCountingDown = false;
  int _countdown = 3;
  int _recordingTime = 0;
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _isCountingDown = true;
      _countdown = 3;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });

      if (_countdown == 0) {
        timer.cancel();
        _startRecording();
      }
    });
  }

  void _startRecording() {
    setState(() {
      _isCountingDown = false;
      _isRecording = true;
      _recordingTime = 0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingTime++;
      });
    });
  }

  void _stopRecording() {
    _timer?.cancel();
    setState(() {
      _isRecording = false;
    });

    // Generate mock result based on test type and simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      final resultId = '${widget.testId}_${DateTime.now().millisecondsSinceEpoch}';
      context.go('/results/$resultId');
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

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
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recording Test',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.testId.replaceAll('_', ' ').toUpperCase(),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_isRecording)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.brightRed.withOpacity(0.2),
                          border: Border.all(
                            color: AppColors.brightRed,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.brightRed,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'REC',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.brightRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isCountingDown) ...[
                        // Countdown
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
                                child: Center(
                                  child: Text(
                                    _countdown.toString(),
                                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                      color: AppColors.neonGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 72,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Get Ready!',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ] else if (_isRecording) ...[
                        // Recording Interface
                        GlassCard(
                          child: Column(
                            children: [
                              // Camera View Placeholder
                              Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.black.withOpacity(0.5),
                                  border: Border.all(
                                    color: AppColors.neonGreen,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.videocam,
                                      color: AppColors.neonGreen,
                                      size: 48,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'AI Analysis Active',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: AppColors.neonGreen,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Tracking your movement...',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Recording Time
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: AppColors.glassSurface,
                                  border: Border.all(
                                    color: AppColors.glassBorder,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedBuilder(
                                      animation: _pulseController,
                                      builder: (context, child) {
                                        return Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: AppColors.brightRed,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.brightRed.withOpacity(
                                                  _pulseAnimation.value - 0.2,
                                                ),
                                                blurRadius: 8,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      _formatTime(_recordingTime),
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFeatures: [const FontFeature.tabularFigures()],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 24),
                              
                              // Performance Indicators
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildMetricIndicator('Form', '95%', AppColors.neonGreen),
                                  _buildMetricIndicator('Speed', '87%', AppColors.electricBlue),
                                  _buildMetricIndicator('Power', '92%', AppColors.warmOrange),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        // Pre-recording State
                        GlassCard(
                          child: Column(
                            children: [
                              Icon(
                                Icons.play_circle_outline,
                                color: AppColors.neonGreen,
                                size: 80,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Ready to Record',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Position yourself in view of the camera and tap start when ready',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppColors.secondaryText,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: AppColors.neonGreen,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Camera permission granted',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.neonGreen,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: AppColors.neonGreen,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'AI analysis ready',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.neonGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Bottom Controls
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    if (_isRecording) ...[
                      Expanded(
                        child: NeonButton(
                          onPressed: _stopRecording,
                          variant: NeonButtonVariant.tertiary,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.stop, color: Colors.black),
                              const SizedBox(width: 8),
                              Text(
                                'Complete Test',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else if (!_isCountingDown) ...[
                      Expanded(
                        child: NeonButton(
                          onPressed: _startCountdown,
                          variant: NeonButtonVariant.primary,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.play_arrow, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                'Start Recording',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricIndicator(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: AppColors.secondaryText,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}