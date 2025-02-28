class WorkLogSend{
  final int pno;
  final int jmno;

  WorkLogSend({
    required this.pno,
    required this.jmno
});

  Map<String, dynamic> toJson() {
    return {
      "pno": pno,
      "jmno": jmno,
    };
  }

  @override
  String toString() {
    return 'WorkLogSend(pno: $pno, jmno: $jmno)';
  }
}