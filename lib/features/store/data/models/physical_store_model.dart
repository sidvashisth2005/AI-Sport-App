class PhysicalStore {
  final String id;
  final String name;
  final String address;
  final double distance; // in kilometers
  final double rating;
  final bool isVerified;
  final String phoneNumber;
  final String openingHours;
  final double latitude;
  final double longitude;
  final bool hasProduct;
  final double productPrice;
  final int productStock;

  PhysicalStore({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    required this.rating,
    required this.isVerified,
    required this.phoneNumber,
    required this.openingHours,
    required this.latitude,
    required this.longitude,
    required this.hasProduct,
    required this.productPrice,
    required this.productStock,
  });

  factory PhysicalStore.fromJson(Map<String, dynamic> json) {
    return PhysicalStore(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      distance: json['distance'].toDouble(),
      rating: json['rating'].toDouble(),
      isVerified: json['is_verified'] ?? false,
      phoneNumber: json['phone_number'],
      openingHours: json['opening_hours'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      hasProduct: json['has_product'] ?? false,
      productPrice: json['product_price']?.toDouble() ?? 0.0,
      productStock: json['product_stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'distance': distance,
      'rating': rating,
      'is_verified': isVerified,
      'phone_number': phoneNumber,
      'opening_hours': openingHours,
      'latitude': latitude,
      'longitude': longitude,
      'has_product': hasProduct,
      'product_price': productPrice,
      'product_stock': productStock,
    };
  }
}