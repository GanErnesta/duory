import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/quiz_question_model.dart';

class QuizService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<QuizQuestionModel>> getQuestions() async {
    final response = await _supabase
        .from('quiz_questions')
        .select('''
          id,
          question,
          order_number,
          quiz_options (
            id,
            question_id,
            option_text,
            love_language
          )
        ''')
        .order('order_number', ascending: true);

    return (response as List)
        .map(
          (item) => QuizQuestionModel.fromMap(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<void> saveAnswer({
    required String questionId,
    required String optionId,
  }) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login.');
    }

    await _supabase.from('quiz_answers').insert({
      'user_id': user.id,
      'question_id': questionId,
      'option_id': optionId,
    });
  }

  Future<Map<String, int>> getQuizResult() async {
  final user = _supabase.auth.currentUser;

  if (user == null) {
    throw Exception('User belum login.');
  }

  final response = await _supabase
      .from('quiz_answers')
      .select('''
        option_id,
        quiz_options (
          love_language
        )
      ''')
      .eq('user_id', user.id);

  final scores = <String, int>{
    'words_of_affirmation': 0,
    'acts_of_service': 0,
    'quality_time': 0,
    'physical_touch': 0,
  };

  for (final answer in response) {
    final option = answer['quiz_options'];

    if (option == null) {
      continue;
    }

    final loveLanguage = option['love_language'];

    if (loveLanguage != null &&
        scores.containsKey(loveLanguage)) {
      scores[loveLanguage] =
          scores[loveLanguage]! + 1;
    }
  }

  return scores;
}
}