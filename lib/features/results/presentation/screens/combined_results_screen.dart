import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';

class CombinedResultsScreen extends StatelessWidget {
  final List<String> resultIds;
  const CombinedResultsScreen({super.key, this.resultIds = const []});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.deepCharcoal, Color(0xFF1A0B2E), Color(0xFF16213E)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text('Combined Results', style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 20),
                const Expanded(
                  child: GlassCard(
                    child: Center(child: Text('Combined test results and analytics')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}