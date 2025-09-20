import 'package:equatable/equatable.dart';
import 'test_model.dart';

class TestResultModel extends Equatable {
  final String id;
  final String userId;
  final String testId;
  final TestModel? test; // Populated when joined with tests table
  final double score;
  final Map<String, dynamic> metrics;
  final Map<String, dynamic> rawData;
  final Duration? duration;
  final String status;
  final String? videoUrl;
  final List<String>? imageUrls;
  final String? notes;
  final Map<String, dynamic>? aiAnalysis;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const TestResultModel({
    required this.id,
    required this.userId,
    required this.testId,
    this.test,
    required this.score,
    required this.metrics,
    required this.rawData,
    this.duration,
    required this.status,
    this.videoUrl,
    this.imageUrls,
    this.notes,
    this.aiAnalysis,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory TestResultModel.fromJson(Map<String, dynamic> json) {
    return TestResultModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      testId: json['test_id'] as String,
      test: json['tests'] != null ? TestModel.fromJson(json['tests']) : null,
      score: (json['score'] as num).toDouble(),
      metrics: json['metrics'] as Map<String, dynamic>,
      rawData: json['raw_data'] as Map<String, dynamic>,
      duration: json['duration_seconds'] != null 
          ? Duration(seconds: json['duration_seconds'] as int)
          : null,
      status: json['status'] as String,
      videoUrl: json['video_url'] as String?,
      imageUrls: json['image_urls'] != null 
          ? List<String>.from(json['image_urls'] as List)
          : null,
      notes: json['notes'] as String?,
      aiAnalysis: json['ai_analysis'] as Map<String, dynamic>?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'test_id': testId,
      'score': score,
      'metrics': metrics,
      'raw_data': rawData,
      'duration_seconds': duration?.inSeconds,
      'status': status,
      'video_url': videoUrl,
      'image_urls': imageUrls,
      'notes': notes,
      'ai_analysis': aiAnalysis,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
  
  TestResultModel copyWith({
    String? id,
    String? userId,
    String? testId,
    TestModel? test,
    double? score,
    Map<String, dynamic>? metrics,
    Map<String, dynamic>? rawData,
    Duration? duration,
    String? status,
    String? videoUrl,
    List<String>? imageUrls,
    String? notes,
    Map<String, dynamic>? aiAnalysis,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TestResultModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      testId: testId ?? this.testId,
      test: test ?? this.test,
      score: score ?? this.score,
      metrics: metrics ?? this.metrics,
      rawData: rawData ?? this.rawData,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      videoUrl: videoUrl ?? this.videoUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      notes: notes ?? this.notes,
      aiAnalysis: aiAnalysis ?? this.aiAnalysis,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [
        id,
        userId,
        testId,
        test,
        score,
        metrics,
        rawData,
        duration,
        status,
        videoUrl,
        imageUrls,
        notes,
        aiAnalysis,
        metadata,
        createdAt,
        updatedAt,
      ];
  
  // Computed properties
  String get testName => test?.name ?? 'Unknown Test';
  
  String get testType => test?.type ?? 'unknown';
  
  String get formattedScore {
    return score.toStringAsFixed(1);
  }
  
  String get formattedDuration {
    if (duration == null) return 'N/A';
    final minutes = duration!.inMinutes;
    final seconds = duration!.inSeconds % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
  
  String get statusText {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Completed';
      case 'in_progress':
        return 'In Progress';
      case 'failed':
        return 'Failed';
      case 'cancelled':
        return 'Cancelled';
      case 'pending':
        return 'Pending';
      default:
        return 'Unknown';
    }
  }
  
  bool get isCompleted => status.toLowerCase() == 'completed';
  
  bool get isInProgress => status.toLowerCase() == 'in_progress';
  
  bool get isFailed => status.toLowerCase() == 'failed';
  
  bool get hasVideo => videoUrl != null && videoUrl!.isNotEmpty;
  
  bool get hasImages => imageUrls != null && imageUrls!.isNotEmpty;
  
  bool get hasAiAnalysis => aiAnalysis != null && aiAnalysis!.isNotEmpty;
  
  String get performanceGrade {
    if (score >= 90) return 'A+';
    if (score >= 85) return 'A';
    if (score >= 80) return 'A-';
    if (score >= 75) return 'B+';
    if (score >= 70) return 'B';
    if (score >= 65) return 'B-';
    if (score >= 60) return 'C+';
    if (score >= 55) return 'C';
    if (score >= 50) return 'C-';
    if (score >= 45) return 'D+';
    if (score >= 40) return 'D';
    return 'F';
  }
  
  String get performanceText {
    if (score >= 90) return 'Exceptional';
    if (score >= 80) return 'Excellent';
    if (score >= 70) return 'Good';
    if (score >= 60) return 'Average';
    if (score >= 50) return 'Below Average';
    return 'Poor';
  }
  
  // Get specific metric values
  int? get repetitions {
    return metrics['repetitions'] as int?;
  }
  
  double? get accuracy {
    return (metrics['accuracy'] as num?)?.toDouble();
  }
  
  double? get consistency {
    return (metrics['consistency'] as num?)?.toDouble();
  }
  
  double? get power {
    return (metrics['power'] as num?)?.toDouble();
  }
  
  double? get speed {
    return (metrics['speed'] as num?)?.toDouble();
  }
  
  double? get form {
    return (metrics['form'] as num?)?.toDouble();
  }
  
  // AI Analysis helpers
  String? get aiSummary {
    return aiAnalysis?['summary'] as String?;
  }
  
  List<String>? get aiRecommendations {
    final recs = aiAnalysis?['recommendations'];
    return recs != null ? List<String>.from(recs as List) : null;
  }
  
  Map<String, dynamic>? get aiTechnicalAnalysis {
    return aiAnalysis?['technical_analysis'] as Map<String, dynamic>?;
  }
  
  double? get aiConfidenceScore {
    return (aiAnalysis?['confidence_score'] as num?)?.toDouble();
  }
}

// Test Result Status
enum TestResultStatus {
  pending,
  inProgress,
  completed,
  failed,
  cancelled,
}

extension TestResultStatusExt on TestResultStatus {
  String get value {
    switch (this) {
      case TestResultStatus.pending:
        return 'pending';
      case TestResultStatus.inProgress:
        return 'in_progress';
      case TestResultStatus.completed:
        return 'completed';
      case TestResultStatus.failed:
        return 'failed';
      case TestResultStatus.cancelled:
        return 'cancelled';
    }
  }
  
  String get displayName {
    switch (this) {
      case TestResultStatus.pending:
        return 'Pending';
      case TestResultStatus.inProgress:
        return 'In Progress';
      case TestResultStatus.completed:
        return 'Completed';
      case TestResultStatus.failed:
        return 'Failed';
      case TestResultStatus.cancelled:
        return 'Cancelled';
    }
  }
}