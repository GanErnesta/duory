import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AddScheduleSheet extends StatefulWidget {
  const AddScheduleSheet({super.key});

  @override
  State<AddScheduleSheet> createState() =>
      _AddScheduleSheetState();
}

class _AddScheduleSheetState
    extends State<AddScheduleSheet> {
  int _selectedStatus = 0;
  int _selectedRepeat = 0;
  bool _repeatWeekly = false;

  final List<Map<String, dynamic>> _statuses = [
    {
      'title': 'Kerja/Kuliah',
      'icon': Icons.business_center_outlined,
    },
    {
      'title': 'Focus Mode',
      'icon': Icons.menu_book_outlined,
    },
    {
      'title': 'Perjalanan',
      'icon': Icons.directions_car_outlined,
    },
    {
      'title': 'Free/Santai',
      'icon': Icons.sentiment_satisfied_alt_outlined,
    },
  ];

  final List<String> _repeatOptions = [
    'Hari Kerja',
    'Setiap Hari',
    'Pilih Hari',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD0D0D0),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            const SizedBox(height: 22),

            Center(
              child: Text(
                'Tambah / Ubah Status',
                style: AppTextStyles.bold20.copyWith(
                  color: const Color(0xFF181818),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              '1. Pilih Status',
              style: AppTextStyles.semibold14,
            ),

            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              itemCount: _statuses.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.8,
              ),
              itemBuilder: (context, index) {
                final item = _statuses[index];
                final selected =
                    _selectedStatus == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStatus = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFF2D6CC)
                          : Colors.white,
                      borderRadius:
                          BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? AppColors.red
                            : const Color(0xFFE0E0E0),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          item['icon'],
                          color: AppColors.red,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item['title'],
                          style:
                              AppTextStyles.regular12,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            Text(
              '2. Repeat Rules',
              style: AppTextStyles.semibold14,
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                _repeatOptions.length,
                (index) {
                  final selected =
                      _selectedRepeat == index;

                  return ChoiceChip(
                    label: Text(
                      _repeatOptions[index],
                    ),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        _selectedRepeat = index;
                      });
                    },
                    selectedColor:
                        const Color(0xFFF2D6CC),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Ulangi Setiap Minggu',
                style: AppTextStyles.regular14,
              ),
              subtitle: Text(
                'Jadwal otomatis digunakan setiap minggu',
                style: AppTextStyles.regular12.copyWith(
                  color: const Color(0xFF777777),
                ),
              ),
              value: _repeatWeekly,
              activeColor: AppColors.red,
              onChanged: (value) {
                setState(() {
                  _repeatWeekly = value;
                });
              },
            ),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Simpan Status',
                  style: AppTextStyles.regular16.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}