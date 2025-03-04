class WorkTimes{
  final int pno;
  final int jpno;
  final DateTime? jmworkStartTime;
  final DateTime? jmworkEndTim;

  WorkTimes({
    required this.pno,
    required this.jpno,
    this.jmworkStartTime,
    this.jmworkEndTim
});

  factory WorkTimes.fromJson(Map<String, dynamic> json) {
    return WorkTimes(
      pno: json['pno'],
      jpno: json['jpno'],
      jmworkStartTime: json['jmworkStartTime'] != null
          ? DateTime.parse(json['jmworkStartTime']).toLocal()
          : null,
      jmworkEndTim: json['jmworkEndTime'] != null
          ? DateTime.parse(json['jmworkEndTime']).toLocal()
          : null,
    );
  }
}