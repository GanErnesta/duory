import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AddScheduleScreen extends StatefulWidget {
  const AddScheduleScreen({super.key});

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  int _selectedStatus = 0;
  int _selectedRepeat = 0;
  bool _repeatWeekly = false;

  TimeOfDay _startTime = const TimeOfDay(
    hour: 9,
    minute: 0,
  );

  TimeOfDay _endTime = const TimeOfDay(
    hour: 19,
    minute: 0,
  );

  final List<String> _statuses = [
    'Kerja/kuliah',
    'Rapat/ focus mode',
    'Perjalanan',
    'Free',
  ];

  final List<String> _repeatOptions = [
    'Hari Kerja',
    'Setiap Hari',
    'Pilih Hari Spesifik',
  ];

  final List<String> _days = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];

  final Set<int> _selectedDays = {};

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  Future<void> _selectStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );

    if (picked == null) return;

    setState(() {
      _startTime = picked;
    });
  }

  Future<void> _selectEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );

    if (picked == null) return;

    setState(() {
      _endTime = picked;
    });
  }

  Future<void> _showSpecificDaysDialog() async {
    final tempSelectedDays = Set<int>.from(
      _selectedDays,
    );

    bool tempRepeatWeekly = _repeatWeekly;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom:
                    MediaQuery.of(context).padding.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(sheetContext);
                    },
                    child: const SizedBox(
                      width: 32,
                      height: 32,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.close,
                          size: 24,
                          color: Color(0xFF181818),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Pilih hari spesifik',
                    style: AppTextStyles.bold18.copyWith(
                      color: const Color(0xFF181818),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: List.generate(
                      _days.length,
                      (index) {
                        final selected =
                            tempSelectedDays.contains(index);

                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right:
                                  index == _days.length - 1
                                      ? 0
                                      : 7,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  if (selected) {
                                    tempSelectedDays.remove(
                                      index,
                                    );
                                  } else {
                                    tempSelectedDays.add(
                                      index,
                                    );
                                  }
                                });
                              },
                              child: Container(
                                height: 54,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? const Color(0xFFF2D6CC)
                                      : Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(4),
                                  border: Border.all(
                                    color: AppColors.red,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  _days[index],
                                  style:
                                      AppTextStyles.regular12.copyWith(
                                    color:
                                        const Color(0xFF181818),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () {
                      setModalState(() {
                        tempRepeatWeekly =
                            !tempRepeatWeekly;
                      });
                    },
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          margin: const EdgeInsets.only(
                            top: 1,
                          ),
                          decoration: BoxDecoration(
                            color: tempRepeatWeekly
                                ? AppColors.red
                                : Colors.white,
                            borderRadius:
                                BorderRadius.circular(2),
                            border: Border.all(
                              color: tempRepeatWeekly
                                  ? AppColors.red
                                  : const Color(0xFFE0A58E),
                            ),
                          ),
                          child: tempRepeatWeekly
                              ? const Icon(
                                  Icons.check,
                                  size: 15,
                                  color: Colors.white,
                                )
                              : null,
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ulangi Setiap Minggu',
                                style:
                                    AppTextStyles.regular14.copyWith(
                                  color:
                                      const Color(0xFF181818),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Jadwal ini akan otomatis terpasang setiap minggu',
                                style:
                                    AppTextStyles.regular12.copyWith(
                                  color:
                                      const Color(0xFF777777),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed:
                          tempSelectedDays.isEmpty
                              ? null
                              : () {
                                  setState(() {
                                    _selectedDays
                                      ..clear()
                                      ..addAll(
                                        tempSelectedDays,
                                      );

                                    _repeatWeekly =
                                        tempRepeatWeekly;
                                  });

                                  Navigator.pop(
                                    sheetContext,
                                  );
                                },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        disabledBackgroundColor:
                            const Color(0xFFE0E0E0),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Simpan',
                        style:
                            AppTextStyles.regular14.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _handleRepeatSelection(int index) {
    setState(() {
      _selectedRepeat = index;
    });

    if (index == 2) {
      _showSpecificDaysDialog();
    }
  }

  void _saveSchedule() {
    Navigator.pop(context);
  }

  String _getRepeatLabel() {
    if (_selectedRepeat == 0) {
      return 'Hari Kerja (senin-jumat)';
    }

    if (_selectedRepeat == 1) {
      return 'Setiap Hari';
    }

    if (_selectedDays.isEmpty) {
      return 'Pilih Hari Spesifik';
    }

    final selected = _selectedDays.toList()..sort();

    return selected.map((index) => _days[index]).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Color(0xFF181818),
          ),
        ),
        title: Text(
          'Tambah jadwal',
          style: AppTextStyles.bold20.copyWith(
            color: const Color(0xFF181818),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. Pilih Status',
                style: AppTextStyles.semibold14.copyWith(
                  color: const Color(0xFF181818),
                ),
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
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.08,
                ),
                itemBuilder: (context, index) {
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
                        color: AppColors.white,
                        borderRadius:
                            BorderRadius.circular(10),
                        border: Border.all(
                          color: selected
                              ? AppColors.red
                              : const Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(8),
                          child: Text(
                            _statuses[index],
                            textAlign: TextAlign.center,
                            style:
                                AppTextStyles.regular14.copyWith(
                              color:
                                  const Color(0xFF181818),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              Text(
                '2. Atur Waktu',
                style: AppTextStyles.semibold14.copyWith(
                  color: const Color(0xFF181818),
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mulai',
                          style:
                              AppTextStyles.regular12.copyWith(
                            color:
                                const Color(0xFF252525),
                          ),
                        ),
                        const SizedBox(height: 6),
                        _TimeField(
                          time: _formatTime(_startTime),
                          onTap: _selectStartTime,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 7),

                  Padding(
                    padding:
                        const EdgeInsets.only(top: 25),
                    child: Text(
                      '—',
                      style:
                          AppTextStyles.regular16.copyWith(
                        color: const Color(0xFF777777),
                      ),
                    ),
                  ),

                  const SizedBox(width: 7),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selesai',
                          style:
                              AppTextStyles.regular12.copyWith(
                            color:
                                const Color(0xFF252525),
                          ),
                        ),
                        const SizedBox(height: 6),
                        _TimeField(
                          time: _formatTime(_endTime),
                          onTap: _selectEndTime,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                '3. Repeat Rules',
                style: AppTextStyles.semibold14.copyWith(
                  color: const Color(0xFF181818),
                ),
              ),

              const SizedBox(height: 10),

              Column(
                children: List.generate(
                  _repeatOptions.length,
                  (index) {
                    final selected =
                        _selectedRepeat == index;

                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          _handleRepeatSelection(index);
                        },
                        child: Container(
                          width: double.infinity,
                          constraints:
                              const BoxConstraints(
                            minHeight: 42,
                          ),
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius:
                                BorderRadius.circular(8),
                            border: Border.all(
                              color: selected
                                  ? AppColors.red
                                  : const Color(0xFFE0E0E0),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration:
                                    BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selected
                                        ? AppColors.red
                                        : const Color(
                                            0xFFAAAAAA,
                                          ),
                                  ),
                                ),
                                child: selected
                                    ? Center(
                                        child: Container(
                                          width: 9,
                                          height: 9,
                                          decoration:
                                              const BoxDecoration(
                                            color:
                                                AppColors.red,
                                            shape:
                                                BoxShape.circle,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: index == 0
                                    ? RichText(
                                        text:
                                            TextSpan(
                                          style:
                                              AppTextStyles
                                                  .regular14
                                                  .copyWith(
                                            color:
                                                const Color(
                                              0xFF181818,
                                            ),
                                          ),
                                          children: [
                                            const TextSpan(
                                              text:
                                                  'Hari Kerja',
                                            ),
                                            TextSpan(
                                              text:
                                                  ' (senin-jumat)',
                                              style:
                                                  AppTextStyles
                                                      .regular12
                                                      .copyWith(
                                                color:
                                                    const Color(
                                                  0xFF999999,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Text(
                                        index == 1
                                            ? 'Setiap Hari'
                                            : _getRepeatLabel(),
                                        style:
                                            AppTextStyles
                                                .regular14
                                                .copyWith(
                                          color:
                                              const Color(
                                            0xFF181818,
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  setState(() {
                    _repeatWeekly = !_repeatWeekly;
                  });
                },
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      margin:
                          const EdgeInsets.only(top: 1),
                      decoration: BoxDecoration(
                        color: _repeatWeekly
                            ? AppColors.red
                            : AppColors.white,
                        borderRadius:
                            BorderRadius.circular(2),
                        border: Border.all(
                          color: _repeatWeekly
                              ? AppColors.red
                              : const Color(0xFFE0A58E),
                        ),
                      ),
                      child: _repeatWeekly
                          ? const Icon(
                              Icons.check,
                              size: 15,
                              color: Colors.white,
                            )
                          : null,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ulangi Setiap Minggu',
                            style:
                                AppTextStyles.regular14.copyWith(
                              color:
                                  const Color(0xFF181818),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Jadwal ini akan otomatis terpasang setiap minggu',
                            style:
                                AppTextStyles.regular12.copyWith(
                              color:
                                  const Color(0xFF777777),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveSchedule,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Simpan jadwal',
                    style:
                        AppTextStyles.regular14.copyWith(
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
}

class _TimeField extends StatelessWidget {
  final String time;
  final VoidCallback onTap;

  const _TimeField({
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius:
              BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFE0A58E),
          ),
        ),
        child: Text(
          time,
          style:
              AppTextStyles.regular14.copyWith(
            color: const Color(0xFFBDBDBD),
          ),
        ),
      ),
    );
  }
}