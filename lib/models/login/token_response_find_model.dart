class TokenResponseFind {
  final bool isNew;

  TokenResponseFind({required this.isNew});

  factory TokenResponseFind.fromJson(Map<String, dynamic> json) {
    return TokenResponseFind(
      isNew: json['isNew'],
    );
  }
}