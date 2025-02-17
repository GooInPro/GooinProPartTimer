class PartTimerWorkLogs {
  final int wlno;
  final DateTime? wlstartTime;
  final DateTime? wlendTime;
  final int wlworkStatus;    // 0:정상, 1:지각, 2:조퇴, 3:결근
  final DateTime wlregdate;
  final String? wlchangedStartTime;
  final String? wlchangedEndTime;
  final int? eno;
  final int? pno;
  final int? jmno;
  final bool wldelete;

  PartTimerWorkLogs({
    required this.wlno,
    this.wlstartTime,
    this.wlendTime,
    required this.wlworkStatus,
    required this.wlregdate,
    this.wlchangedStartTime,
    this.wlchangedEndTime,
    this.eno,
    this.pno,
    this.jmno,
    required this.wldelete,
  });

  factory PartTimerWorkLogs.fromJson(Map<String, dynamic> json) {
    return PartTimerWorkLogs(
      wlno: json['wlno'],
      wlstartTime: json['wlstartTime'] != null ? DateTime.parse(json['wlstartTime']) : null,
      wlendTime: json['wlendTime'] != null ? DateTime.parse(json['wlendTime']) : null,
      wlworkStatus: json['wlworkStatus'],
      wlregdate: DateTime.parse(json['wlregdate']),
      wlchangedStartTime: json['wlchangedStartTime'],
      wlchangedEndTime: json['wlchangedEndTime'],
      eno: json['eno'],
      pno: json['pno'],
      jmno: json['jmno'],
      wldelete: json['wldelete'],
    );
  }
}
