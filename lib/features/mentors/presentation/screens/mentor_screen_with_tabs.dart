import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';
import '../../../store/presentation/screens/store_screen.dart';

class MentorScreenWithTabs extends ConsumerStatefulWidget {
  const MentorScreenWithTabs({super.key});

  @override
  ConsumerState<MentorScreenWithTabs> createState() => _MentorScreenWithTabsState();
}

class _MentorScreenWithTabsState extends ConsumerState<MentorScreenWithTabs>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          'Mentors & Store',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school, color: AppColors.electricBlue),
                  const SizedBox(width: 8),
                  const Text('Mentors'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.store, color: AppColors.neonGreen),
                  const SizedBox(width: 8),
                  const Text('Store'),
                ],
              ),
            ),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: AppColors.royalPurple,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMentorsTab(),
          const StoreScreen(),
        ],
      ),
    );
  }

  Widget _buildMentorsTab() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.deepCharcoal,
            AppColors.royalPurple.withOpacity(0.1),
            AppColors.electricBlue.withOpacity(0.05),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMentorHeader(),
            const SizedBox(height: 20),
            _buildFeaturedMentors(),
            const SizedBox(height: 20),
            _buildAllMentors(),
          ],
        ),
      ),
    );
  }

  Widget _buildMentorHeader() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.school,
                  color: AppColors.electricBlue,
                  size: 32,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expert Mentors',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Get personalized guidance from certified coaches',
                        style: TextStyle(
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.neonGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.neonGreen.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.stars,
                    color: AppColors.neonGreen,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Use credit points to book mentor sessions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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

  Widget _buildFeaturedMentors() {
    final List<MentorInfo> featuredMentors = [
      MentorInfo(
        id: '1',
        name: 'Coach Rajesh Kumar',
        specialization: 'Sprint & Speed Training',
        rating: 4.9,
        reviewCount: 127,
        price: '₹1,500/session',
        creditPrice: 75,
        imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
        isVerified: true,
        availability: 'Available Today',
      ),
      MentorInfo(
        id: '2',
        name: 'Dr. Priya Sharma',
        specialization: 'Endurance & Conditioning',
        rating: 4.8,
        reviewCount: 89,
        price: '₹1,200/session',
        creditPrice: 60,
        imageUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=200',
        isVerified: true,
        availability: 'Available Tomorrow',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Featured Mentors',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: featuredMentors.length,
            itemBuilder: (context, index) {
              final mentor = featuredMentors[index];
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 16),
                child: _buildMentorCard(mentor, isFeatured: true),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAllMentors() {
    final List<MentorInfo> allMentors = [
      MentorInfo(
        id: '3',
        name: 'Coach Vikram Singh',
        specialization: 'Strength & Power',
        rating: 4.7,
        reviewCount: 156,
        price: '₹1,800/session',
        creditPrice: 90,
        imageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200',
        isVerified: true,
        availability: 'Next Week',
      ),
      MentorInfo(
        id: '4',
        name: 'Coach Ananya Reddy',
        specialization: 'Gymnastics & Flexibility',
        rating: 4.9,
        reviewCount: 94,
        price: '₹1,400/session',
        creditPrice: 70,
        imageUrl: 'https://images.unsplash.com/photo-1544723795-3fb6469f5b39?w=200',
        isVerified: true,
        availability: 'Available Today',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'All Mentors',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: allMentors.length,
          itemBuilder: (context, index) {
            final mentor = allMentors[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildMentorCard(mentor),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMentorCard(MentorInfo mentor, {bool isFeatured = false}) {
    return GlassCard(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: isFeatured ? null : 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: isFeatured ? 30 : 25,
                  backgroundImage: NetworkImage(mentor.imageUrl),
                  onBackgroundImageError: (_, __) {},
                  backgroundColor: AppColors.royalPurple,
                  child: mentor.imageUrl.isEmpty
                      ? Icon(
                          Icons.person,
                          color: Colors.white,
                          size: isFeatured ? 30 : 25,
                        )
                      : null,
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
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isFeatured ? 16 : 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (mentor.isVerified)
                            Icon(
                              Icons.verified,
                              color: AppColors.neonGreen,
                              size: 16,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mentor.specialization,
                        style: TextStyle(
                          color: AppColors.electricBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppColors.warmOrange,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${mentor.rating}',
                            style: TextStyle(
                              color: AppColors.warmOrange,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${mentor.reviewCount})',
                            style: const TextStyle(
                              color: Colors.white54,
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
            if (isFeatured) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getAvailabilityColor(mentor.availability).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  mentor.availability,
                  style: TextStyle(
                    color: _getAvailabilityColor(mentor.availability),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            const Spacer(),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mentor.price,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.stars,
                          color: AppColors.neonGreen,
                          size: 12,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${mentor.creditPrice} pts',
                          style: TextStyle(
                            color: AppColors.neonGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                NeonButton(
                  onPressed: () => _showBookingDialog(mentor),
                  child: const Text('Book'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getAvailabilityColor(String availability) {
    if (availability.contains('Today')) return AppColors.neonGreen;
    if (availability.contains('Tomorrow')) return AppColors.electricBlue;
    if (availability.contains('Week')) return AppColors.warmOrange;
    return Colors.white54;
  }

  void _showBookingDialog(MentorInfo mentor) {
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
            'Book Session',
            style: TextStyle(
              color: AppColors.electricBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Book a session with ${mentor.name}?',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Cash: ',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    mentor.price,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.stars,
                    color: AppColors.neonGreen,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Credits: ${mentor.creditPrice} points',
                    style: TextStyle(
                      color: AppColors.neonGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _bookWithCredits(mentor);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neonGreen,
                    foregroundColor: Colors.black,
                  ),
                  child: Text('${mentor.creditPrice} pts'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _bookWithCash(mentor);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.electricBlue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Pay Cash'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _bookWithCredits(MentorInfo mentor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Session booked with ${mentor.name} using ${mentor.creditPrice} credit points!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _bookWithCash(MentorInfo mentor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Session booked with ${mentor.name} for ${mentor.price}!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class MentorInfo {
  final String id;
  final String name;
  final String specialization;
  final double rating;
  final int reviewCount;
  final String price;
  final int creditPrice;
  final String imageUrl;
  final bool isVerified;
  final String availability;

  MentorInfo({
    required this.id,
    required this.name,
    required this.specialization,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.creditPrice,
    required this.imageUrl,
    required this.isVerified,
    required this.availability,
  });
}