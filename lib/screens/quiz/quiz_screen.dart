import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../viewmodels/quiz_viewmodel.dart';
import 'quiz_result_screen.dart';
import 'widgets/quiz_answer_grid.dart';
import 'widgets/quiz_check_button.dart';
import 'widgets/quiz_header.dart';
import 'widgets/quiz_progress.dart';
import 'widgets/quiz_question.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<QuizViewModel>();

      if (viewModel.questions.isEmpty) {
        viewModel.loadQuestions();
      }
    });
  }

  Future<void> _checkAnswer() async {
    final viewModel = context.read<QuizViewModel>();

    if (viewModel.selectedOptionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih jawaban terlebih dahulu.'),
        ),
      );
      return;
    }

    final success = await viewModel.checkAnswer();

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewModel.errorMessage ??
                'Jawaban gagal disimpan.',
          ),
        ),
      );

      return;
    }

    if (viewModel.isLastQuestion) {
      await _openResult();
      return;
    }

    viewModel.nextQuestion();
  }

  Future<void> _openResult() async {
    final viewModel = context.read<QuizViewModel>();

    final success = await viewModel.loadQuizResult();

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            viewModel.errorMessage ??
                'Gagal mendapatkan hasil kuis.',
          ),
        ),
      );

      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const QuizResultScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoading) {
          return const Scaffold(
            backgroundColor: AppColors.white,
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.red,
              ),
            ),
          );
        }

        if (viewModel.questions.isEmpty) {
          return _buildEmptyState(viewModel);
        }

        final question = viewModel.currentQuestion;

        if (question == null) {
          return const Scaffold(
            backgroundColor: AppColors.white,
            body: Center(
              child: Text(
                'Pertanyaan tidak ditemukan.',
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Column(
              children: [
                const QuizHeader(),

                const SizedBox(height: 28),

                QuizProgress(
                  progress: viewModel.progress,
                ),

                const SizedBox(height: 26),

                QuizQuestion(
                  questionNumber:
                      viewModel.currentQuestionIndex + 1,
                  question: question.question,
                ),

                const SizedBox(height: 28),

                Expanded(
                  child: QuizAnswerGrid(
                    options: question.options,
                    selectedOptionId:
                        viewModel.selectedOptionId,
                    onSelected: viewModel.selectOption,
                  ),
                ),

                QuizCheckButton(
                  onPressed: viewModel.isSaving
                      ? null
                      : _checkAnswer,
                  isLoading: viewModel.isSaving,
                ),

                const SizedBox(height: 44),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(QuizViewModel viewModel) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.quiz_outlined,
                  size: 60,
                  color: AppColors.red,
                ),

                const SizedBox(height: 20),

                Text(
                  viewModel.errorMessage ??
                      'Belum ada pertanyaan kuis.',
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: 150,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: viewModel.isLoading
                        ? null
                        : () {
                            viewModel.loadQuestions();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Coba lagi'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}