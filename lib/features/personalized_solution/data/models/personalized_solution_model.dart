enum SolutionType {
  strengthTraining,
  enduranceImprovement,
  speedDevelopment,
  flexibilityEnhancement,
  balanceCoordination,
  recoveryProtocol,
  nutritionPlan,
  mentalPreparation,
}

class Exercise3D {
  final String id;
  final String name;
  final String description;
  final String modelUrl; // 3D model file URL
  final String animationUrl; // Animation file URL
  final List<String> instructionSteps;
  final int sets;
  final int reps;
  final int duration; // in seconds
  final String difficulty;
  final List<String> targetMuscles;
  final List<String> equipment;

  const Exercise3D({
    required this.id,
    required this.name,
    required this.description,
    required this.modelUrl,
    required this.animationUrl,
    required this.instructionSteps,
    this.sets = 1,
    this.reps = 1,
    this.duration = 0,
    required this.difficulty,
    this.targetMuscles = const [],
    this.equipment = const [],
  });

  factory Exercise3D.fromJson(Map<String, dynamic> json) {
    return Exercise3D(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      modelUrl: json['modelUrl'] ?? '',
      animationUrl: json['animationUrl'] ?? '',
      instructionSteps: List<String>.from(json['instructionSteps'] ?? []),
      sets: json['sets'] ?? 1,
      reps: json['reps'] ?? 1,
      duration: json['duration'] ?? 0,
      difficulty: json['difficulty'] ?? 'beginner',
      targetMuscles: List<String>.from(json['targetMuscles'] ?? []),
      equipment: List<String>.from(json['equipment'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'modelUrl': modelUrl,
      'animationUrl': animationUrl,
      'instructionSteps': instructionSteps,
      'sets': sets,
      'reps': reps,
      'duration': duration,
      'difficulty': difficulty,
      'targetMuscles': targetMuscles,
      'equipment': equipment,
    };
  }
}

class PersonalizedSolution {
  final String id;
  final String testType;
  final double userScore;
  final List<String> recommendations;
  final List<Exercise3D> exercises;
  final NutritionPlan nutritionPlan;
  final RecoveryPlan recoveryPlan;
  final Map<String, double> targetMetrics;
  final int estimatedImprovementTime; // in weeks
  final String difficultyLevel;
  final DateTime createdAt;

  PersonalizedSolution({
    required this.id,
    required this.testType,
    required this.userScore,
    required this.recommendations,
    required this.exercises,
    required this.nutritionPlan,
    required this.recoveryPlan,
    required this.targetMetrics,
    required this.estimatedImprovementTime,
    required this.difficultyLevel,
    required this.createdAt,
  });

  factory PersonalizedSolution.fromJson(Map<String, dynamic> json) {
    return PersonalizedSolution(
      id: json['id'],
      testType: json['test_type'],
      userScore: json['user_score'].toDouble(),
      recommendations: List<String>.from(json['recommendations']),
      exercises: (json['exercises'] as List)
          .map((e) => Exercise3D.fromJson(e))
          .toList(),
      nutritionPlan: NutritionPlan.fromJson(json['nutrition_plan']),
      recoveryPlan: RecoveryPlan.fromJson(json['recovery_plan']),
      targetMetrics: Map<String, double>.from(json['target_metrics']),
      estimatedImprovementTime: json['estimated_improvement_time'],
      difficultyLevel: json['difficulty_level'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'test_type': testType,
      'user_score': userScore,
      'recommendations': recommendations,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'nutrition_plan': nutritionPlan.toJson(),
      'recovery_plan': recoveryPlan.toJson(),
      'target_metrics': targetMetrics,
      'estimated_improvement_time': estimatedImprovementTime,
      'difficulty_level': difficultyLevel,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Exercise {
  final String name;
  final String description;
  final int duration; // in seconds
  final int sets;
  final int reps;
  final int restTime; // in seconds

  Exercise({
    required this.name,
    required this.description,
    required this.duration,
    required this.sets,
    required this.reps,
    required this.restTime,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'],
      description: json['description'],
      duration: json['duration'],
      sets: json['sets'],
      reps: json['reps'],
      restTime: json['rest_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'duration': duration,
      'sets': sets,
      'reps': reps,
      'rest_time': restTime,
    };
  }
}

class NutritionPlan {
  final int dailyCalories;
  final int proteinGrams;
  final int carbGrams;
  final int fatGrams;
  final double waterLiters;
  final List<String> meals;

  NutritionPlan({
    required this.dailyCalories,
    required this.proteinGrams,
    required this.carbGrams,
    required this.fatGrams,
    required this.waterLiters,
    required this.meals,
  });

  factory NutritionPlan.fromJson(Map<String, dynamic> json) {
    return NutritionPlan(
      dailyCalories: json['daily_calories'],
      proteinGrams: json['protein_grams'],
      carbGrams: json['carb_grams'],
      fatGrams: json['fat_grams'],
      waterLiters: json['water_liters'].toDouble(),
      meals: List<String>.from(json['meals']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'daily_calories': dailyCalories,
      'protein_grams': proteinGrams,
      'carb_grams': carbGrams,
      'fat_grams': fatGrams,
      'water_liters': waterLiters,
      'meals': meals,
    };
  }
}

class RecoveryPlan {
  final int sleepHours;
  final int restDays;
  final int stretchingMinutes;
  final String massageFrequency;
  final List<String> activitiesRecommended;

  RecoveryPlan({
    required this.sleepHours,
    required this.restDays,
    required this.stretchingMinutes,
    required this.massageFrequency,
    required this.activitiesRecommended,
  });

  factory RecoveryPlan.fromJson(Map<String, dynamic> json) {
    return RecoveryPlan(
      sleepHours: json['sleep_hours'],
      restDays: json['rest_days'],
      stretchingMinutes: json['stretching_minutes'],
      massageFrequency: json['massage_frequency'],
      activitiesRecommended: List<String>.from(json['activities_recommended']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sleep_hours': sleepHours,
      'rest_days': restDays,
      'stretching_minutes': stretchingMinutes,
      'massage_frequency': massageFrequency,
      'activities_recommended': activitiesRecommended,
    };
  }
}