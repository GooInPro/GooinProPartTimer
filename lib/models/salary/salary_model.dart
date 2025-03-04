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
