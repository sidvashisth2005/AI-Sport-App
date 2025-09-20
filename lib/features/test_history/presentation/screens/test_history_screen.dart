import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/pull_to_refresh.dart';

class TestHistoryScreen extends ConsumerStatefulWidget {
  const TestHistoryScreen({super.key});

  @override
  ConsumerState<TestHistoryScreen> createState() => _TestHistoryScreenState();
}

class _TestHistoryScreenState extends ConsumerState<TestHistoryScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _listController;
  late Animation<double> _headerFade;
  late Animation<Offset> _listSlide;
  
  String _selectedCategory = 'all';
  String _selectedTimeframe = 'all';
  String _searchQuery = '';
  
  final List<String> _categories = ['all', 'speed', 'strength', 'endurance', 'flexibility'];
  final List<String> _timeframes = ['all', 'week', 'month', '3months'];
  
  List<TestHistoryEntry> _testHistory = [];
  List<TestHistoryEntry> _filteredHistory = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadTestHistory();
    _startAnimations();
  }

  void _initializeAnimations() {
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _listController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _headerFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    ));
    
    _listSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _listController,
      curve: Curves.easeOut,
    ));
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _headerController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _listController.forward();
  }

  void _loadTestHistory() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _testHistory = _generateTestHistory();
          _filteredHistory = _testHistory;
          _isLoading = false;
        });
        _applyFilters();
      }
    });
  }

  List<TestHistoryEntry> _generateTestHistory() {
    return [
      TestHistoryEntry(
        id: '1',
        testName: 'Sprint 100m',
        category: 'Speed & Agility',
        categoryKey: 'speed',
        date: DateTime.now().subtract(const Duration(days: 1)),
        score: 89,
        result: '12.8s',
        improvement: '+0.3s',
        rank: 42,
        icon: Icons.flash_on,
        color: AppColors.neonGreen,
        details: {
          'Acceleration (0-30m)': '4.2s',
          'Top Speed (30-60m)': '3.8s',
          'Speed Maintenance (60-100m)': '4.8s',
          'Form Score': '91%',
        },
      ),
      TestHistoryEntry(
        id: '2',
        testName: 'Vertical Jump',
        category: 'Strength & Power',
        categoryKey: 'strength',
        date: DateTime.now().subtract(const Duration(days: 3)),
        score: 76,
        result: '58cm',
        improvement: '+3cm',
        rank: 67,
        icon: Icons.fitness_center,
        color: AppColors.electricBlue,
        details: {
          'Jump Height': '58cm',
          'Power Output': '2847W',
          'Landing Form': '84%',
          'Takeoff Speed': '3.4m/s',
        },
      ),
      TestHistoryEntry(
        id: '3',
        testName: 'Cooper Test',
        category: 'Endurance',
        categoryKey: 'endurance',
        date: DateTime.now().subtract(const Duration(days: 5)),
        score: 82,
        result: '2847m',
        improvement: '+127m',
        rank: 51,
        icon: Icons.directions_run,
        color: AppColors.warmOrange,
        details: {
          'Distance Covered': '2847m',
          'Average Pace': '4:12/km',
          'Heart Rate Max': '187 bpm',
          'VO2 Max Estimate': '52.3 ml/kg/min',
        },
      ),
      TestHistoryEntry(
        id: '4',
        testName: 'Sit and Reach',
        category: 'Flexibility & Balance',
        categoryKey: 'flexibility',
        date: DateTime.now().subtract(const Duration(days: 7)),
        score: 94,
        result: '+15cm',
        improvement: '+2cm',
        rank: 23,
        icon: Icons.accessibility_new,
        color: AppColors.royalPurple,
        details: {
          'Reach Distance': '+15cm',
          'Hip Flexibility': '95%',
          'Hamstring Length': 'Excellent',
          'Lower Back Mobility': '92%',
        },
      ),
      TestHistoryEntry(
        id: '5',
        testName: 'Plank Hold',
        category: 'Endurance',
        categoryKey: 'endurance',
        date: DateTime.now().subtract(const Duration(days: 10)),
        score: 71,
        result: '3:45',
        improvement: '+15s',
        rank: 89,
        icon: Icons.directions_run,
        color: AppColors.warmOrange,
        details: {
          'Hold Duration': '3:45',
          'Form Stability': '88%',
          'Core Strength': '76%',
          'Muscle Fatigue Rate': 'Moderate',
        },
      ),
      TestHistoryEntry(
        id: '6',
        testName: 'Sprint 60m',
        category: 'Speed & Agility',
        categoryKey: 'speed',
        date: DateTime.now().subtract(const Duration(days: 14)),
        score: 85,
        result: '7.8s',
        improvement: '+0.1s',
        rank: 38,
        icon: Icons.flash_on,
        color: AppColors.neonGreen,
        details: {
          'Sprint Time': '7.8s',
          'Acceleration Phase': '2.8s',
          'Top Speed Phase': '5.0s',
          'Form Analysis': '89%',
        },
      ),
      TestHistoryEntry(
        id: '7',
        testName: 'Push-up Test',
        category: 'Strength & Power',
        categoryKey: 'strength',
        date: DateTime.now().subtract(const Duration(days: 18)),
        score: 78,
        result: '42 reps',
        improvement: '+3 reps',
        rank: 56,
        icon: Icons.fitness_center,
        color: AppColors.electricBlue,
        details: {
          'Repetitions': '42',
          'Form Score': '86%',
          'Endurance Rate': '82%',
          'Power Output': 'Good',
        },
      ),
      TestHistoryEntry(
        id: '8',
        testName: 'Beep Test',
        category: 'Endurance',
        categoryKey: 'endurance',
        date: DateTime.now().subtract(const Duration(days: 21)),
        score: 80,
        result: 'Level 12.4',
        improvement: '+0.6 levels',
        rank: 48,
        icon: Icons.directions_run,
        color: AppColors.warmOrange,
        details: {
          'Final Level': '12.4',
          'Distance Covered': '2680m',
          'VO2 Max': '51.8 ml/kg/min',
          'Recovery Rate': 'Excellent',
        },
      ),
    ];
  }

  void _applyFilters() {
    List<TestHistoryEntry> filtered = List.from(_testHistory);
    
    // Apply category filter
    if (_selectedCategory != 'all') {
      filtered = filtered.where((entry) => entry.categoryKey == _selectedCategory).toList();
    }
    
    // Apply timeframe filter
    if (_selectedTimeframe != 'all') {
      final now = DateTime.now();
      DateTime cutoffDate;
      
      switch (_selectedTimeframe) {
        case 'week':
          cutoffDate = now.subtract(const Duration(days: 7));
          break;
        case 'month':
          cutoffDate = now.subtract(const Duration(days: 30));
          break;
        case '3months':
          cutoffDate = now.subtract(const Duration(days: 90));
          break;
        default:
          cutoffDate = DateTime(2000);
      }
      
      filtered = filtered.where((entry) => entry.date.isAfter(cutoffDate)).toList();
    }
    
    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((entry) =>
          entry.testName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          entry.category.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    
    // Sort by date (newest first)
    filtered.sort((a, b) => b.date.compareTo(a.date));
    
    setState(() {
      _filteredHistory = filtered;
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _listController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();
    _loadTestHistory();
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
              padding: ResponsiveUtils.getResponsivePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(),
                  
                  const SizedBox(height: 24),
                  
                  // Search Bar
                  _buildSearchBar(),
                  
                  const SizedBox(height: 24),
                  
                  // Filters
                  _buildFilters(),
                  
                  const SizedBox(height: 24),
                  
                  // Summary Stats
                  _buildSummaryStats(),
                  
                  const SizedBox(height: 24),
                  
                  // Test History List
                  _buildTestHistoryList(),
                  
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
                  width: ResponsiveUtils.getResponsiveIconSize(context, 44),
                  height: ResponsiveUtils.getResponsiveIconSize(context, 44),
                  decoration: BoxDecoration(
                    color: AppColors.glassSurface,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 12)),
                    border: Border.all(
                      color: AppColors.glassBorder,
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: ResponsiveUtils.getResponsiveIconSize(context, 20),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test History',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 28),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your complete test journey',
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
                  Icons.history,
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

  Widget _buildSearchBar() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search tests...',
            hintStyle: TextStyle(color: AppColors.grey400),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.grey400,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
            _applyFilters();
          },
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms);
  }

  Widget _buildFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Filter
        Text(
          'Category',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.grey300,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: ResponsiveUtils.getResponsiveIconSize(context, 40),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (context, index) => SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                  HapticFeedback.lightImpact();
                  _applyFilters();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.getResponsiveSpacing(context, 20), 
                    vertical: ResponsiveUtils.getResponsiveSpacing(context, 10)
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.purpleBlueGradient : null,
                    color: isSelected ? null : AppColors.glassSurface,
                    borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 20)),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : AppColors.glassBorder,
                      width: 1,
                    ),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: AppColors.neonGlowPurple.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ] : null,
                  ),
                  child: Center(
                    child: Text(
                      category.toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.grey300,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Timeframe Filter
        Text(
          'Timeframe',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.grey300,
          ),
        ),
        const SizedBox(height: 12),
        ResponsiveUtils.isMobile(context) 
          ? Column(
              children: _timeframes.map((timeframe) {
                return _buildTimeframeButton(context, timeframe);
              }).toList(),
            )
          : Row(
              children: _timeframes.map((timeframe) {
                return Expanded(child: _buildTimeframeButton(context, timeframe));
              }).toList(),
            ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms);
  }

  Widget _buildTimeframeButton(BuildContext context, String timeframe) {
    final isSelected = _selectedTimeframe == timeframe;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTimeframe = timeframe;
        });
        HapticFeedback.lightImpact();
        _applyFilters();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(
          right: timeframe != _timeframes.last ? ResponsiveUtils.getResponsiveSpacing(context, 8) : 0,
          bottom: ResponsiveUtils.isMobile(context) ? ResponsiveUtils.getResponsiveSpacing(context, 8) : 0,
        ),
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveUtils.getResponsiveSpacing(context, 12),
          horizontal: ResponsiveUtils.isMobile(context) ? ResponsiveUtils.getResponsiveSpacing(context, 16) : 0,
        ),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.neonGradient : null,
          color: isSelected ? null : AppColors.glassSurface,
          borderRadius: BorderRadius.circular(ResponsiveUtils.getResponsiveBorderRadius(context, 16)),
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
            _getTimeframeLabel(timeframe),
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.grey300,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 13),
            ),
          ),
        ),
      ),
    );
  }

  String _getTimeframeLabel(String timeframe) {
    switch (timeframe) {
      case 'all':
        return 'ALL';
      case 'week':
        return 'WEEK';
      case 'month':
        return 'MONTH';
      case '3months':
        return '3M';
      default:
        return timeframe.toUpperCase();
    }
  }

  Widget _buildSummaryStats() {
    final totalTests = _filteredHistory.length;
    final averageScore = totalTests > 0
        ? (_filteredHistory.map((e) => e.score).reduce((a, b) => a + b) / totalTests).round()
        : 0;
    final bestScore = totalTests > 0
        ? _filteredHistory.map((e) => e.score).reduce((a, b) => a > b ? a : b)
        : 0;
    final bestRank = totalTests > 0
        ? _filteredHistory.map((e) => e.rank).reduce((a, b) => a < b ? a : b)
        : 0;

    return (ResponsiveUtils.isMobile(context)
        ? Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Total Tests',
                      value: '$totalTests',
                      icon: Icons.assignment_turned_in,
                      color: AppColors.electricBlue,
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Avg Score',
                      value: '$averageScore%',
                      icon: Icons.trending_up,
                      color: AppColors.neonGreen,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Best Score',
                      value: '$bestScore%',
                      icon: Icons.emoji_events,
                      color: AppColors.warmOrange,
                    ),
                  ),
                  SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Best Rank',
                      value: '#$bestRank',
                      icon: Icons.leaderboard,
                      color: AppColors.royalPurple,
                    ),
                  ),
                ],
              ),
            ],
          )
        : Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Total Tests',
                  value: '$totalTests',
                  icon: Icons.assignment_turned_in,
                  color: AppColors.electricBlue,
                ),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
              Expanded(
                child: _buildStatCard(
                  title: 'Avg Score',
                  value: '$averageScore%',
                  icon: Icons.trending_up,
                  color: AppColors.neonGreen,
                ),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
              Expanded(
                child: _buildStatCard(
                  title: 'Best Score',
                  value: '$bestScore%',
                  icon: Icons.emoji_events,
                  color: AppColors.warmOrange,
                ),
              ),
              SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
              Expanded(
                child: _buildStatCard(
                  title: 'Best Rank',
                  value: '#$bestRank',
                  icon: Icons.leaderboard,
                  color: AppColors.royalPurple,
                ),
              ),
            ],
          )).animate().fadeIn(duration: 600.ms, delay: 600.ms);
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return GlassCard(
      child: Padding(
        padding: ResponsiveUtils.getResponsiveCardPadding(context),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: ResponsiveUtils.getResponsiveIconSize(context, 20),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4)),
            Text(
              title,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.grey400,
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestHistoryList() {
    return AnimatedBuilder(
      animation: _listSlide,
      builder: (context, child) {
        return SlideTransition(
          position: _listSlide,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Test Results',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (_filteredHistory.isNotEmpty)
                    Text(
                      '${_filteredHistory.length} ${_filteredHistory.length == 1 ? 'result' : 'results'}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey400,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                _buildLoadingList()
              else if (_filteredHistory.isEmpty)
                _buildEmptyState()
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredHistory.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final entry = _filteredHistory[index];
                    return _buildHistoryCard(entry, index);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingList() {
    return Column(
      children: List.generate(5, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.glassSurface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.glassSurface,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 100,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.glassSurface,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: AppColors.grey500,
            ),
            const SizedBox(height: 16),
            Text(
              'No Test Results',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.grey400,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No tests match your current filters.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(TestHistoryEntry entry, int index) {
    return GlassCard(
      onTap: () => _showTestDetails(entry),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: entry.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    entry.icon,
                    color: entry.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.testName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.category,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: entry.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      entry.result,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getScoreColor(entry.score).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${entry.score}%',
                        style: TextStyle(
                          color: _getScoreColor(entry.score),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: AppColors.grey400,
                ),
                const SizedBox(width: 6),
                Text(
                  _formatDate(entry.date),
                  style: TextStyle(
                    color: AppColors.grey400,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.leaderboard,
                  size: 14,
                  color: AppColors.grey400,
                ),
                const SizedBox(width: 6),
                Text(
                  'Rank #${entry.rank}',
                  style: TextStyle(
                    color: AppColors.grey400,
                    fontSize: 12,
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
                    entry.improvement,
                    style: const TextStyle(
                      color: AppColors.neonGreen,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate(delay: (index * 100 + 800).ms)
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.1, end: 0, curve: Curves.easeOut);
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return AppColors.neonGreen;
    if (score >= 75) return AppColors.electricBlue;
    if (score >= 60) return AppColors.warmOrange;
    return AppColors.brightRed;
  }

  void _showTestDetails(TestHistoryEntry entry) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: entry.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      entry.icon,
                      color: entry.color,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.testName,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(entry.date),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.grey400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Score Overview
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDetailMetric('Result', entry.result),
                  _buildDetailMetric('Score', '${entry.score}%'),
                  _buildDetailMetric('Rank', '#${entry.rank}'),
                  _buildDetailMetric('Improvement', entry.improvement),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Detailed Metrics
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detailed Metrics',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...entry.details.entries.map((detail) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              detail.key,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.grey300,
                              ),
                            ),
                            Text(
                              detail.value,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.grey400,
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

class TestHistoryEntry {
  final String id;
  final String testName;
  final String category;
  final String categoryKey;
  final DateTime date;
  final int score;
  final String result;
  final String improvement;
  final int rank;
  final IconData icon;
  final Color color;
  final Map<String, String> details;

  TestHistoryEntry({
    required this.id,
    required this.testName,
    required this.category,
    required this.categoryKey,
    required this.date,
    required this.score,
    required this.result,
    required this.improvement,
    required this.rank,
    required this.icon,
    required this.color,
    required this.details,
  });
}