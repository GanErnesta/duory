import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../viewmodels/quiz_viewmodel.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  String _getTitle(String value) {
    switch (value) {
      case 'words_of_affirmation':
        return 'Words of Affirmation';

      case 'acts_of_service':
        return 'Acts of Service';

      case 'quality_time':
        return 'Quality Time';

      case 'physical_touch':
        return 'Physical Touch';

      default:
        return 'Love Language';
    }
  }

  String _getDescription(String value) {
    switch (value) {
      case 'words_of_affirmation':
        return 'Kamu merasa dicintai melalui kata-kata, apresiasi, dan ungkapan kasih sayang.';

      case 'acts_of_service':
        return 'Kamu merasa dicintai ketika pasangan menunjukkan perhatian melalui tindakan.';

      case 'quality_time':
        return 'Kamu merasa dicintai melalui waktu berkualitas dan perhatian penuh dari pasangan.';

      case 'physical_touch':
        return 'Kamu merasa dicintai melalui sentuhan dan kedekatan secara fisik.';

      default:
        return 'Ini adalah love language yang paling dominan dari hasil kuismu.';
    }
  }

  String _getIcon(String value) {
    switch (value) {
      case 'words_of_affirmation':
        return 'assets/images/love_words.svg';

      case 'acts_of_service':
        return 'assets/images/love_service.svg';

      case 'quality_time':
        return 'assets/images/love_time.svg';

      case 'physical_touch':
        return 'assets/images/love_touch.svg';

      default:
        return 'assets/images/love_words.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<QuizViewModel>();

    final result = viewModel.dominantLoveLanguage;

    if (result.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Center(
            child: Text(
              'Hasil kuis belum tersedia.',
              style: AppTextStyles.regular14.copyWith(
                color: const Color(0xFF181818),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            40,
          ),
          child: Column(
            children: [
              Text(
                'Hasil Kuis',
                style: AppTextStyles.bold20.copyWith(
                  color: const Color(0xFF181818),
                ),
              ),

              const SizedBox(height: 40),

              SvgPicture.asset(
                _getIcon(result),
                width: 190,
                height: 190,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 30),

              Text(
                'Love language kamu adalah',
                textAlign: TextAlign.center,
                style: AppTextStyles.regular16.copyWith(
                  color: const Color(0xFF181818),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                _getTitle(result),
                textAlign: TextAlign.center,
                style: AppTextStyles.bold20.copyWith(
                  color: AppColors.red,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                _getDescription(result),
                textAlign: TextAlign.center,
                style: AppTextStyles.regular14.copyWith(
                  color: const Color(0xFF3B332E),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              _buildScoreCard(viewModel),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                      (route) => route.isFirst,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Kembali ke Beranda',
                    style: AppTextStyles.regular16.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard(QuizViewModel viewModel) {
    final result = viewModel.quizResult;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.redLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hasil jawaban kamu',
            style: AppTextStyles.semibold14.copyWith(
              color: const Color(0xFF181818),
            ),
          ),

          const SizedBox(height: 16),

          _buildScoreItem(
            'Words of Affirmation',
            result['words_of_affirmation'] ?? 0,
          ),

          _buildScoreItem(
            'Acts of Service',
            result['acts_of_service'] ?? 0,
          ),

          _buildScoreItem(
            'Quality Time',
            result['quality_time'] ?? 0,
          ),

          _buildScoreItem(
            'Physical Touch',
            result['physical_touch'] ?? 0,
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem(
    String title,
    int score,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.regular12.copyWith(
                color: const Color(0xFF3B332E),
              ),
            ),
          ),
          Text(
            '$score',
            style: AppTextStyles.semibold14.copyWith(
              color: AppColors.red,
            ),
          ),
        ],
      ),
    );
  }
}