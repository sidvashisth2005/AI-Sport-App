enum CreditTransactionType {
  earned,
  used,
  bonus,
  refund,
}

class CreditPoints {
  final String id;
  final String userId;
  final int totalPoints;
  final int availablePoints;
  final int usedPoints;
  final List<CreditTransaction> transactions;
  final DateTime lastUpdated;

  CreditPoints({
    required this.id,
    required this.userId,
    required this.totalPoints,
    required this.availablePoints,
    required this.usedPoints,
    required this.transactions,
    required this.lastUpdated,
  });

  factory CreditPoints.fromJson(Map<String, dynamic> json) {
    return CreditPoints(
      id: json['id'],
      userId: json['user_id'],
      totalPoints: json['total_points'],
      availablePoints: json['available_points'],
      usedPoints: json['used_points'],
      transactions: (json['transactions'] as List?)
          ?.map((t) => CreditTransaction.fromJson(t))
          .toList() ?? [],
      lastUpdated: DateTime.parse(json['last_updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'total_points': totalPoints,
      'available_points': availablePoints,
      'used_points': usedPoints,
      'transactions': transactions.map((t) => t.toJson()).toList(),
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}

class CreditTransaction {
  final String id;
  final String userId;
  final int points;
  final CreditTransactionType type;
  final String description;
  final String? relatedId; // Test ID, Product ID, etc.
  final DateTime createdAt;

  CreditTransaction({
    required this.id,
    required this.userId,
    required this.points,
    required this.type,
    required this.description,
    this.relatedId,
    required this.createdAt,
  });

  factory CreditTransaction.fromJson(Map<String, dynamic> json) {
    return CreditTransaction(
      id: json['id'],
      userId: json['user_id'],
      points: json['points'],
      type: CreditTransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => CreditTransactionType.earned,
      ),
      description: json['description'],
      relatedId: json['related_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'points': points,
      'type': type.toString().split('.').last,
      'description': description,
      'related_id': relatedId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}