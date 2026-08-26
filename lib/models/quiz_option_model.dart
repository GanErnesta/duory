class QuizOptionModel {
  final String id;
  final String questionId;
  final String optionText;
  final String loveLanguage;

  const QuizOptionModel({
    required this.id,
    required this.questionId,
    required this.optionText,
    required this.loveLanguage,
  });

  factory QuizOptionModel.fromMap(Map<String, dynamic> map) {
    return QuizOptionModel(
      id: map['id'] as String,
      questionId: map['question_id'] as String,
      optionText: map['option_text'] as String,
      loveLanguage: map['love_language'] as String,
    );
  }
}