// 월별 급여 모델
class SalaryMonthly {
  final int year;
  final int month;
  final int totalHours;
  final int totalSalary;
  final String jpname;

  SalaryMonthly({
    required this.year,
    required this.month,
    required this.totalHours,
    required this.totalSalary,
    required this.jpname,
  });

  factory SalaryMonthly.fromJson(Map<String, dynamic> json) {
    return SalaryMonthly(
      year: json['year'],
      month: json['month'],
      totalHours: json['totalHours'],
      totalSalary: json['totalSalary'],
      jpname: json['jpname'],
    );
  }
}

// 알바별 급여 모델
class SalaryJob {
  final String jpname;
  final int totalHours;
  final int totalSalary;
  final DateTime startDate;
  final DateTime endDate;

  SalaryJob({
    required this.jpname,
    required this.totalHours,
    required this.totalSalary,
    required this.startDate,
    required this.endDate,
  });

  factory SalaryJob.fromJson(Map<String, dynamic> json) {
    return SalaryJob(
      jpname: json['jpname'],
      totalHours: json['totalHours'],
      totalSalary: json['totalSalary'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
}

// 일별 급여 모델
class SalaryDaily {
  final DateTime workDate;
  final int hours;
  final int salary;
  final String jpname;
  final int jmno;

  SalaryDaily({
    required this.workDate,
    required this.hours,
    required this.salary,
    required this.jpname,
    required this.jmno,
  });

  factory SalaryDaily.fromJson(Map<String, dynamic> json) {
    return SalaryDaily(
      workDate: DateTime.parse(json['workDate']),
      hours: json['hours'],
      salary: json['salary'],
      jpname: json['jpname'],
      jmno: json['jmno'],
    );
  }
}
