import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';
import '../../../../shared/presentation/widgets/pull_to_refresh.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _postsController;
  late Animation<double> _headerFade;
  late Animation<Offset> _postsSlide;
  
  final TextEditingController _postController = TextEditingController();
  List<CommunityPost> _posts = [];
  bool _isLoading = false;
  String _selectedFilter = 'recent';
  
  final List<String> _filters = ['recent', 'trending', 'following', 'achievements'];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadPosts();
    _startAnimations();
  }

  void _initializeAnimations() {
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _postsController = AnimationController(
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
    
    _postsSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _postsController,
      curve: Curves.easeOut,
    ));
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _headerController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _postsController.forward();
  }

  void _loadPosts() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _posts = _generateMockPosts();
          _isLoading = false;
        });
      }
    });
  }

  List<CommunityPost> _generateMockPosts() {
    return [
      CommunityPost(
        id: '1',
        author: 'Arjun Sharma',
        authorLocation: 'Mumbai, Maharashtra',
        timeAgo: '2h ago',
        content: 'Just hit a new personal best in my 100m sprint! 🏃‍♂️ 12.8 seconds - finally broke the 13-second barrier! All those early morning training sessions are paying off. #SprintGoals #PersonalBest',
        imageUrl: null,
        likes: 24,
        comments: 8,
        isLiked: false,
        type: PostType.achievement,
        achievement: 'Speed Demon',
      ),
      CommunityPost(
        id: '2',
        author: 'Priya Patel',
        authorLocation: 'Delhi, NCR',
        timeAgo: '4h ago',
        content: 'Training tip Tuesday! 💪 Remember to focus on your breathing during endurance tests. Proper breathing technique can improve your performance by 15-20%. Here\'s my simple breathing pattern that works great...',
        imageUrl: null,
        likes: 45,
        comments: 12,
        isLiked: true,
        type: PostType.tip,
      ),
      CommunityPost(
        id: '3',
        author: 'Vikram Singh',
        authorLocation: 'Bengaluru, Karnataka',
        timeAgo: '6h ago',
        content: 'Incredible training session today at the local track! The weather was perfect and I managed to complete all my speed drills without any issues. Feeling stronger every day! 💪',
        imageUrl: null,
        likes: 18,
        comments: 5,
        isLiked: false,
        type: PostType.update,
      ),
      CommunityPost(
        id: '4',
        author: 'Ananya Reddy',
        authorLocation: 'Hyderabad, Telangana',
        timeAgo: '8h ago',
        content: 'Question for the community: What\'s your favorite pre-workout snack? I\'ve been experimenting with different options and would love to hear what works best for everyone! 🍌',
        imageUrl: null,
        likes: 31,
        comments: 16,
        isLiked: true,
        type: PostType.question,
      ),
      CommunityPost(
        id: '5',
        author: 'Rahul Kumar',
        authorLocation: 'Chennai, Tamil Nadu',
        timeAgo: '1d ago',
        content: 'Completed my first elite-level assessment today! 🎉 It was challenging but incredibly rewarding. The AI feedback was spot-on and gave me clear areas to work on. Excited to see my progress over the coming weeks!',
        imageUrl: null,
        likes: 67,
        comments: 22,
        isLiked: false,
        type: PostType.milestone,
        achievement: 'Elite Athlete',
      ),
    ];
  }

  @override
  void dispose() {
    _headerController.dispose();
    _postsController.dispose();
    _postController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();
    _loadPosts();
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
                  
                  // Create Post Card
                  _buildCreatePostCard(),
                  
                  const SizedBox(height: 24),
                  
                  // Filter Tabs
                  _buildFilterTabs(),
                  
                  const SizedBox(height: 24),
                  
                  // Community Stats
                  _buildCommunityStats(),
                  
                  const SizedBox(height: 24),
                  
                  // Posts List
                  _buildPostsList(),
                  
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
                  gradient: AppColors.purpleBlueGradient,
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
                  Icons.groups,
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
                      'Community',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Connect with athletes nationwide',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.grey300,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  // Navigate to notifications
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.glassSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.glassBorder,
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.neonGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCreatePostCard() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AppColors.purpleBlueGradient,
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
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Share your training journey...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildPostTypeButton(
                    icon: Icons.fitness_center,
                    label: 'Training',
                    color: AppColors.electricBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPostTypeButton(
                    icon: Icons.emoji_events,
                    label: 'Achievement',
                    color: AppColors.neonGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPostTypeButton(
                    icon: Icons.help_outline,
                    label: 'Question',
                    color: AppColors.warmOrange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms, delay: 200.ms);
  }

  Widget _buildPostTypeButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showCreatePostDialog(label.toLowerCase());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
              HapticFeedback.lightImpact();
              _loadPosts();
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
                  filter.toUpperCase(),
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
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms);
  }

  Widget _buildCommunityStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Active Athletes',
            value: '12.5K',
            icon: Icons.people,
            color: AppColors.neonGreen,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'Posts Today',
            value: '247',
            icon: Icons.post_add,
            color: AppColors.electricBlue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            title: 'Online Now',
            value: '1.2K',
            icon: Icons.circle,
            color: AppColors.warmOrange,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 600.ms);
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.grey400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsList() {
    return AnimatedBuilder(
      animation: _postsSlide,
      builder: (context, child) {
        return SlideTransition(
          position: _postsSlide,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Posts',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                _buildLoadingPosts()
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _posts.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final post = _posts[index];
                    return _buildPostCard(post, index);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingPosts() {
    return Column(
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: GlassCard(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.glassSurface,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 120,
                              height: 16,
                              decoration: BoxDecoration(
                                color: AppColors.glassSurface,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 80,
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
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.glassSurface,
                      borderRadius: BorderRadius.circular(8),
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

  Widget _buildPostCard(CommunityPost post, int index) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: AppColors.purpleBlueGradient,
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
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post.author,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          if (post.achievement != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                gradient: AppColors.neonGradient,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                post.achievement!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: AppColors.grey400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            post.authorLocation,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.grey400,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '• ${post.timeAgo}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.grey400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildPostTypeIcon(post.type),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Post Content
            Text(
              post.content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey200,
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Post Actions
            Row(
              children: [
                _buildActionButton(
                  icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
                  label: '${post.likes}',
                  color: post.isLiked ? AppColors.brightRed : AppColors.grey400,
                  onTap: () => _toggleLike(post),
                ),
                const SizedBox(width: 24),
                _buildActionButton(
                  icon: Icons.chat_bubble_outline,
                  label: '${post.comments}',
                  color: AppColors.grey400,
                  onTap: () => _showCommentsDialog(post),
                ),
                const SizedBox(width: 24),
                _buildActionButton(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  color: AppColors.grey400,
                  onTap: () => _sharePost(post),
                ),
                const Spacer(),
                _buildActionButton(
                  icon: Icons.bookmark_border,
                  label: '',
                  color: AppColors.grey400,
                  onTap: () => _bookmarkPost(post),
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

  Widget _buildPostTypeIcon(PostType type) {
    IconData icon;
    Color color;
    
    switch (type) {
      case PostType.achievement:
        icon = Icons.emoji_events;
        color = AppColors.neonGreen;
        break;
      case PostType.tip:
        icon = Icons.lightbulb_outline;
        color = AppColors.electricBlue;
        break;
      case PostType.question:
        icon = Icons.help_outline;
        color = AppColors.warmOrange;
        break;
      case PostType.milestone:
        icon = Icons.flag;
        color = AppColors.royalPurple;
        break;
      default:
        icon = Icons.fitness_center;
        color = AppColors.grey400;
    }
    
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        color: color,
        size: 14,
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 18,
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showCreatePostDialog(String type) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Create ${type.capitalize()} Post',
            style: const TextStyle(color: Colors.white),
          ),
          content: TextField(
            controller: _postController,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Share your thoughts...',
              hintStyle: TextStyle(color: AppColors.grey400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.glassBorder),
              ),
              filled: true,
              fillColor: AppColors.glassSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            NeonButton(
              text: 'Post',
              onPressed: () {
                Navigator.of(context).pop();
                _createPost();
              },
              height: 40,
            ),
          ],
        );
      },
    );
  }

  void _showCommentsDialog(CommunityPost post) {
    // Implementation for showing comments
    HapticFeedback.lightImpact();
  }

  void _toggleLike(CommunityPost post) {
    setState(() {
      post.isLiked = !post.isLiked;
      post.likes += post.isLiked ? 1 : -1;
    });
    HapticFeedback.lightImpact();
  }

  void _sharePost(CommunityPost post) {
    HapticFeedback.lightImpact();
    // Implementation for sharing post
  }

  void _bookmarkPost(CommunityPost post) {
    HapticFeedback.lightImpact();
    // Implementation for bookmarking post
  }

  void _createPost() {
    if (_postController.text.trim().isNotEmpty) {
      // Implementation for creating new post
      _postController.clear();
      HapticFeedback.mediumImpact();
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class CommunityPost {
  final String id;
  final String author;
  final String authorLocation;
  final String timeAgo;
  final String content;
  final String? imageUrl;
  int likes;
  final int comments;
  bool isLiked;
  final PostType type;
  final String? achievement;

  CommunityPost({
    required this.id,
    required this.author,
    required this.authorLocation,
    required this.timeAgo,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.isLiked,
    required this.type,
    this.achievement,
  });
}

enum PostType {
  update,
  achievement,
  tip,
  question,
  milestone,
}