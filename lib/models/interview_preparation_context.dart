import 'interview_enums.dart';
import 'interview_plan.dart';
import 'schedule_item.dart';

class InterviewPreparationContext {
  const InterviewPreparationContext({
    required this.planId,
    required this.targetDate,
    required this.targetLevel,
    required this.targetLanguage,
    required this.totalItemCount,
    required this.completedTopics,
    required this.pendingTopics,
  });

  final String planId;
  final DateTime targetDate;
  final InterviewLevel targetLevel;
  final InterviewLanguage targetLanguage;
  final int totalItemCount;
  final List<InterviewPreparationTopic> completedTopics;
  final List<InterviewPreparationTopic> pendingTopics;

  int get completedItemCount => completedTopics.length;

  String? get primaryFocusTitle {
    if (pendingTopics.isNotEmpty) {
      return pendingTopics.first.title;
    }

    if (completedTopics.isNotEmpty) {
      return completedTopics.last.title;
    }

    return null;
  }

  factory InterviewPreparationContext.fromPlan(InterviewPlan plan) {
    final completedTopics = <InterviewPreparationTopic>[];
    final pendingTopics = <InterviewPreparationTopic>[];

    for (final item in plan.scheduleItems) {
      final topic = InterviewPreparationTopic.fromScheduleItem(item);
      if (item.isCompleted) {
        completedTopics.add(topic);
      } else {
        pendingTopics.add(topic);
      }
    }

    return InterviewPreparationContext(
      planId: plan.id,
      targetDate: plan.targetDate,
      targetLevel: plan.level,
      targetLanguage: plan.language,
      totalItemCount: plan.scheduleItems.length,
      completedTopics: List.unmodifiable(completedTopics),
      pendingTopics: List.unmodifiable(pendingTopics),
    );
  }

  String promptSummary(InterviewLanguage language) {
    final completedSummary = _formatTopics(completedTopics.take(3));
    final pendingSummary = _formatTopics(pendingTopics.take(3));
    final focusTitle = primaryFocusTitle;

    if (language == InterviewLanguage.indonesian) {
      return [
        'Konteks preparation plan aktif.',
        'Target plan: ${targetLevel.label}, tanggal interview ${_formatDate(targetDate)}.',
        'Progress: $completedItemCount/$totalItemCount item selesai.',
        if (completedSummary.isNotEmpty) 'Materi selesai: $completedSummary.',
        if (pendingSummary.isNotEmpty)
          'Fokus belajar berikutnya: $pendingSummary.',
        if (focusTitle != null) 'Fokus sesi saat ini: $focusTitle.',
        'Gunakan konteks ini untuk memilih pertanyaan, follow-up, feedback, dan rekomendasi belajar.',
      ].join(' ');
    }

    return [
      'Active preparation plan context.',
      'Plan target: ${targetLevel.label}, interview date ${_formatDate(targetDate)}.',
      'Progress: $completedItemCount/$totalItemCount items completed.',
      if (completedSummary.isNotEmpty) 'Completed topics: $completedSummary.',
      if (pendingSummary.isNotEmpty) 'Next learning focus: $pendingSummary.',
      if (focusTitle != null) 'Current session focus: $focusTitle.',
      'Use this context to choose questions, follow-ups, feedback, and learning recommendations.',
    ].join(' ');
  }

  String userSummary(InterviewLanguage language) {
    final focusTitle = primaryFocusTitle;
    if (language == InterviewLanguage.indonesian) {
      return focusTitle == null
          ? 'Plan aktif diterapkan: $completedItemCount/$totalItemCount selesai.'
          : 'Plan aktif diterapkan: $completedItemCount/$totalItemCount selesai. Fokus: $focusTitle.';
    }

    return focusTitle == null
        ? 'Active plan applied: $completedItemCount/$totalItemCount completed.'
        : 'Active plan applied: $completedItemCount/$totalItemCount completed. Focus: $focusTitle.';
  }

  static String _formatTopics(Iterable<InterviewPreparationTopic> topics) {
    return topics.map((topic) => topic.promptText).join('; ');
  }

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class InterviewPreparationTopic {
  const InterviewPreparationTopic({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  String get promptText {
    if (description.trim().isEmpty) {
      return title;
    }

    return '$title: $description';
  }

  factory InterviewPreparationTopic.fromScheduleItem(ScheduleItem item) {
    return InterviewPreparationTopic(
      title: item.title,
      description: item.description,
    );
  }
}
