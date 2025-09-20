import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class CalibrationScreen extends StatelessWidget {
  final String testId;

  const CalibrationScreen({
    super.key,
    required this.testId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calibration')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.deepCharcoal, Color(0xFF1A0B2E), Color(0xFF16213E)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: GlassCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Calibrating sensors...'),
                  const SizedBox(height: 20),
                  PrimaryNeonButton(
                    text: 'Start Recording',
                    onPressed: () => context.go('/test/$testId/recording'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}