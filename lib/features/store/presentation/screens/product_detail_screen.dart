import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/product_model.dart';
import '../../data/models/physical_store_model.dart';
import 'nearby_stores_screen.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final Product? product;
  final String? productId;

  const ProductDetailScreen({
    super.key,
    this.product,
    this.productId,
  });


  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  Product get _product {
    if (widget.product != null) return widget.product!;
    // Return a default product if none provided
    return Product(
      id: widget.productId ?? 'unknown',
      name: 'Unknown Product',
      description: 'No description available',
      price: 0.0,
      creditPrice: 0,
      imageUrl: '',
      category: 'general',
      rating: 0.0,
      reviewCount: 0,
    );
  }
  int selectedQuantity = 1;
  bool showFullDescription = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepCharcoal,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.deepCharcoal,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.white),
                onPressed: () {
                  // Add to favorites
                },
              ),
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  // Share product
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product_${_product.id}',
                child: Image.network(
                  _product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.white12,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.white30,
                        size: 80,
                      ),
                    );
                  },
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
                  _buildProductHeader(),
                  const SizedBox(height: 20),
                  _buildPricingCard(),
                  const SizedBox(height: 20),
                  _buildQuantitySelector(),
                  const SizedBox(height: 20),
                  _buildDescription(),
                  const SizedBox(height: 20),
                  if (_product.isMentorRecommended) _buildMentorRecommendation(),
                  const SizedBox(height: 20),
                  _buildNearbyStoresSection(),
                  const SizedBox(height: 20),
                  _buildReviewsSection(),
                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildProductHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _product.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _product.isInStock ? AppColors.neonGreen : AppColors.brightRed,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _product.isInStock ? 'In Stock' : 'Out of Stock',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.star,
              color: AppColors.warmOrange,
              size: 18,
            ),
            const SizedBox(width: 4),
            Text(
              '${_product.rating}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '(${_product.reviewCount} reviews)',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPricingCard() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Price',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '₹${_product.price.toInt()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.neonGreen.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.neonGreen),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.stars,
                    color: AppColors.neonGreen,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_product.creditPrice}',
                    style: TextStyle(
                      color: AppColors.neonGreen,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Credit Points',
                    style: TextStyle(
                      color: AppColors.neonGreen,
                      fontSize: 10,
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

  Widget _buildQuantitySelector() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Text(
              'Quantity',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                IconButton(
                  onPressed: selectedQuantity > 1 ? () {
                    setState(() {
                      selectedQuantity--;
                    });
                  } : null,
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: selectedQuantity > 1 ? AppColors.electricBlue : Colors.white30,
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.royalPurple.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.royalPurple),
                  ),
                  child: Center(
                    child: Text(
                      '$selectedQuantity',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: selectedQuantity < 10 ? () {
                    setState(() {
                      selectedQuantity++;
                    });
                  } : null,
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: selectedQuantity < 10 ? AppColors.electricBlue : Colors.white30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _product.description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
              maxLines: showFullDescription ? null : 3,
              overflow: showFullDescription ? null : TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  showFullDescription = !showFullDescription;
                });
              },
              child: Text(
                showFullDescription ? 'Show less' : 'Read more',
                style: TextStyle(
                  color: AppColors.electricBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMentorRecommendation() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.neonGreen.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: AppColors.neonGreen),
              ),
              child: Icon(
                Icons.verified,
                color: AppColors.neonGreen,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mentor Recommended',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Recommended by ${_product.mentorName}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
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

  Widget _buildNearbyStoresSection() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.electricBlue,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Available in Nearby Stores',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'This product is available in 3 verified stores near you',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            NeonButton(
              text: 'View Nearby Stores',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NearbyStoresScreen(product: _product),
                  ),
                );
              },
              type: NeonButtonType.secondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsSection() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Reviews & Ratings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // Navigate to all reviews
                  },
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: AppColors.electricBlue,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '${_product.rating}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < _product.rating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: AppColors.warmOrange,
                          size: 16,
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Based on ${_product.reviewCount} reviews',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.deepCharcoal,
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: NeonButton(
                text: 'Add to Cart - ₹${(_product.price * selectedQuantity).toInt()}',
                onPressed: _product.isInStock ? () {
                  // Add to cart
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Added to cart successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } : null,
                type: NeonButtonType.primary,
              ),
            ),
            const SizedBox(width: 12),
            NeonButton(
              text: '${_product.creditPrice * selectedQuantity} pts',
              onPressed: _product.isInStock ? () {
                // Buy with credits
                _showCreditPurchaseDialog();
              } : null,
              type: NeonButtonType.accent,
            ),
          ],
        ),
      ),
    );
  }

  void _showCreditPurchaseDialog() {
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
            'Purchase with Credits',
            style: TextStyle(
              color: AppColors.neonGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Use ${_product.creditPrice * selectedQuantity} credit points to purchase this item?',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.stars,
                    color: AppColors.neonGreen,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Available: 1,250 points',
                    style: TextStyle(color: Colors.white),
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
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Purchase successful with credit points!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neonGreen,
                foregroundColor: Colors.black,
              ),
              child: const Text('Purchase'),
            ),
          ],
        );
      },
    );
  }
}