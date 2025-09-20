import 'package:equatable/equatable.dart';

class TestModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String type;
  final String category;
  final Duration duration;
  final String instructions;
  final List<String> requirements;
  final Map<String, dynamic> calibrationSettings;
  final Map<String, dynamic> scoringCriteria;
  final String? thumbnailUrl;
  final String? videoUrl;
  final bool isActive;
  final int difficultyLevel;
  final List<String> tags;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const TestModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.category,
    required this.duration,
    required this.instructions,
    required this.requirements,
    required this.calibrationSettings,
    required this.scoringCriteria,
    this.thumbnailUrl,
    this.videoUrl,
    this.isActive = true,
    this.difficultyLevel = 1,
    this.tags = const [],
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      category: json['category'] as String,
      duration: Duration(seconds: json['duration_seconds'] as int),
      instructions: json['instructions'] as String,
      requirements: List<String>.from(json['requirements'] as List),
      calibrationSettings: json['calibration_settings'] as Map<String, dynamic>,
      scoringCriteria: json['scoring_criteria'] as Map<String, dynamic>,
      thumbnailUrl: json['thumbnail_url'] as String?,
      videoUrl: json['video_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      difficultyLevel: json['difficulty_level'] as int? ?? 1,
      tags: List<String>.from(json['tags'] as List? ?? []),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'category': category,
      'duration_seconds': duration.inSeconds,
      'instructions': instructions,
      'requirements': requirements,
      'calibration_settings': calibrationSettings,
      'scoring_criteria': scoringCriteria,
      'thumbnail_url': thumbnailUrl,
      'video_url': videoUrl,
      'is_active': isActive,
      'difficulty_level': difficultyLevel,
      'tags': tags,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
  
  TestModel copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    String? category,
    Duration? duration,
    String? instructions,
    List<String>? requirements,
    Map<String, dynamic>? calibrationSettings,
    Map<String, dynamic>? scoringCriteria,
    String? thumbnailUrl,
    String? videoUrl,
    bool? isActive,
    int? difficultyLevel,
    List<String>? tags,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TestModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      instructions: instructions ?? this.instructions,
      requirements: requirements ?? this.requirements,
      calibrationSettings: calibrationSettings ?? this.calibrationSettings,
      scoringCriteria: scoringCriteria ?? this.scoringCriteria,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      isActive: isActive ?? this.isActive,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [
        id,
        name,
        description,
        type,
        category,
        duration,
        instructions,
        requirements,
        calibrationSettings,
        scoringCriteria,
        thumbnailUrl,
        videoUrl,
        isActive,
        difficultyLevel,
        tags,
        metadata,
        createdAt,
        updatedAt,
      ];
  
  // Computed properties
  String get formattedDuration {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
  
  String get difficultyText {
    switch (difficultyLevel) {
      case 1:
        return 'Beginner';
      case 2:
        return 'Intermediate';
      case 3:
        return 'Advanced';
      case 4:
        return 'Expert';
      case 5:
        return 'Master';
      default:
        return 'Unknown';
    }
  }
  
  bool get requiresEquipment => requirements.isNotEmpty;
  
  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;
  
  bool get hasThumbnail => thumbnailUrl != null && thumbnailUrl!.isNotEmpty;
}

// Test Categories
enum TestCategory {
  strength,
  cardio,
  agility,
  flexibility,
  coordination,
  balance,
  speed,
  endurance,
}

extension TestCategoryExt on TestCategory {
  String get displayName {
    switch (this) {
      case TestCategory.strength:
        return 'Strength';
      case TestCategory.cardio:
        return 'Cardio';
      case TestCategory.agility:
        return 'Agility';
      case TestCategory.flexibility:
        return 'Flexibility';
      case TestCategory.coordination:
        return 'Coordination';
      case TestCategory.balance:
        return 'Balance';
      case TestCategory.speed:
        return 'Speed';
      case TestCategory.endurance:
        return 'Endurance';
    }
  }
  
  String get iconName {
    switch (this) {
      case TestCategory.strength:
        return 'strength';
      case TestCategory.cardio:
        return 'cardio';
      case TestCategory.agility:
        return 'agility';
      case TestCategory.flexibility:
        return 'flexibility';
      case TestCategory.coordination:
        return 'coordination';
      case TestCategory.balance:
        return 'balance';
      case TestCategory.speed:
        return 'speed';
      case TestCategory.endurance:
        return 'endurance';
    }
  }
}

// Test Types
enum TestType {
  pushups,
  situps,
  plank,
  sprint,
  jumpingJacks,
  burpees,
  squats,
  lunges,
  flexibility,
  balance,
}

extension TestTypeExt on TestType {
  String get displayName {
    switch (this) {
      case TestType.pushups:
        return 'Push-ups';
      case TestType.situps:
        return 'Sit-ups';
      case TestType.plank:
        return 'Plank Hold';
      case TestType.sprint:
        return 'Sprint Test';
      case TestType.jumpingJacks:
        return 'Jumping Jacks';
      case TestType.burpees:
        return 'Burpees';
      case TestType.squats:
        return 'Squats';
      case TestType.lunges:
        return 'Lunges';
      case TestType.flexibility:
        return 'Flexibility Test';
      case TestType.balance:
        return 'Balance Test';
    }
  }
  
  TestCategory get category {
    switch (this) {
      case TestType.pushups:
      case TestType.situps:
      case TestType.squats:
      case TestType.lunges:
        return TestCategory.strength;
      case TestType.plank:
        return TestCategory.endurance;
      case TestType.sprint:
        return TestCategory.speed;
      case TestType.jumpingJacks:
      case TestType.burpees:
        return TestCategory.cardio;
      case TestType.flexibility:
        return TestCategory.flexibility;
      case TestType.balance:
        return TestCategory.balance;
    }
  }
}