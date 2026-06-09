import 'interview_enums.dart';
import 'interview_message.dart';
import 'interview_review.dart';

class InterviewSession {
  const InterviewSession({
    required this.id,
    required this.level,
    required this.stage,
    required this.language,
    required this.startedAt,
    required this.messages,
    this.endedAt,
    this.linkedPlanId,
    this.review,
  });

  final String id;
  final InterviewLevel level;
  final InterviewStage stage;
  final InterviewLanguage language;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String? linkedPlanId;
  final List<InterviewMessage> messages;
  final InterviewReview? review;

  InterviewSession copyWith({
    String? id,
    InterviewLevel? level,
    InterviewStage? stage,
    InterviewLanguage? language,
    DateTime? startedAt,
    DateTime? endedAt,
    String? linkedPlanId,
    List<InterviewMessage>? messages,
    InterviewReview? review,
  }) {
    return InterviewSession(
      id: id ?? this.id,
      level: level ?? this.level,
      stage: stage ?? this.stage,
      language: language ?? this.language,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      linkedPlanId: linkedPlanId ?? this.linkedPlanId,
      messages: messages ?? this.messages,
      review: review ?? this.review,
    );
  }
}
