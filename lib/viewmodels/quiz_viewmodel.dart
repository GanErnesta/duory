import 'package:flutter/material.dart';

import '../models/quiz_question_model.dart';
import '../services/quiz_service.dart';

class QuizViewModel extends ChangeNotifier {
  final QuizService _quizService;

  QuizViewModel(this._quizService);

  List<QuizQuestionModel> _questions = [];

  bool _isLoading = false;
  bool _isSaving = false;

  String? _errorMessage;

  int _currentQuestionIndex = 0;
  String? _selectedOptionId;

  Map<String, int> _quizResult = {};

  List<QuizQuestionModel> get questions => _questions;

  bool get isLoading => _isLoading;

  bool get isSaving => _isSaving;

  String? get errorMessage => _errorMessage;

  int get currentQuestionIndex => _currentQuestionIndex;

  int get totalQuestions => _questions.length;

  String? get selectedOptionId => _selectedOptionId;

  Map<String, int> get quizResult => _quizResult;

  QuizQuestionModel? get currentQuestion {
    if (_questions.isEmpty) {
      return null;
    }

    if (_currentQuestionIndex >= _questions.length) {
      return null;
    }

    return _questions[_currentQuestionIndex];
  }

  double get progress {
    if (_questions.isEmpty) {
      return 0;
    }

    return (_currentQuestionIndex + 1) / _questions.length;
  }

  bool get isLastQuestion {
    if (_questions.isEmpty) {
      return false;
    }

    return _currentQuestionIndex == _questions.length - 1;
  }

  String get dominantLoveLanguage {
    if (_quizResult.isEmpty) {
      return '';
    }

    return _quizResult.entries
        .reduce(
          (current, next) =>
              next.value > current.value ? next : current,
        )
        .key;
  }

  Future<void> loadQuestions() async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final questions = await _quizService.getQuestions();

      _questions = questions;
      _currentQuestionIndex = 0;
      _selectedOptionId = null;
      _quizResult = {};
    } catch (e) {
      _errorMessage = 'Gagal memuat pertanyaan kuis.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectOption(String optionId) {
    _selectedOptionId = optionId;
    _errorMessage = null;

    notifyListeners();
  }

  Future<bool> checkAnswer() async {
    if (_selectedOptionId == null) {
      _errorMessage = 'Pilih jawaban terlebih dahulu.';
      notifyListeners();
      return false;
    }

    final question = currentQuestion;

    if (question == null) {
      _errorMessage = 'Pertanyaan tidak ditemukan.';
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _errorMessage = null;

    notifyListeners();

    try {
      await _quizService.saveAnswer(
        questionId: question.id,
        optionId: _selectedOptionId!,
      );

      return true;
    } catch (e) {
      _errorMessage = 'Jawaban gagal disimpan.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> loadQuizResult() async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final result = await _quizService.getQuizResult();

      _quizResult = result;

      return true;
    } catch (e) {
      _errorMessage = 'Gagal menghitung hasil kuis.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void nextQuestion() {
    if (isLastQuestion) {
      return;
    }

    _currentQuestionIndex++;
    _selectedOptionId = null;
    _errorMessage = null;

    notifyListeners();
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _selectedOptionId = null;
    _errorMessage = null;
    _quizResult = {};

    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;

    notifyListeners();
  }
}