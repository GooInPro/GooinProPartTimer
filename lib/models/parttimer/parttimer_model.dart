class PartTimer {
  final int pno;
  final String pemail;
  final String pname;
  final DateTime pbirth;
  final bool pgender;
  final String proadAddress;
  final String pdetailAddress;
  final DateTime pregdate;
  final bool pdelete;
  final List<String> profileImageUrls;

  PartTimer({
    required this.pno,
    required this.pemail,
    required this.pname,
    required this.pbirth,
    required this.pgender,
    required this.proadAddress,
    required this.pdetailAddress,
    required this.pregdate,
    this.pdelete = false,
    this.profileImageUrls = const [],
  });

  // copyWith 메서드 추가 (모든 필드 포함)
  PartTimer copyWith({
    int? pno,
    String? pemail,
    String? pname,
    DateTime? pbirth,
    bool? pgender,
    String? proadAddress,
    String? pdetailAddress,
    DateTime? pregdate,
    bool? pdelete,
    List<String>? profileImageUrls,
  }) {
    return PartTimer(
      pno: pno ?? this.pno,
      pemail: pemail ?? this.pemail,
      pname: pname ?? this.pname,
      pbirth: pbirth ?? this.pbirth,
      pgender: pgender ?? this.pgender,
      proadAddress: proadAddress ?? this.proadAddress,
      pdetailAddress: pdetailAddress ?? this.pdetailAddress,
      pregdate: pregdate ?? this.pregdate,
      pdelete: pdelete ?? this.pdelete,
      profileImageUrls: profileImageUrls ?? this.profileImageUrls,
    );
  }

  factory PartTimer.fromJson(Map<String, dynamic> json) {
    return PartTimer(
      pno: json['pno'],
      pemail: json['pemail'],
      pname: json['pname'],
      pbirth: DateTime.parse(json['pbirth']),
      pgender: json['pgender'],
      proadAddress: json['proadAddress'],
      pdetailAddress: json['pdetailAddress'],
      pregdate: DateTime.parse(json['pregdate']),
      pdelete: json['pdelete'] ?? false,
      profileImageUrls: List<String>.from(json['profileImageUrls'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'pno': pno,
    'pemail': pemail,
    'pname': pname,
    'pbirth': pbirth.toIso8601String(),
    'pgender': pgender,
    'proadAddress': proadAddress,
    'pdetailAddress': pdetailAddress,
    'pregdate': pregdate.toIso8601String(),
    'pdelete': pdelete,
    'profileImageUrls': profileImageUrls,
  };
}
