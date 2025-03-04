class JobMatchings {
  final int jmno;
  final String jpname;
  final DateTime jmregdate;
  final DateTime jmstartDate;
  final DateTime? jmendDate;
  final int jmhourlyRate;
  final String jmworkDays;
  final DateTime? jmworkStartTime;
  final DateTime? jmworkEndTime;
  final String? wroadAddress;
  final String? wdetailAddress;
  final bool jmdelete;  // 추가

  JobMatchings({
    required this.jmno,
    required this.jpname,
    required this.jmregdate,
    required this.jmstartDate,
    this.jmendDate,
    required this.jmhourlyRate,
    required this.jmworkDays,
    this.jmworkStartTime,
    this.jmworkEndTime,
    this.wroadAddress,
    this.wdetailAddress,
    required this.jmdelete,
  });

  factory JobMatchings.fromJson(Map<String, dynamic> json) {
    return JobMatchings(
      jmno: json['jmno'],
      jpname: json['jpname'],
      jmregdate: DateTime.parse(json['jmregdate']),
      jmstartDate: DateTime.parse(json['jmstartDate']),
      jmendDate: json['jmendDate'] != null ? DateTime.parse(json['jmendDate']) : null,
      jmhourlyRate: json['jmhourlyRate'],
      jmworkDays: json['jmworkDays'],
      jmworkStartTime: json['jmworkStartTime'] != null ? DateTime.parse(json['jmworkStartTime']) : null,
      jmworkEndTime: json['jmworkEndTime'] != null ? DateTime.parse(json['jmworkEndTime']) : null,
      wroadAddress: json['wroadAddress'],
      wdetailAddress: json['wdetailAddress'],
      jmdelete: json['jmdelete'] ?? false,
    );
  }
}
