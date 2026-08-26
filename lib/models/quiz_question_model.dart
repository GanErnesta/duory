import 'quiz_option_model.dart';

class QuizQuestionModel {
  final String id;
  final String question;
  final int orderNumber;
  final List<QuizOptionModel> options;

  const QuizQuestionModel({
    required this.id,
    required this.question,
    required this.orderNumber,
    required this.options,
  });

  factory QuizQuestionModel.fromMap(Map<String, dynamic> map) {
    final optionsData = map['quiz_options'] as List<dynamic>? ?? [];

    return QuizQuestionModel(
      id: map['id'] as String,
      question: map['question'] as String,
      orderNumber: map['order_number'] as int,
      options: optionsData
          .map(
            (option) => QuizOptionModel.fromMap(
              Map<String, dynamic>.from(option as Map),
            ),
          )
          .toList(),
    );
  }
}