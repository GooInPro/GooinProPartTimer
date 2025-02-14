class Review {
  final int rno;
  final int pno;
  final int eno;
  final int rstart;
  final String rcontent;
  final DateTime rregdate;
  final bool rdelete;

  Review({
    required this.rno,
    required this.pno,
    required this.eno,
    required this.rstart,
    required this.rcontent,
    required this.rregdate,
    this.rdelete = false,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rno: json['rno'],
      pno: json['pno'],
      eno: json['eno'],
      rstart: json['rstart'],
      rcontent: json['rcontent'],
      rregdate: DateTime.parse(json['rregdate']),
      rdelete: json['rdelete'] ?? false,
    );
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