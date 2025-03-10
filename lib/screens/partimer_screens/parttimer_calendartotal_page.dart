import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gooinpro_parttimer/models/salary/salary_model.dart';
import 'package:gooinpro_parttimer/services/api/salaryapi/salary_api.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../providers/user_provider.dart';

class PartTimerCalendarTotalPage extends StatefulWidget {
  const PartTimerCalendarTotalPage({super.key});

  @override
  State<PartTimerCalendarTotalPage> createState() => _PartTimerCalendarTotalPageState();
}

class _PartTimerCalendarTotalPageState extends State<PartTimerCalendarTotalPage> {
  final SalaryApi _salaryApi = SalaryApi();
  List<SalaryMonthly> _monthlySalaries = [];
  List<SalaryDaily> _dailySalaries = []; // 일별 급여 데이터
  Map<DateTime, int> _dailySalaryMap = {}; // 날짜별 급여 맵

  late UserProvider userProvider; // provider 1

  final NumberFormat _currencyFormat = NumberFormat('#,###', 'ko_KR');

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

    _selectedDay = _focusedDay;

    _loadSalaryData();
    _loadDailySalaryData(); // 일별 급여 데이터 로드
  }

  @override // provider 2
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = context.read<UserProvider>();
  }

  Future<void> _loadSalaryData() async {
    try {
      final salaries = await _salaryApi.getMonthlySalary(
        userProvider.pno!,
        year: _focusedDay.year,
      );

      setState(() {
        _monthlySalaries = salaries;
      });
    } catch (e) {
      print('급여 데이터 로드 실패: $e');
    }
  }

  // 일별 급여 데이터 로드 - 모든 근무지 포함
  Future<void> _loadDailySalaryData() async {
    try {
      final dailySalaries = await _salaryApi.getDailySalary(
        userProvider.pno!,
        year: _focusedDay.year,
        month: _focusedDay.month,
      );

      // 날짜별 급여 맵 생성 - 같은 날짜의 급여는 합산
      Map<DateTime, int> dailySalaryMap = {};
      for (var salary in dailySalaries) {
        // 날짜만 추출 (시간 정보 제거)
        final dateKey = DateTime(
          salary.workDate.year,
          salary.workDate.month,
          salary.workDate.day,
        );

        // 같은 날짜에 여러 근무지의 급여가 있을 경우 합산
        if (dailySalaryMap.containsKey(dateKey)) {
          dailySalaryMap[dateKey] = dailySalaryMap[dateKey]! + salary.salary;
        } else {
          dailySalaryMap[dateKey] = salary.salary;
        }
      }

      setState(() {
        _dailySalaries = dailySalaries;
        _dailySalaryMap = dailySalaryMap;
      });
    } catch (e) {
      print('일별 급여 데이터 로드 실패: $e');
    }
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
        title: const Text('전체 급여 달력'),
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
