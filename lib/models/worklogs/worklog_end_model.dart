class WorkLogEnd {
  final DateTime wlendTime;
  final int wlworkStatus;

  WorkLogEnd({
    required this.wlendTime,
    required this.wlworkStatus
  });

  factory WorkLogEnd.fromJson(Map<String, dynamic> json) {
    return WorkLogEnd(
        wlendTime: DateTime.parse(json['wlendTime']).toLocal(),
        wlworkStatus: json['wlworkStatus']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "wlendTime": wlendTime,
      "wlworkStatus": wlworkStatus,
    };
  }

  @override
  String toString() {
    return 'WorkLogEnd(wlendTime: $wlendTime, wlworkStatus: $wlworkStatus)';
  }

}