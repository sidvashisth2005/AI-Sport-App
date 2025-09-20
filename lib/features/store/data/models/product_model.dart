class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int creditPrice;
  final String imageUrl;
  final String category;
  final bool isMentorRecommended;
  final String? mentorName;
  final double rating;
  final int reviewCount;
  final bool isInStock;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.creditPrice,
    required this.imageUrl,
    required this.category,
    this.isMentorRecommended = false,
    this.mentorName,
    required this.rating,
    required this.reviewCount,
    this.isInStock = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      creditPrice: json['credit_price'],
      imageUrl: json['image_url'],
      category: json['category'],
      isMentorRecommended: json['is_mentor_recommended'] ?? false,
      mentorName: json['mentor_name'],
      rating: json['rating'].toDouble(),
      reviewCount: json['review_count'],
      isInStock: json['is_in_stock'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'credit_price': creditPrice,
      'image_url': imageUrl,
      'category': category,
      'is_mentor_recommended': isMentorRecommended,
      'mentor_name': mentorName,
      'rating': rating,
      'review_count': reviewCount,
      'is_in_stock': isInStock,
    };
  }
}