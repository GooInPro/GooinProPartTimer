class Review {
  final int rno;
  final int pno;
  final int eno;
  final int rstart;
  final String rcontent;
  final DateTime rregdate;
  final bool rdelete;
  final String jpname;

  Review({
    required this.rno,
    required this.pno,
    required this.eno,
    required this.rstart,
    required this.rcontent,
    required this.rregdate,
    this.rdelete = false,
    this.jpname = '',
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    print('Review.fromJson 호출: $json');
    try {
      return Review(
        rno: json['rno'] ?? 0,
        pno: json['pno'] ?? 0,
        eno: json['eno'] ?? 0,
        rstart: json['rstart'] ?? 0,
        rcontent: json['rcontent'] ?? '',
        rregdate: json['rregdate'] != null
            ? DateTime.parse(json['rregdate'])
            : DateTime.now(),
        rdelete: json['rdelete'] ?? false,
        jpname: json['jpname'] ?? '',
      );
    } catch (e) {
      print('Review.fromJson 오류: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'rno': rno,
    'pno': pno,
    'eno': eno,
    'rstart': rstart,
    'rcontent': rcontent,
    'rregdate': rregdate.toIso8601String(),
    'rdelete': rdelete,
  };
}