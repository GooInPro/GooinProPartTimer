class JobPosting {
  final int jpno;
  final int? wpno;
  final String jpname;
  final String? wroadAddress;
  final String? wdetailAddress;
  final int jphourlyRate;
  final String? jpenddate;
  final double? wlati;
  final double? wlong;

  JobPosting({
    required this.jpno,
    this.wpno,
    required this.jpname,
    this.wroadAddress,
    this.wdetailAddress,
    required this.jphourlyRate,
    this.jpenddate,
    this.wlati,
    this.wlong,
  });

  // JSON 데이터를 Dart 객체로 변환
  factory JobPosting.fromJson(Map<String, dynamic> json) {
    return JobPosting(
      jpno: json['jpno'],
      wpno: json['wpno'],
      jpname: json['jpname'],
      wroadAddress: json['wroadAddress'],
      wdetailAddress: json['wdetailAddress'],
      jphourlyRate: json['jphourlyRate'],
      jpenddate: json['jpenddate'],
      wlati: json['wlati'] != null
          ? double.tryParse(json['wlati'].toString())
          : null,
      wlong: json['wlong'] != null
          ? double.tryParse(json['wlong'].toString())
          : null,
    );
  }
}