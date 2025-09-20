import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/product_model.dart';
import '../../data/models/physical_store_model.dart';

class NearbyStoresScreen extends ConsumerStatefulWidget {
  final Product product;

  const NearbyStoresScreen({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<NearbyStoresScreen> createState() => _NearbyStoresScreenState();
}

class _NearbyStoresScreenState extends ConsumerState<NearbyStoresScreen> {
  final List<PhysicalStore> mockStores = [
    PhysicalStore(
      id: '1',
      name: 'HealthMax Nutrition',
      address: '123 Fitness Street, Koramangala, Bangalore',
      distance: 1.2,
      rating: 4.8,
      isVerified: true,
      phoneNumber: '+91 9876543210',
      openingHours: '9:00 AM - 9:00 PM',
      latitude: 12.9352,
      longitude: 77.6245,
      hasProduct: true,
      productPrice: 2999.0,
      productStock: 5,
    ),
    PhysicalStore(
      id: '2',
      name: 'Sports Supplement Hub',
      address: '456 Wellness Lane, Indiranagar, Bangalore',
      distance: 2.8,
      rating: 4.6,
      isVerified: true,
      phoneNumber: '+91 9876543211',
      openingHours: '8:00 AM - 10:00 PM',
      latitude: 12.9716,
      longitude: 77.6412,
      hasProduct: true,
      productPrice: 2899.0,
      productStock: 12,
    ),
    PhysicalStore(
      id: '3',
      name: 'FitZone Store',
      address: '789 Athletic Plaza, HSR Layout, Bangalore',
      distance: 4.1,
      rating: 4.7,
      isVerified: true,
      phoneNumber: '+91 9876543212',
      openingHours: '10:00 AM - 8:00 PM',
      latitude: 12.9081,
      longitude: 77.6476,
      hasProduct: false,
      productPrice: 0,
      productStock: 0,
    ),
  ];

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
          'Nearby Stores',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.map,
              color: AppColors.electricBlue,
            ),
            onPressed: () {
              // Open map view
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildProductHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: mockStores.length,
              itemBuilder: (context, index) {
                final store = mockStores[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildStoreCard(store),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.royalPurple.withValues(alpha: 0.2),
            AppColors.electricBlue.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.product.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.white12,
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.white30,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Available in ${mockStores.where((s) => s.hasProduct).length} nearby stores',
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
    );
  }

  Widget _buildStoreCard(PhysicalStore store) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            store.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (store.isVerified) ...[
                            const SizedBox(width: 8),
                            Icon(
                              Icons.verified,
                              color: AppColors.neonGreen,
                              size: 20,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppColors.warmOrange,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${store.rating}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.location_on,
                            color: AppColors.electricBlue,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${store.distance} km away',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (store.hasProduct)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.neonGreen.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.neonGreen),
                    ),
                    child: Text(
                      'In Stock',
                      style: TextStyle(
                        color: AppColors.neonGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.brightRed.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.brightRed),
                    ),
                    child: Text(
                      'Out of Stock',
                      style: TextStyle(
                        color: AppColors.brightRed,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Colors.white54,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    store.address,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: Colors.white54,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  store.openingHours,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            if (store.hasProduct) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.royalPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.royalPurple.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Store Price',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '₹${store.productPrice.toInt()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${store.productStock} units left',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: NeonButton(
                    text: 'Call Store',
                    onPressed: () {
                      // Call store
                    },
                    type: NeonButtonType.secondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NeonButton(
                    text: 'Get Directions',
                    onPressed: () {
                      // Open maps
                    },
                    type: NeonButtonType.primary,
                  ),
                ),
              ],
            ),
            if (store.hasProduct) ...[
              const SizedBox(height: 12),
              NeonButton(
                text: 'Reserve at Store',
                onPressed: () {
                  _showReservationDialog(store);
                },
                type: NeonButtonType.accent,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showReservationDialog(PhysicalStore store) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.deepCharcoal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppColors.electricBlue.withValues(alpha: 0.3)),
          ),
          title: Text(
            'Reserve Product',
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
                'Reserve ${widget.product.name} at ${store.name}?',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'Price: ',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    '₹${store.productPrice.toInt()}',
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
                  const Text(
                    'Pickup within: ',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    '24 hours',
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
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Product reserved successfully! Pickup within 24 hours.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.electricBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reserve'),
            ),
          ],
        );
      },
    );
  }
}