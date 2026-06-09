class ScheduleItem {
  const ScheduleItem({
    required this.dayOffset,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.sourceReviewId,
    this.sourceRecommendationId,
  });

  final int dayOffset;
  final String title;
  final String description;
  final bool isCompleted;
  final String? sourceReviewId;
  final String? sourceRecommendationId;

  ScheduleItem copyWith({
    int? dayOffset,
    String? title,
    String? description,
    bool? isCompleted,
    String? sourceReviewId,
    String? sourceRecommendationId,
  }) {
    return ScheduleItem(
      dayOffset: dayOffset ?? this.dayOffset,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      sourceReviewId: sourceReviewId ?? this.sourceReviewId,
      sourceRecommendationId:
          sourceRecommendationId ?? this.sourceRecommendationId,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'dayOffset': dayOffset,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'sourceReviewId': sourceReviewId,
      'sourceRecommendationId': sourceRecommendationId,
    };
  }

  factory ScheduleItem.fromMap(Map<String, dynamic> map) {
    return ScheduleItem(
      dayOffset: map['dayOffset'] as int? ?? 1,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      isCompleted: map['isCompleted'] as bool? ?? false,
      sourceReviewId: map['sourceReviewId'] as String?,
      sourceRecommendationId: map['sourceRecommendationId'] as String?,
    );
  }
}
