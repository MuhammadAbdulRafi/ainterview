import '../models/interview_enums.dart';
import '../models/interview_message.dart';
import '../models/interview_preparation_context.dart';
import '../models/interview_review.dart';
import '../models/review_recommendation.dart';

abstract class AiInterviewService {
  Future<String> startInterview({
    required InterviewLevel level,
    required InterviewStage stage,
    required InterviewLanguage language,
    InterviewPreparationContext? preparationContext,
  });

  Future<String> sendMessage({
    required InterviewLevel level,
    required InterviewStage stage,
    required InterviewLanguage language,
    required List<InterviewMessage> messages,
    InterviewPreparationContext? preparationContext,
  });

  Future<InterviewReview> reviewInterview({
    required InterviewLevel level,
    required InterviewStage stage,
    required InterviewLanguage language,
    required List<InterviewMessage> messages,
    InterviewPreparationContext? preparationContext,
  });
}

class MockAiInterviewService implements AiInterviewService {
  @override
  Future<String> startInterview({
    required InterviewLevel level,
    required InterviewStage stage,
    required InterviewLanguage language,
    InterviewPreparationContext? preparationContext,
  }) async {
    final preparationOpening = _preparationOpening(
      preparationContext,
      language,
    );
    if (language == InterviewLanguage.indonesian) {
      return 'Kita mulai sesi ${level.label} ${stage.label}.$preparationOpening ${_firstQuestion(level, stage, language)}';
    }

    return 'Welcome to the ${level.label} ${stage.label} interview.$preparationOpening ${_firstQuestion(level, stage, language)}';
  }

  @override
  Future<String> sendMessage({
    required InterviewLevel level,
    required InterviewStage stage,
    required InterviewLanguage language,
    required List<InterviewMessage> messages,
    InterviewPreparationContext? preparationContext,
  }) async {
    final lastAnswer = messages.last.text;
    final preparationFollowUp = _preparationFollowUp(
      preparationContext,
      language,
    );
    if (language == InterviewLanguage.indonesian) {
      return 'Terima kasih.$preparationFollowUp Untuk konteks ${level.label} ${stage.label}, jelaskan lebih spesifik: ${_followUp(level, stage, lastAnswer, language)}';
    }

    return 'Thanks.$preparationFollowUp For a ${level.label} ${stage.label} interview, go one level deeper: ${_followUp(level, stage, lastAnswer, language)}';
  }

  @override
  Future<InterviewReview> reviewInterview({
    required InterviewLevel level,
    required InterviewStage stage,
    required InterviewLanguage language,
    required List<InterviewMessage> messages,
    InterviewPreparationContext? preparationContext,
  }) async {
    final answeredCount = messages
        .where((message) => message.sender == InterviewMessageSender.user)
        .length;

    if (language == InterviewLanguage.indonesian) {
      return InterviewReview(
        id: _reviewId(),
        level: level,
        stage: stage,
        language: language,
        createdAt: DateTime.now().toUtc(),
        summary:
            'Sesi ${level.label} ${stage.label} selesai dengan $answeredCount jawaban. Kamu sudah memberi konteks awal yang bisa dikembangkan.',
        communicationFeedback:
            'Jawaban sudah cukup jelas. Tambahkan struktur situasi, aksi, dan hasil agar lebih meyakinkan.',
        technicalFeedback: _technicalReview(level, stage, language),
        improvementAreas: _improvementAreas(
          level,
          stage,
          language,
          preparationContext,
        ),
        recommendations: _recommendations(
          level,
          stage,
          language,
          preparationContext,
        ),
      );
    }

    return InterviewReview(
      id: _reviewId(),
      level: level,
      stage: stage,
      language: language,
      createdAt: DateTime.now().toUtc(),
      summary:
          '${level.label} ${stage.label} session completed with $answeredCount answer(s). You gave a useful baseline and can now sharpen the evidence.',
      communicationFeedback:
          'Your answer is understandable. Use a clearer situation-action-result structure for stronger interview signal.',
      technicalFeedback: _technicalReview(level, stage, language),
      improvementAreas: _improvementAreas(
        level,
        stage,
        language,
        preparationContext,
      ),
      recommendations: _recommendations(
        level,
        stage,
        language,
        preparationContext,
      ),
    );
  }

  String _preparationOpening(
    InterviewPreparationContext? preparationContext,
    InterviewLanguage language,
  ) {
    if (preparationContext == null) {
      return '';
    }

    return ' ${preparationContext.promptSummary(language)}';
  }

  String _preparationFollowUp(
    InterviewPreparationContext? preparationContext,
    InterviewLanguage language,
  ) {
    final focusTitle = preparationContext?.primaryFocusTitle;
    if (focusTitle == null) {
      return '';
    }

    if (language == InterviewLanguage.indonesian) {
      return ' Kita hubungkan dengan fokus plan: $focusTitle.';
    }

    return ' Connect this with the active plan focus: $focusTitle.';
  }

  String _firstQuestion(
    InterviewLevel level,
    InterviewStage stage,
    InterviewLanguage language,
  ) {
    if (language == InterviewLanguage.indonesian) {
      return switch (stage) {
        InterviewStage.hr =>
          'Ceritakan tentang dirimu dan pengalaman yang paling relevan untuk posisi mobile programmer.',
        InterviewStage.technical => switch (level) {
          InterviewLevel.intern =>
            'Jelaskan konsep OOP yang paling sering kamu pakai saat membuat aplikasi mobile.',
          InterviewLevel.junior =>
            'Bagaimana kamu mengelola state dan error saat memanggil API di Flutter?',
          InterviewLevel.senior =>
            'Bagaimana kamu merancang architecture aplikasi mobile yang scalable dan mudah dites?',
        },
      };
    }

    return switch (stage) {
      InterviewStage.hr =>
        'Tell me about yourself and the most relevant experience you bring to a mobile programmer role.',
      InterviewStage.technical => switch (level) {
        InterviewLevel.intern =>
          'Explain an OOP concept you often use when building mobile apps.',
        InterviewLevel.junior =>
          'How do you manage state and API errors in a Flutter app?',
        InterviewLevel.senior =>
          'How would you design a scalable and testable mobile app architecture?',
      },
    };
  }

  String _followUp(
    InterviewLevel level,
    InterviewStage stage,
    String lastAnswer,
    InterviewLanguage language,
  ) {
    final trimmedAnswer = lastAnswer.trim();
    final answerHint = trimmedAnswer.isEmpty
        ? ''
        : ' Ambil contoh dari jawabanmu: "$trimmedAnswer".';

    if (language == InterviewLanguage.indonesian) {
      return switch (stage) {
        InterviewStage.hr =>
          'apa tantangan terbesarnya, tindakanmu, dan hasilnya?$answerHint',
        InterviewStage.technical => switch (level) {
          InterviewLevel.intern =>
            'bagaimana kamu memastikan konsep dasarnya benar dan mudah dipahami?$answerHint',
          InterviewLevel.junior =>
            'bagaimana kamu menangani failure case, loading state, dan retry?$answerHint',
          InterviewLevel.senior =>
            'apa trade-off architecture, testing strategy, dan risiko security-nya?$answerHint',
        },
      };
    }

    return switch (stage) {
      InterviewStage.hr =>
        'what was the hardest part, what did you do, and what changed as a result?',
      InterviewStage.technical => switch (level) {
        InterviewLevel.intern =>
          'how would you prove the fundamental concept is correct and easy to explain?',
        InterviewLevel.junior =>
          'how would you handle failure cases, loading state, and retry behavior?',
        InterviewLevel.senior =>
          'what are the architecture trade-offs, testing strategy, and security risks?',
      },
    };
  }

  String _technicalReview(
    InterviewLevel level,
    InterviewStage stage,
    InterviewLanguage language,
  ) {
    if (stage == InterviewStage.hr) {
      return language == InterviewLanguage.indonesian
          ? 'Belum banyak sinyal teknis karena sesi ini berfokus pada HR.'
          : 'Technical signal is limited because this was an HR-focused session.';
    }

    return switch (level) {
      InterviewLevel.intern =>
        language == InterviewLanguage.indonesian
            ? 'Perkuat penjelasan fundamental programming dan OOP.'
            : 'Strengthen programming fundamentals and OOP explanations.',
      InterviewLevel.junior =>
        language == InterviewLanguage.indonesian
            ? 'Perkuat detail state management, API failure handling, dan debugging.'
            : 'Strengthen state management, API failure handling, and debugging details.',
      InterviewLevel.senior =>
        language == InterviewLanguage.indonesian
            ? 'Perkuat architecture reasoning, testing strategy, security, dan performance trade-off.'
            : 'Your architecture reasoning is a good start; add testing strategy, security, and performance trade-offs.',
    };
  }

  List<String> _improvementAreas(
    InterviewLevel level,
    InterviewStage stage,
    InterviewLanguage language,
    InterviewPreparationContext? preparationContext,
  ) {
    final focusTitle = preparationContext?.primaryFocusTitle;
    final baseAreas = language == InterviewLanguage.indonesian
        ? [
            'Perjelas contoh project yang paling relevan.',
            'Tambahkan alasan teknis di balik keputusan yang kamu ambil.',
          ]
        : [
            'Anchor answers in one concrete project example.',
            'Explain trade-offs and measurable impact more explicitly.',
          ];

    if (focusTitle == null) {
      return baseAreas;
    }

    return [
      ...baseAreas,
      language == InterviewLanguage.indonesian
          ? 'Hubungkan jawaban dengan fokus preparation: $focusTitle.'
          : 'Connect answers to the active preparation focus: $focusTitle.',
    ];
  }

  String _reviewId() {
    return 'review_${DateTime.now().toUtc().microsecondsSinceEpoch}';
  }

  List<ReviewRecommendation> _recommendations(
    InterviewLevel level,
    InterviewStage stage,
    InterviewLanguage language,
    InterviewPreparationContext? preparationContext,
  ) {
    final baseRecommendations = language == InterviewLanguage.indonesian
        ? [
            ReviewRecommendation(
              id: 'recommendation_1',
              title: stage == InterviewStage.hr
                  ? 'Review Recommendation: HR Storytelling Drill'
                  : 'Review Recommendation: Technical Deep Dive',
              description: stage == InterviewStage.hr
                  ? 'Latih satu jawaban STAR yang menjelaskan situasi, aksi, hasil, dan refleksi.'
                  : 'Latih satu skenario teknis sesuai level dengan trade-off, failure case, dan testing.',
              level: level,
              stage: stage,
            ),
            ReviewRecommendation(
              id: 'recommendation_2',
              title: 'Review Recommendation: Project Evidence',
              description:
                  'Siapkan contoh project yang menunjukkan keputusan, dampak, dan pembelajaran.',
              level: level,
              stage: stage,
            ),
          ]
        : [
            ReviewRecommendation(
              id: 'recommendation_1',
              title: stage == InterviewStage.hr
                  ? 'Review Recommendation: HR Storytelling Drill'
                  : 'Review Recommendation: Technical Deep Dive',
              description: stage == InterviewStage.hr
                  ? 'Practice one STAR answer with situation, action, result, and reflection.'
                  : 'Practice one level-specific technical scenario with trade-offs, failure cases, and testing.',
              level: level,
              stage: stage,
            ),
            ReviewRecommendation(
              id: 'recommendation_2',
              title: 'Review Recommendation: Project Evidence',
              description:
                  'Prepare one project example that shows decisions, impact, and learning.',
              level: level,
              stage: stage,
            ),
          ];

    final planRecommendations = _planRecommendations(
      level,
      stage,
      language,
      preparationContext,
    );

    return [...baseRecommendations, ...planRecommendations];
  }

  List<ReviewRecommendation> _planRecommendations(
    InterviewLevel level,
    InterviewStage stage,
    InterviewLanguage language,
    InterviewPreparationContext? preparationContext,
  ) {
    if (preparationContext == null) {
      return const [];
    }

    final topics = preparationContext.pendingTopics.take(2).toList();
    return [
      for (var index = 0; index < topics.length; index++)
        ReviewRecommendation(
          id: 'plan_focus_${index + 1}',
          title: language == InterviewLanguage.indonesian
              ? 'Plan Focus: ${topics[index].title}'
              : 'Plan Focus: ${topics[index].title}',
          description: topics[index].description,
          level: level,
          stage: stage,
          linkedPlanId: preparationContext.planId,
          linkedScheduleItemIndex: index,
        ),
    ];
  }
}

class MissingOpenRouterApiKeyAiInterviewService implements AiInterviewService {
  static const _message =
      'OpenRouter API key is not configured. Run flutter run --dart-define=OPENROUTER_API_KEY=your_openrouter_key.';

  @override
  Future<String> startInterview({
    required InterviewLevel level,
    required InterviewStage stage,
    required InterviewLanguage language,
    InterviewPreparationContext? preparationContext,
  }) async {
    throw StateError(_message);
  }

  @override
  Future<String> sendMessage({
    required InterviewLevel level,
    required InterviewStage stage,
    required InterviewLanguage language,
    required List<InterviewMessage> messages,
    InterviewPreparationContext? preparationContext,
  }) async {
    throw StateError(_message);
  }

  @override
  Future<InterviewReview> reviewInterview({
    required InterviewLevel level,
    required InterviewStage stage,
    required InterviewLanguage language,
    required List<InterviewMessage> messages,
    InterviewPreparationContext? preparationContext,
  }) async {
    throw StateError(_message);
  }
}
