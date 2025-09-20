import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';
import '../../../../shared/presentation/widgets/pull_to_refresh.dart';
import '../../../store/presentation/screens/store_screen.dart';

class MentorScreen extends ConsumerStatefulWidget {
  const MentorScreen({super.key});

  @override
  ConsumerState<MentorScreen> createState() => _MentorScreenState();
}

class _MentorScreenState extends ConsumerState<MentorScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _headerController;
  late AnimationController _listController;
  late Animation<double> _headerFade;
  late Animation<Offset> _listSlide;
  
  String _selectedSpecialization = 'all';
  String _selectedRating = 'all';
  List<Mentor> _mentors = [];
  bool _isLoading = false;
  
  final List<String> _specializations = [
    'all', 'sprint', 'endurance', 'strength', 'gymnastics', 'athletics'
  ];
  final List<String> _ratings = ['all', '4.5+', '4.0+', '3.5+'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeAnimations();
    _loadMentors();
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

  void _loadMentors() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _mentors = _generateMockMentors();
          _isLoading = false;
        });
      }
    });
  }

  List<Mentor> _generateMockMentors() {
    return [
      Mentor(
        id: '1',
        name: 'Coach Rajesh Kumar',
        specialization: 'Sprint & Speed Training',
        location: 'Mumbai, Maharashtra',
        rating: 4.9,
        reviewCount: 127,
        experience: '12 years',
        price: '₹1,500/session',
        bio: 'Former Olympic sprinter with extensive experience in developing speed and agility. Specializes in biomechanical analysis and performance optimization.',
        achievements: [
          'Olympic Games Qualifier',
          'National Champion (100m)',
          'Coach of 15+ State Champions',
        ],
        availability: 'Available Today',
        isVerified: true,
        languages: ['Hindi', 'English', 'Marathi'],
        sessionTypes: ['1-on-1 Training', 'Group Sessions', 'Video Analysis'],
      ),
      Mentor(
        id: '2',
        name: 'Dr. Priya Sharma',
        specialization: 'Endurance & Conditioning',
        location: 'Delhi, NCR',
        rating: 4.8,
        reviewCount: 89,
        experience: '8 years',
        price: '₹1,200/session',
        bio: 'Sports scientist and endurance coach with PhD in Exercise Physiology. Combines scientific approach with practical training methods.',
        achievements: [
          'PhD in Exercise Physiology',
          'Marathon World Championship Coach',
          'Published Researcher',
        ],
        availability: 'Available Tomorrow',
        isVerified: true,
        languages: ['Hindi', 'English'],
        sessionTypes: ['Training Programs', 'Nutrition Guidance', 'Recovery Planning'],
      ),
      Mentor(
        id: '3',
        name: 'Coach Vikram Singh',
        specialization: 'Strength & Power',
        location: 'Bengaluru, Karnataka',
        rating: 4.7,
        reviewCount: 156,
        experience: '15 years',
        price: '₹1,800/session',
        bio: 'Strength and conditioning specialist who has worked with professional athletes across multiple sports. Expert in powerlifting and Olympic lifting.',
        achievements: [
          'Certified Strength Coach (NSCA)',
          'Former Powerlifting Champion',
          'Team India Strength Coach',
        ],
        availability: 'Next Week',
        isVerified: true,
        languages: ['Hindi', 'English', 'Kannada'],
        sessionTypes: ['Strength Training', 'Power Development', 'Injury Prevention'],
      ),
      Mentor(
        id: '4',
        name: 'Coach Ananya Reddy',
        specialization: 'Gymnastics & Flexibility',
        location: 'Hyderabad, Telangana',
        rating: 4.9,
        reviewCount: 94,
        experience: '10 years',
        price: '₹1,400/session',
        bio: 'Former national gymnast specializing in flexibility, balance, and artistic movement. Focuses on injury prevention and mobility enhancement.',
        achievements: [
          'National Gymnastics Champion',
          'International Judge License',
          'Youth Development Program Director',
        ],
        availability: 'Available Today',
        isVerified: true,
        languages: ['Hindi', 'English', 'Telugu'],
        sessionTypes: ['Flexibility Training', 'Balance Work', 'Movement Quality'],
      ),
      Mentor(
        id: '5',
        name: 'Coach Rahul Mehta',
        specialization: 'Athletic Performance',
        location: 'Chennai, Tamil Nadu',
        rating: 4.6,
        reviewCount: 73,
        experience: '6 years',
        price: '₹1,000/session',
        bio: 'Multi-sport athlete and performance coach focusing on holistic athletic development. Specializes in mental conditioning and performance psychology.',
        achievements: [
          'Sports Psychology Certification',
          'Multi-Sport State Champion',
          'Mental Performance Specialist',
        ],
        availability: 'Available This Week',
        isVerified: false,
        languages: ['Hindi', 'English', 'Tamil'],
        sessionTypes: ['Mental Training', 'Performance Analysis', 'Goal Setting'],
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _headerController.dispose();
    _listController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();
    _loadMentors();
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(),
                  
                  const SizedBox(height: 24),
                  
                  // Search Bar
                  _buildSearchBar(),
                  
                  const SizedBox(height: 24),
                  
                  // Filter Tabs
                  _buildFilterTabs(),
                  
                  const SizedBox(height: 24),
                  
                  // Featured Mentors
                  _buildFeaturedSection(),
                  
                  const SizedBox(height: 24),
                  
                  // All Mentors
                  _buildMentorsList(),
                  
                  const SizedBox(height: 100), // Bottom padding for navigation
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
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonGlowPurple.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Find Mentors',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Learn from certified coaches',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.grey300,
                      ),
                    ),
                  ],
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
            hintText: 'Search mentors by name or specialization...',
            hintStyle: TextStyle(color: AppColors.grey400),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.grey400,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onChanged: (value) {
            // Implement search functionality
          },
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms);
  }

  Widget _buildFilterTabs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Specialization Filter
        Text(
          'Specialization',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.grey300,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _specializations.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final specialization = _specializations[index];
              final isSelected = _selectedSpecialization == specialization;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSpecialization = specialization;
                  });
                  HapticFeedback.lightImpact();
                  _loadMentors();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.purpleBlueGradient : null,
                    color: isSelected ? null : AppColors.glassSurface,
                    borderRadius: BorderRadius.circular(20),
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
                      specialization.toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.grey300,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Rating Filter
        Text(
          'Minimum Rating',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.grey300,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: _ratings.map((rating) {
            final isSelected = _selectedRating == rating;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRating = rating;
                  });
                  HapticFeedback.lightImpact();
                  _loadMentors();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(
                    right: rating != _ratings.last ? 8 : 0,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isSelected ? AppColors.neonGradient : null,
                    color: isSelected ? null : AppColors.glassSurface,
                    borderRadius: BorderRadius.circular(16),
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
                      rating.toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.grey300,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms);
  }

  Widget _buildFeaturedSection() {
    final featuredMentors = _mentors.where((mentor) => mentor.rating >= 4.8).take(2).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured Mentors',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: featuredMentors.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final mentor = featuredMentors[index];
              return _buildFeaturedMentorCard(mentor, index);
            },
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 600.ms);
  }

  Widget _buildFeaturedMentorCard(Mentor mentor, int index) {
    return GlassCard(
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.neonGreen.withOpacity(0.1),
              AppColors.neonGreen.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonGlowPurple.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              mentor.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (mentor.isVerified)
                            const Icon(
                              Icons.verified,
                              color: AppColors.neonGreen,
                              size: 16,
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 14,
                            color: AppColors.warmOrange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${mentor.rating}',
                            style: TextStyle(
                              color: AppColors.warmOrange,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${mentor.reviewCount})',
                            style: TextStyle(
                              color: AppColors.grey400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              mentor.specialization,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.neonGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mentor.bio,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.grey300,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  mentor.price,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                NeonButton(
                  text: 'Book',
                  onPressed: () => _showMentorDetails(mentor),
                  height: 32,
                  width: 80,
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate(delay: (index * 200 + 700).ms)
        .fadeIn(duration: 600.ms)
        .slideX(begin: 0.2, end: 0, curve: Curves.easeOut);
  }

  Widget _buildMentorsList() {
    return AnimatedBuilder(
      animation: _listSlide,
      builder: (context, child) {
        return SlideTransition(
          position: _listSlide,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'All Mentors',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                _buildLoadingMentors()
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _mentors.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final mentor = _mentors[index];
                    return _buildMentorCard(mentor, index);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingMentors() {
    return Column(
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: GlassCard(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.glassSurface,
                      shape: BoxShape.circle,
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

  Widget _buildMentorCard(Mentor mentor, int index) {
    return GlassCard(
      onTap: () => _showMentorDetails(mentor),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonGlowPurple.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
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
                              mentor.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (mentor.isVerified)
                            const Icon(
                              Icons.verified,
                              color: AppColors.neonGreen,
                              size: 18,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mentor.specialization,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.electricBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppColors.grey400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            mentor.location,
                            style: TextStyle(
                              color: AppColors.grey400,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.work_outline,
                            size: 14,
                            color: AppColors.grey400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            mentor.experience,
                            style: TextStyle(
                              color: AppColors.grey400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              mentor.bio,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey200,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Rating
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: AppColors.warmOrange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${mentor.rating}',
                      style: TextStyle(
                        color: AppColors.warmOrange,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${mentor.reviewCount})',
                      style: TextStyle(
                        color: AppColors.grey400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Availability
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getAvailabilityColor(mentor.availability).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    mentor.availability,
                    style: TextStyle(
                      color: _getAvailabilityColor(mentor.availability),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Price
                Text(
                  mentor.price,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate(delay: (index * 100 + 900).ms)
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.1, end: 0, curve: Curves.easeOut);
  }

  Color _getAvailabilityColor(String availability) {
    if (availability.contains('Today')) return AppColors.neonGreen;
    if (availability.contains('Tomorrow')) return AppColors.electricBlue;
    if (availability.contains('Week')) return AppColors.warmOrange;
    return AppColors.grey400;
  }

  void _showMentorDetails(Mentor mentor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildMentorDetailsSheet(mentor),
    );
  }

  Widget _buildMentorDetailsSheet(Mentor mentor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
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
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.neonGlowPurple.withOpacity(0.3),
                              blurRadius: 12,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    mentor.name,
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                if (mentor.isVerified)
                                  const Icon(
                                    Icons.verified,
                                    color: AppColors.neonGreen,
                                    size: 24,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              mentor.specialization,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.electricBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: AppColors.warmOrange,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${mentor.rating} (${mentor.reviewCount} reviews)',
                                  style: TextStyle(
                                    color: AppColors.warmOrange,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Bio
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    mentor.bio,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey200,
                      height: 1.6,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Achievements
                  Text(
                    'Achievements',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...mentor.achievements.map((achievement) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.neonGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              achievement,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.grey200,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  
                  const SizedBox(height: 24),
                  
                  // Session Types
                  Text(
                    'Session Types',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: mentor.sessionTypes.map((sessionType) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.electricBlue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.electricBlue.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          sessionType,
                          style: const TextStyle(
                            color: AppColors.electricBlue,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Book Button
                  NeonButton(
                    text: 'Book Session - ${mentor.price}',
                    onPressed: () {
                      Navigator.pop(context);
                      _bookSession(mentor);
                    },
                    width: double.infinity,
                    icon: Icons.calendar_today,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _bookSession(Mentor mentor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text(
          'Book Session',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Would you like to book a session with ${mentor.name}?',
          style: const TextStyle(color: AppColors.grey300),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          NeonButton(
            text: 'Confirm',
            onPressed: () {
              Navigator.pop(context);
              HapticFeedback.mediumImpact();
              // Handle booking logic
            },
            height: 40,
            width: 100,
          ),
        ],
      ),
    );
  }
}

class Mentor {
  final String id;
  final String name;
  final String specialization;
  final String location;
  final double rating;
  final int reviewCount;
  final String experience;
  final String price;
  final String bio;
  final List<String> achievements;
  final String availability;
  final bool isVerified;
  final List<String> languages;
  final List<String> sessionTypes;

  Mentor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.experience,
    required this.price,
    required this.bio,
    required this.achievements,
    required this.availability,
    required this.isVerified,
    required this.languages,
    required this.sessionTypes,
  });
}