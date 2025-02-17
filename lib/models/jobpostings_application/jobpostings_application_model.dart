class JobPostingsApplication {
  String jpacontent;
  String jpahourlyRate;
  int pno;
  int jpno;

  JobPostingsApplication({this.jpacontent = '', this.jpahourlyRate = '', this.pno = 1, required this.jpno});

  // JSON 변환 함수
  Map<String, dynamic> toJson() {
    return {
      "jpacontent": jpacontent,
      "jpahourlyRate": jpahourlyRate,
      "pno": pno,
      "jpno": jpno,
    };
  }

  // JSON에서 객체로 변환하는 함수 (필요 시 추가)
  factory JobPostingsApplication.fromJson(Map<String, dynamic> json) {
    return JobPostingsApplication(
      jpacontent: json["jpacontent"] ?? '',
      jpahourlyRate: json["jpahourlyRate"] ?? '',
      pno: json["pno"] ?? 1,
      jpno: json["jpno"],
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'JobPostingsApplication(jpacontent: $jpacontent, hourlyRate: $jpahourlyRate, pno: $pno, jpno: $jpno)';
  }
}