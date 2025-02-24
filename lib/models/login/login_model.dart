class Login {
  final String pemail;
  final String pname;

  Login({
    required this.pemail,
    required this.pname,
  });

  // JSON 데이터를 객체로 변환하는 생성자
  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      pemail: json['pemail'] ?? '', // null 값 방지
      pname: json['pname'] ?? '',
    );
  }

  // 객체를 JSON 형태로 변환
  Map<String, dynamic> toJson() => {
    'pemail': pemail,
    'pname': pname,
  };
}