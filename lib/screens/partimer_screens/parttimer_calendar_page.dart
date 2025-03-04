import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gooinpro_parttimer/models/jobmatchings/jobmatchings_model.dart';
import 'package:gooinpro_parttimer/models/salary/salary_model.dart';
import 'package:gooinpro_parttimer/services/api/salaryapi/salary_api.dart';

class PartTimerCalendarPage extends StatefulWidget {
  final JobMatchings jobMatching;  // 근무지 정보

  const PartTimerCalendarPage({
    super.key,
    required this.jobMatching,
  });

  @override
  State<PartTimerCalendarPage> createState() => _PartTimerCalendarPageState();
}

class _PartTimerCalendarPageState extends State<PartTimerCalendarPage> {
  final SalaryApi _salaryApi = SalaryApi();
  List<SalaryMonthly> _monthlySalaries = [];

  // 날짜별 급여 정보를 저장할 Map 추가
  Map<DateTime, List<SalaryMonthly>> _events = {};

  final int tempPno = 1;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final kFirstDay = DateTime(2020, 1, 1);
  final kLastDay = DateTime(2030, 12, 31);

  @override
  void initState() {
    super.initState();
    _loadSalaryData();
  }

  Future<void> _loadSalaryData() async {
    try {
      final salaries = await _salaryApi.getMonthlySalary(
        tempPno,
        year: _focusedDay.year,
      );
      setState(() {
        _monthlySalaries = salaries;
        _createEvents(salaries); // 이벤트 생성 추가
      });
    } catch (e) {
      print('급여 데이터 로드 실패: $e');
    }
  }

  // 급여 데이터를 이벤트로 변환하는 메서드 추가
  void _createEvents(List<SalaryMonthly> salaries) {
    _events.clear();
    for (var salary in salaries) {
      DateTime date = DateTime(salary.year, salary.month);
      if (_events[date] == null) {
        _events[date] = [];
      }
      _events[date]!.add(salary);
    }
  }

  // 특정 날짜의 이벤트를 가져오는 메서드 추가
  List<SalaryMonthly> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.jobMatching.jpname} 급여'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },

            // calendarBuilders 추가
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final salaries = _getEventsForDay(date);
                if (salaries.isNotEmpty) {
                  return Positioned(
                    bottom: 1,
                    child: Text(
                      '${salaries[0].totalSalary}원',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.blue,
                      ),
                    ),
                  );
                }
                return null;
              },
            ),

            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
        ],
      ),
    );
  }
}

