import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class TestCompletionScreen extends StatelessWidget {
  final String testId;
  final String? resultId;
  final Map<String, dynamic>? result;

  const TestCompletionScreen({
    super.key,
    required this.testId,
    this.resultId,
    this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Complete')),
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
                  const Icon(Icons.check_circle, color: AppColors.accent, size: 64),
                  const SizedBox(height: 20),
                  const Text('Test Completed Successfully!'),
                  const SizedBox(height: 20),
                  Text('Score: ${result?['score'] ?? 0}'),
                  const SizedBox(height: 30),
                  PrimaryNeonButton(
                    text: 'View Personalized Solution',
                    onPressed: () => context.go('/personalized-solution/result_123'),
                  ),
                  const SizedBox(height: 16),
                  OutlineNeonButton(
                    text: 'Go Home',
                    onPressed: () => context.go('/home'),
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