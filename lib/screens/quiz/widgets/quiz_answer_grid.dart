import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../models/quiz_option_model.dart';

class QuizAnswerGrid extends StatelessWidget {
  final List<QuizOptionModel> options;
  final String? selectedOptionId;
  final ValueChanged<String> onSelected;

  const QuizAnswerGrid({
    super.key,
    required this.options,
    required this.selectedOptionId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: options.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 18,
          childAspectRatio: 0.88,
        ),
        itemBuilder: (context, index) {
          final option = options[index];

          final isSelected =
              selectedOptionId == option.id;

          return GestureDetector(
            onTap: () {
              onSelected(option.id);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.redLight
                    : AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.red,
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(12),
              child: Text(
                option.optionText,
                textAlign: TextAlign.center,
                style: AppTextStyles.regular14.copyWith(
                  color: const Color(0xFF181818),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}