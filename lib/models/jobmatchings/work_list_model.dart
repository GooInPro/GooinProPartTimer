class WorkList{
  final int jmno;
  final int pno;
  final int jpno;
  final String jpname;
  String jpworkDays;

  WorkList({
    required this.jmno,
    required this.pno,
    required this.jpno,
    required this.jpname,
    required this.jpworkDays
});

  factory WorkList.fromJson(Map<String, dynamic>Json) {
    return WorkList(
        jmno: Json['jmno'],
        pno: Json['pno'] ?? 1,
        jpno: Json['jpno'],
        jpname: Json['jpname'],
        jpworkDays: Json['jpworkDays']);
  }

  static List<String> workDays(String jpworkDays) {
    List<String> days = [];
    List<String> weekDays = ['월', '화', '수', '목', '금', '토', '일'];

    if (jpworkDays.length != 7) {
      print("no data");
    }

    for (int i = 0; i < jpworkDays.length; i++) {
      if (jpworkDays[i] == '1') {
        days.add(weekDays[i]);
      }
    }
    return days;
  }
}