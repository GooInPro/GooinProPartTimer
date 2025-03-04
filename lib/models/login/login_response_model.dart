class LoginResponse {
  final int pno;
  final String pemail;
  final String pname;
  final String accessToken;
  final String refreshToken;
  final bool newUser;

  LoginResponse({
    required this.pno,
    required this.pemail,
    required this.pname,
    required this.accessToken,
    required this.refreshToken,
    required this.newUser
  });

  // JSON 데이터를 객체로 변환하는 생성자
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      pno: json['pno'] ?? 0,
      pemail: json['pemail'] ?? '', // null 값 방지
      pname: json['pname'] ?? '',
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      newUser: json['newUser'] ?? true
    );
  }

  // 객체를 JSON 형태로 변환
  Map<String, dynamic> toJson() => {
    'pno' : pno,
    'pemail': pemail,
    'pname': pname,
    'accessToken' : accessToken,
    'refreshToken' : refreshToken,
    'newUser': newUser
  };
}