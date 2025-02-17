class Salary {
  final String jpname;
  final int totalHours;
  final int totalSalary;
  final DateTime startDate;
  final DateTime endDate;

  Salary({
    required this.jpname,
    required this.totalHours,
    required this.totalSalary,
    required this.startDate,
    required this.endDate,
  });

  factory Salary.fromJson(Map<String, dynamic> json) {
    return Salary(
      jpname: json['jpname'],
      totalHours: json['totalHours'],
      totalSalary: json['totalSalary'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }
}