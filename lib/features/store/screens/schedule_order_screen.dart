import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/features/store/controllers/checkout_controller.dart';

class ScheduleOrderScreen extends StatefulWidget {
  const ScheduleOrderScreen({super.key});

  @override
  State<ScheduleOrderScreen> createState() => _ScheduleOrderScreenState();
}

class _ScheduleOrderScreenState extends State<ScheduleOrderScreen> {
  int _tabIndex = 0; // 0=Today, 1=Tomorrow, 2=Schedule
  String? _selectedTime;
  DateTime _selectedDate = DateTime.now();

  static const List<String> _allSlots = [
    '9:00 AM', '11:00 AM', '1:00 PM', '3:00 PM', '5:00 PM', '7:00 PM', '9:00 PM',
  ];

  List<String> get _slotsForTab {
    if (_tabIndex == 0) {
      final now = DateTime.now();
      return _allSlots.where((s) {
        final hour = _slotHour(s);
        return hour > now.hour;
      }).toList();
    }
    return _allSlots;
  }

  int _slotHour(String slot) {
    final parts = slot.split(':');
    int h = int.tryParse(parts[0]) ?? 0;
    final isPM = slot.contains('PM');
    if (isPM && h != 12) h += 12;
    if (!isPM && h == 12) h = 0;
    return h;
  }

  String get _builtSlot {
    final l10n = AppLocalizations.of(Get.context!);
    if (_tabIndex == 0) return '${l10n.today}, $_selectedTime';
    if (_tabIndex == 1) return '${l10n.tomorrow}, $_selectedTime';
    final d = _selectedDate;
    return '${_monthName(d.month)} ${d.day}, $_selectedTime';
  }

  String _monthName(int m) => const [
    '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ][m];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(l10n.scheduleOrder,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                Text(l10n.whenDelivered,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                // Tabs
                Row(
                  children: [
                    _tab(context, l10n.today, 0, isDark),
                    const SizedBox(width: 10),
                    _tab(context, l10n.tomorrow, 1, isDark),
                    const SizedBox(width: 10),
                    _tab(context, l10n.schedule, 2, isDark),
                  ],
                ),
                const SizedBox(height: 24),
                // Calendar (only for Schedule tab)
                if (_tabIndex == 2) ...[
                  Text(l10n.availableDate,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.lightblack : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(const Duration(days: 60)),
                      focusedDay: _selectedDate,
                      selectedDayPredicate: (d) => isSameDay(d, _selectedDate),
                      onDaySelected: (selected, focused) =>
                          setState(() { _selectedDate = selected; _selectedTime = null; }),
                      calendarStyle: CalendarStyle(
                        selectedDecoration: const BoxDecoration(
                            color: AppColors.orange, shape: BoxShape.circle),
                        todayDecoration: BoxDecoration(
                            color: AppColors.orange.withValues(alpha: 0.3), shape: BoxShape.circle),
                        outsideDaysVisible: false,
                        defaultTextStyle: TextStyle(color: isDark ? Colors.white : Colors.black87),
                        weekendTextStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: false,
                        titleTextStyle: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        leftChevronIcon: Icon(Icons.chevron_left, color: isDark ? Colors.white : Colors.black87),
                        rightChevronIcon: Icon(Icons.chevron_right, color: isDark ? Colors.white : Colors.black87),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                        weekendStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                // Time slots
                Text(l10n.availableHours,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                if (_slotsForTab.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(l10n.noSlotsToday,
                        style: TextStyle(color: Colors.grey.shade500)),
                  )
                else
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _slotsForTab.map((slot) {
                      final sel = _selectedTime == slot;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedTime = slot),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: sel ? AppColors.orange.withValues(alpha: 0.1) : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: sel ? AppColors.orange : (isDark ? Colors.grey.shade500 : Colors.black87),
                              width: sel ? 1.5 : 1,
                            ),
                          ),
                          child: Text(slot,
                              style: TextStyle(
                                color: sel ? AppColors.orange : (isDark ? Colors.white : Colors.black87),
                                fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                              )),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 36),
            child: OutlinedButton(
              onPressed: _selectedTime == null
                  ? null
                  : () {
                      Get.find<CheckoutController>().setDeliverySlot(_builtSlot);
                      Get.toNamed(AppRoutes.checkout);
                    },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                side: BorderSide(color: isDark ? Colors.white70 : Colors.black87, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Text(l10n.next,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontWeight: FontWeight.w600, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(BuildContext context, String label, int index, bool isDark) {
    final sel = _tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() { _tabIndex = index; _selectedTime = null; }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: sel ? AppColors.orange : AppColors.orange.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(label,
                style: TextStyle(
                  color: sel ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                )),
          ),
        ),
      ),
    );
  }
}