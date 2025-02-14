class JobMatchings {
  final int jmno;
  final int? jpno;
  final DateTime jmregdate;
  final String? jmstatus;
  final bool jmdelete;
  final DateTime? jmendDate;
  final int jmhourlyRate;
  final DateTime jmstartDate;
  final String jmworkDays;
  final DateTime? jmworkEndTime;
  final DateTime? jmworkStartTime;
  final int? eno;
  final int? pno;
  final String jpname;

  JobMatchings({
    required this.jmno,
    this.jpno,
    required this.jmregdate,
    this.jmstatus,
    required this.jmdelete,
    this.jmendDate,
    required this.jmhourlyRate,
    required this.jmstartDate,
    required this.jmworkDays,
    this.jmworkEndTime,
    this.jmworkStartTime,
    this.eno,
    this.pno,
    required this.jpname,
  });

  factory JobMatchings.fromJson(Map<String, dynamic> json) {
    return JobMatchings(
      jmno: json['jmno'],
      jpno: json['jpno'],
      jmregdate: DateTime.parse(json['jmregdate']),
      jmstatus: json['jmstatus'],
      jmdelete: json['jmdelete'] ?? false,  // null일 경우 기본값 false
      jmendDate: json['jmendDate'] != null ? DateTime.parse(json['jmendDate']) : null,
      jmhourlyRate: json['jmhourlyRate'],
      jmstartDate: DateTime.parse(json['jmstartDate']),
      jmworkDays: json['jmworkDays'],
      jmworkEndTime: json['jmworkEndTime'] != null ? DateTime.parse(json['jmworkEndTime']) : null,
      jmworkStartTime: json['jmworkStartTime'] != null ? DateTime.parse(json['jmworkStartTime']) : null,
      eno: json['eno'],
      pno: json['pno'],
      jpname: json['jpname'],
    );
  }
}
