import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/product_model.dart';
import 'product_detail_screen.dart';

class StoreScreen extends ConsumerStatefulWidget {
  const StoreScreen({super.key});

  @override
  ConsumerState<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends ConsumerState<StoreScreen> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Protein', 'Supplements', 'Energy', 'Recovery'];

  final List<Product> mockProducts = [
    Product(
      id: '1',
      name: 'Premium Whey Protein',
      description: 'High-quality whey protein for muscle building and recovery',
      price: 2999.0,
      creditPrice: 150,
      imageUrl: 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=400',
      category: 'Protein',
      isMentorRecommended: true,
      mentorName: 'Dr. Sarah Johnson',
      rating: 4.8,
      reviewCount: 156,
      isInStock: true,
    ),
    Product(
      id: '2',
      name: 'BCAA Energy Drink',
      description: 'Essential amino acids for endurance and muscle preservation',
      price: 1599.0,
      creditPrice: 80,
      imageUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=400',
      category: 'Energy',
      isMentorRecommended: true,
      mentorName: 'Coach Mike Wilson',
      rating: 4.6,
      reviewCount: 89,
      isInStock: true,
    ),
    Product(
      id: '3',
      name: 'Recovery Formula',
      description: 'Advanced recovery blend for faster muscle repair',
      price: 2199.0,
      creditPrice: 110,
      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
      category: 'Recovery',
      isMentorRecommended: false,
      rating: 4.7,
      reviewCount: 203,
      isInStock: true,
    ),
    Product(
      id: '4',
      name: 'Creatine Monohydrate',
      description: 'Pure creatine for strength and power enhancement',
      price: 899.0,
      creditPrice: 45,
      imageUrl: 'https://images.unsplash.com/photo-1584464491033-06628f3a6b7b?w=400',
      category: 'Supplements',
      isMentorRecommended: true,
      mentorName: 'Dr. Priya Sharma',
      rating: 4.9,
      reviewCount: 312,
      isInStock: false,
    ),
  ];

  List<Product> get filteredProducts {
    if (selectedCategory == 'All') return mockProducts;
    return mockProducts.where((product) => product.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepCharcoal,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.deepCharcoal,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Store',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.royalPurple.withOpacity(0.3),
                      AppColors.electricBlue.withOpacity(0.2),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCreditPointsCard(),
                  const SizedBox(height: 20),
                  _buildCategoryFilter(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = filteredProducts[index];
                  return _buildProductCard(product);
                },
                childCount: filteredProducts.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 100), // Bottom padding for navigation
          ),
        ],
      ),
    );
  }

  Widget _buildCreditPointsCard() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.stars,
              color: AppColors.neonGreen,
              size: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Credit Points',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '1,250 Points',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.info_outline,
              color: AppColors.electricBlue,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = category;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.royalPurple : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? AppColors.royalPurple : Colors.white24,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      product.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.white12,
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white30,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                  if (product.isMentorRecommended)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.neonGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Mentor',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (!product.isInStock)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        child: const Center(
                          child: Text(
                            'Out of Stock',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColors.warmOrange,
                          size: 14,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${product.rating}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.reviewCount})',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${product.price.toInt()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
                              '${product.creditPrice} pts',
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}