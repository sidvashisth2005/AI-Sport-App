import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class TestListScreen extends ConsumerStatefulWidget {
  const TestListScreen({super.key});

  @override
  ConsumerState<TestListScreen> createState() => _TestListScreenState();
}

class _TestListScreenState extends ConsumerState<TestListScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Speed', 'Strength', 'Endurance', 'Agility', 'Flexibility'];

  final List<Map<String, dynamic>> _tests = [
    {
      'id': 'sprint_test',
      'name': '100m Sprint Test',
      'description': 'Measure your top running speed over 100 meters',
      'category': 'Speed',
      'duration': '5 min',
      'difficulty': 'Intermediate',
      'icon': Icons.directions_run,
      'color': AppColors.neonGreen,
      'points': 15,
      'isPopular': true,
    },
    {
      'id': 'push_up_test',
      'name': 'Push-up Endurance',
      'description': 'Test your upper body strength and endurance',
      'category': 'Strength',
      'duration': '3 min',
      'difficulty': 'Beginner',
      'icon': Icons.fitness_center,
      'color': AppColors.electricBlue,
      'points': 10,
      'isPopular': false,
    },
    {
      'id': 'flexibility_test',
      'name': 'Sit-and-Reach Test',
      'description': 'Assess your lower back and hamstring flexibility',
      'category': 'Flexibility',
      'duration': '2 min',
      'difficulty': 'Beginner',
      'icon': Icons.accessibility_new,
      'color': AppColors.royalPurple,
      'points': 8,
      'isPopular': false,
    },
    {
      'id': 'jump_test',
      'name': 'Vertical Jump Test',
      'description': 'Measure your explosive lower body power',
      'category': 'Strength',
      'duration': '4 min',
      'difficulty': 'Intermediate',
      'icon': Icons.trending_up,
      'color': AppColors.warmOrange,
      'points': 12,
      'isPopular': true,
    },
    {
      'id': 'agility_test',
      'name': 'Cone Agility Test',
      'description': 'Test your speed, agility, and coordination',
      'category': 'Agility',
      'duration': '6 min',
      'difficulty': 'Advanced',
      'icon': Icons.zoom_out_map,
      'color': AppColors.neonGreen,
      'points': 18,
      'isPopular': false,
    },
    {
      'id': 'endurance_test',
      'name': '12-Minute Run Test',
      'description': 'Evaluate your cardiovascular endurance',
      'category': 'Endurance',
      'duration': '15 min',
      'difficulty': 'Advanced',
      'icon': Icons.timer,
      'color': AppColors.electricBlue,
      'points': 20,
      'isPopular': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredTests {
    if (_selectedCategory == 'All') {
      return _tests;
    }
    return _tests.where((test) => test['category'] == _selectedCategory).toList();
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
                        'Fitness Tests',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Choose your assessment',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                ),
                actions: [
                  IconButton(
                    onPressed: () => context.go('/test-history'),
                    icon: const Icon(Icons.history, color: Colors.white),
                  ),
                ],
              ),
              
              // Content
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Category Filter
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Categories',
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
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Popular Tests Section
                    if (_selectedCategory == 'All') ...[
                      Text(
                        'Popular Tests',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _tests.where((test) => test['isPopular'] == true).length,
                          itemBuilder: (context, index) {
                            final popularTests = _tests.where((test) => test['isPopular'] == true).toList();
                            final test = popularTests[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                right: index < popularTests.length - 1 ? 16 : 0,
                              ),
                              child: _buildPopularTestCard(test),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                    
                    // All Tests Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedCategory == 'All' ? 'All Tests' : '$_selectedCategory Tests',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_filteredTests.length} tests',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Test List
                    ..._filteredTests.map((test) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildTestCard(test),
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

  Widget _buildPopularTestCard(Map<String, dynamic> test) {
    return GestureDetector(
      onTap: () => context.go('/test/${test['id']}'),
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              test['color'].withOpacity(0.3),
              test['color'].withOpacity(0.1),
            ],
          ),
          border: Border.all(
            color: test['color'].withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    test['icon'],
                    color: test['color'],
                    size: 32,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.neonGreen,
                    ),
                    child: Text(
                      'POPULAR',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                test['name'],
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                test['duration'],
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${test['points']} pts',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.neonGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: test['color'],
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestCard(Map<String, dynamic> test) {
    return GestureDetector(
      onTap: () => context.go('/test/${test['id']}'),
      child: GlassCard(
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    test['color'].withOpacity(0.3),
                    test['color'].withOpacity(0.1),
                  ],
                ),
              ),
              child: Icon(
                test['icon'],
                color: test['color'],
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          test['name'],
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (test['isPopular'])
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.neonGreen,
                          ),
                          child: Text(
                            'POPULAR',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 8,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    test['description'],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.secondaryText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoChip(test['duration'], Icons.timer),
                      const SizedBox(width: 8),
                      _buildInfoChip(test['difficulty'], Icons.signal_cellular_alt),
                      const SizedBox(width: 8),
                      _buildInfoChip('${test['points']} pts', Icons.stars),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.secondaryText,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.glassSurface,
        border: Border.all(
          color: AppColors.glassBorder,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppColors.secondaryText,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.secondaryText,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}