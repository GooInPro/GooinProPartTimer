import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gooinpro_parttimer/models/jobmatchings/jobmatchings_model.dart';
import 'package:gooinpro_parttimer/models/salary/salary_model.dart';
import 'package:gooinpro_parttimer/services/api/salaryapi/salary_api.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

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
  List<SalaryDaily> _dailySalaries = []; // 일별 급여 데이터
  Map<DateTime, int> _dailySalaryMap = {}; // 날짜별 급여 맵

  final NumberFormat _currencyFormat = NumberFormat('#,###', 'ko_KR');

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

    initializeDateFormatting('ko_KR', null).then((_) {
      setState(() {});
    });

    _focusedDay = widget.jobMatching.jmstartDate;
    _selectedDay = _focusedDay;

    _loadSalaryData();
    _loadDailySalaryData(); // 일별 급여 데이터 로드
  }

  Future<void> _loadSalaryData() async {
    try {
      final salaries = await _salaryApi.getMonthlySalary(
        tempPno,
        year: _focusedDay.year,
      );

      // 특정 근무지(jpname)로 필터링
      final filteredSalaries = salaries.where(
              (salary) => salary.jpname == widget.jobMatching.jpname
      ).toList();

      setState(() {
        _monthlySalaries = filteredSalaries;
        _createEvents(filteredSalaries);
      });
    } catch (e) {
      print('급여 데이터 로드 실패: $e');
    }
  }

  // 일별 급여 데이터 로드
  Future<void> _loadDailySalaryData() async {
    try {
      final dailySalaries = await _salaryApi.getDailySalary(
        tempPno,
        jmno: widget.jobMatching.jmno,
        year: _focusedDay.year,
        month: _focusedDay.month,
      );

      // 날짜별 급여 맵 생성
      Map<DateTime, int> dailySalaryMap = {};
      for (var salary in dailySalaries) {
        // 날짜만 추출 (시간 정보 제거)
        final dateKey = DateTime(
          salary.workDate.year,
          salary.workDate.month,
          salary.workDate.day,
        );
        dailySalaryMap[dateKey] = salary.salary;
      }

      setState(() {
        _dailySalaries = dailySalaries;
        _dailySalaryMap = dailySalaryMap;
      });
    } catch (e) {
      print('일별 급여 데이터 로드 실패: $e');
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
    // 일별 급여의 합계로 월별 총액 계산
    int monthlyTotal = 0;

    // 현재 표시된 월의 일별 급여만 합산
    _dailySalaryMap.forEach((date, salary) {
      if (date.year == _focusedDay.year && date.month == _focusedDay.month) {
        monthlyTotal += salary;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.jobMatching.jpname} 급여'),
      ),
      body: Column(
        children: [
          // 월 총액 표시 위젯 추가
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.withOpacity(0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_focusedDay.year}년 ${_focusedDay.month}월 총 급여',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_currencyFormat.format(monthlyTotal)}원',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          TableCalendar(
            locale: 'ko_KR',
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
            onPageChanged: (focusedDay) {
              // 페이지가 변경될 때 해당 월의 데이터 로드
              setState(() {
                _focusedDay = focusedDay;
              });
              _loadSalaryData();
              _loadDailySalaryData(); // 일별 급여 데이터도 다시 로드
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },

            // 마커 빌더 수정 - 실제 근무한 날에만 일급 표시
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                // 날짜만 추출 (시간 정보 제거)
                final dateKey = DateTime(date.year, date.month, date.day);

                // 해당 날짜에 근무 기록이 있는 경우에만 일급 표시
                if (_dailySalaryMap.containsKey(dateKey)) {
                  return Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${_currencyFormat.format(_dailySalaryMap[dateKey])}원',
                        style: const TextStyle(
                          fontSize: 8,
                          color: Colors.white,
                        ),
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
