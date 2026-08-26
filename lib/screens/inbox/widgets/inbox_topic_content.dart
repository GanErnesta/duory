import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class InboxTopicContent extends StatefulWidget {
  const InboxTopicContent({super.key});

  @override
  State<InboxTopicContent> createState() => _InboxTopicContentState();
}

class _InboxTopicContentState extends State<InboxTopicContent> {
  int _selectedFilter = 0;

  final List<String> filters = [
    'Semua',
    'Belum dibahas',
    'Sudah dibahas',
  ];

  final List<Map<String, String>> topics = [
    {
      'title': 'Muncak ke buthak',
      'status': 'Belum dibahas',
    },
    {
      'title': 'Cobain dessert',
      'status': 'Belum dibahas',
    },
    {
      'title': 'Jalan-jalan ke Surabaya',
      'status': 'Sudah dibahas',
    },
  ];

  List<Map<String, String>> get filteredTopics {
    if (_selectedFilter == 0) {
      return topics;
    }

    if (_selectedFilter == 1) {
      return topics
          .where((topic) => topic['status'] == 'Belum dibahas')
          .toList();
    }

    return topics
        .where((topic) => topic['status'] == 'Sudah dibahas')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        24,
      ),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(
              begin: 0.85,
              end: 1,
            ),
            duration: const Duration(milliseconds: 650),
            curve: Curves.easeOutBack,
            builder: (
              context,
              scale,
              child,
            ) {
              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: Image.asset(
              'assets/images/box_open.png',
              width: 250,
              height: 210,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 18),

          _buildFilter(),

          const SizedBox(height: 18),

          _buildTopics(),
        ],
      ),
    );
  }

  Widget _buildFilter() {
    return SizedBox(
      height: 36,
      child: Row(
        children: List.generate(
          filters.length,
          (index) {
            final selected = _selectedFilter == index;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index != filters.length - 1 ? 8 : 0,
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.red
                          : AppColors.white,
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: AppColors.red,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      filters[index],
                      style: AppTextStyles.regular12.copyWith(
                        color: selected
                            ? AppColors.white
                            : AppColors.red,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopics() {
    return Column(
      children: filteredTopics.map((topic) {
        final isDone = topic['status'] == 'Sudah dibahas';

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 46,
              vertical: 15,
            ),
            decoration: BoxDecoration(
              color: isDone
                  ? AppColors.redLight
                  : AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.red,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic['title']!,
                  style: AppTextStyles.semibold14.copyWith(
                    color: const Color(0xFF181818),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  topic['status']!,
                  style: AppTextStyles.regular12.copyWith(
                    color: const Color(0xFF181818),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}