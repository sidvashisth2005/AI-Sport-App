import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/credit_points_model.dart';

class CreditsScreen extends ConsumerStatefulWidget {
  const CreditsScreen({super.key});

  @override
  ConsumerState<CreditsScreen> createState() => _CreditsScreenState();
}

class _CreditsScreenState extends ConsumerState<CreditsScreen> {
  final CreditPoints mockCredits = CreditPoints(
    id: 'user_credits_1',
    userId: 'user_123',
    totalPoints: 1250,
    availablePoints: 1100,
    usedPoints: 150,
    transactions: [
      CreditTransaction(
        id: 'txn_1',
        userId: 'user_123',
        points: 50,
        type: CreditTransactionType.earned,
        description: 'Completed Sprint Test - Excellent Performance',
        relatedId: 'test_sprint_001',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      CreditTransaction(
        id: 'txn_2',
        userId: 'user_123',
        points: 75,
        type: CreditTransactionType.used,
        description: 'Booked session with Coach Rajesh Kumar',
        relatedId: 'mentor_session_001',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      CreditTransaction(
        id: 'txn_3',
        userId: 'user_123',
        points: 80,
        type: CreditTransactionType.used,
        description: 'Purchased Premium Whey Protein',
        relatedId: 'product_001',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      CreditTransaction(
        id: 'txn_4',
        userId: 'user_123',
        points: 100,
        type: CreditTransactionType.bonus,
        description: 'Weekly Achievement Bonus',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      CreditTransaction(
        id: 'txn_5',
        userId: 'user_123',
        points: 40,
        type: CreditTransactionType.earned,
        description: 'Completed Endurance Test',
        relatedId: 'test_endurance_001',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ],
    lastUpdated: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepCharcoal,
      appBar: AppBar(
        backgroundColor: AppColors.deepCharcoal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Credit Points',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCreditsOverview(),
            const SizedBox(height: 24),
            _buildQuickActions(),
            const SizedBox(height: 24),
            _buildEarningOpportunities(),
            const SizedBox(height: 24),
            _buildTransactionHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditsOverview() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.neonGreen, AppColors.electricBlue],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.stars,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Available Credits',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${mockCredits.availablePoints}',
                        style: TextStyle(
                          color: AppColors.neonGreen,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.royalPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.royalPurple.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Total Earned',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${mockCredits.totalPoints}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white24,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Total Used',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${mockCredits.usedPoints}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Book Mentor',
                'Use credits for coaching',
                Icons.school,
                AppColors.electricBlue,
                () => _showBookMentorDialog(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Shop Store',
                'Buy supplements',
                Icons.store,
                AppColors.neonGreen,
                () => _showStoreDialog(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: color),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEarningOpportunities() {
    final opportunities = [
      {'title': 'Complete Tests', 'points': '10-50 pts', 'icon': Icons.fitness_center},
      {'title': 'Weekly Challenges', 'points': '100 pts', 'icon': Icons.emoji_events},
      {'title': 'Refer Friends', 'points': '200 pts', 'icon': Icons.people},
      {'title': 'Daily Login', 'points': '5 pts', 'icon': Icons.login},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Earn More Credits',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...opportunities.map((opportunity) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: GlassCard(
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.warmOrange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    opportunity['icon'] as IconData,
                    color: AppColors.warmOrange,
                    size: 20,
                  ),
                ),
                title: Text(
                  opportunity['title'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.neonGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    opportunity['points'] as String,
                    style: TextStyle(
                      color: AppColors.neonGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTransactionHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Transactions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...mockCredits.transactions.take(5).map((transaction) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: GlassCard(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getTransactionColor(transaction.type).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        _getTransactionIcon(transaction.type),
                        color: _getTransactionColor(transaction.type),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.description,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatDate(transaction.createdAt),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${transaction.type == CreditTransactionType.earned || transaction.type == CreditTransactionType.bonus ? '+' : '-'}${transaction.points}',
                      style: TextStyle(
                        color: _getTransactionColor(transaction.type),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Color _getTransactionColor(CreditTransactionType type) {
    switch (type) {
      case CreditTransactionType.earned:
        return AppColors.neonGreen;
      case CreditTransactionType.used:
        return AppColors.brightRed;
      case CreditTransactionType.bonus:
        return AppColors.warmOrange;
      case CreditTransactionType.refund:
        return AppColors.electricBlue;
    }
  }

  IconData _getTransactionIcon(CreditTransactionType type) {
    switch (type) {
      case CreditTransactionType.earned:
        return Icons.add_circle;
      case CreditTransactionType.used:
        return Icons.remove_circle;
      case CreditTransactionType.bonus:
        return Icons.star;
      case CreditTransactionType.refund:
        return Icons.refresh;
    }
  }

  String _formatDate(DateTime dateTime) {
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

  void _showBookMentorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.deepCharcoal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.electricBlue.withOpacity(0.3)),
          ),
          title: Text(
            'Book Mentor Session',
            style: TextStyle(
              color: AppColors.electricBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Navigate to the mentors section to book a session using your credit points.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to mentors screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.electricBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Go to Mentors'),
            ),
          ],
        );
      },
    );
  }

  void _showStoreDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.deepCharcoal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.neonGreen.withOpacity(0.3)),
          ),
          title: Text(
            'Shop with Credits',
            style: TextStyle(
              color: AppColors.neonGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Navigate to the store section to purchase supplements using your credit points.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to store screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neonGreen,
                foregroundColor: Colors.black,
              ),
              child: const Text('Go to Store'),
            ),
          ],
        );
      },
    );
  }
}