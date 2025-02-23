class Login {
  final String email;
  final String name;

  Login({
    required this.email,
    required this.name,
  });

  // JSON 데이터를 객체로 변환하는 생성자
  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      email: json['email'] ?? '', // null 값 방지
      name: json['name'] ?? '',
    );
  }

  // 객체를 JSON 형태로 변환
  Map<String, dynamic> toJson() => {
    'email': email,
    'name': name,
  };
}