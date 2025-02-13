// class PartTimer {
//   final int pno;
//   final DateTime pbirth;
//   final bool pdelete;
//   final String? pdetailAddress;
//   final String pemail;
//   final bool pgender;
//   final String pname;
//   final String ppw;
//   final DateTime pregdate;
//   final String? proadAddress;
//
//   PartTimer({
//     required this.pno,
//     required this.pbirth,
//     required this.pdelete,
//     this.pdetailAddress,
//     required this.pemail,
//     required this.pgender,
//     required this.pname,
//     required this.ppw,
//     required this.pregdate,
//     this.proadAddress,
//   });
//
//   factory PartTimer.fromJson(Map<String, dynamic> json) {
//     return PartTimer(
//       pno: json['pno'],
//       pbirth: DateTime.parse(json['pbirth']),
//       pdelete: json['pdelete'] == 1,
//       pdetailAddress: json['pdetailAddress'],
//       pemail: json['pemail'],
//       pgender: json['pgender'] == 1,
//       pname: json['pname'],
//       ppw: json['ppw'],
//       pregdate: DateTime.parse(json['pregdate']),
//       proadAddress: json['proadAddress'],
//     );
//   }
// }
