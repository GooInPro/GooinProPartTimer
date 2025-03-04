class WorkLogStart {
 final DateTime wlstartTime;
 final int wlworkStatus;

 WorkLogStart({
   required this.wlstartTime,
   required this.wlworkStatus
});

 factory WorkLogStart.fromJson(Map<String, dynamic> json) {
   return WorkLogStart(
     wlstartTime: DateTime.parse(json['wlstartTime']).toLocal(),
     wlworkStatus: json['wlworkStatus']
   );
 }

 Map<String, dynamic> toJson() {
   return {
     "wlstartTime": wlstartTime,
     "wlworkStatus": wlworkStatus,
   };
 }

 @override
 String toString() {
   return 'WorkLogStart(wlstartTime: $wlstartTime, wlworkStatus: $wlworkStatus)';
 }

}