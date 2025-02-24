class LoginRegister {
  String pemail;
  String pname;
  DateTime pbirth;
  bool pgender;
  String? proadAddress;
  String? pdetailAddress;

  LoginRegister({
    required this.pemail,
    required this.pname,
    required this.pbirth,
    required this.pgender,
    this.proadAddress,
    this.pdetailAddress,
  });

  // JSON 데이터를 객체로 변환하는 생성자
  factory LoginRegister.fromJson(Map<String, dynamic> json) {
    return LoginRegister(
      pemail: json['pemail'] ?? '', // null 값 방지
      pname: json['pname'] ?? '',
      pbirth: json['pbirth'] ?? DateTime.now(),
      pgender: json['pgender'] ?? true,
      proadAddress: json['proadAddress'] ?? null,
      pdetailAddress: json['pdetailAddress'] ?? null,
    );
  }

  // 객체를 JSON 형태로 변환
  Map<String, dynamic> toJson() => {
    'pemail': pemail,
    'pname': pname,
    'pbirth': pbirth.toIso8601String(),
    'pgender' : pgender,
    'proadAddress' : proadAddress,
    'pdetailAddress': pdetailAddress
  };
}
