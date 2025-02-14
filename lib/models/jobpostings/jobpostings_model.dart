import 'package:flutter/material.dart';

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

class JobPostingDetail {
  final int jpno;
  final String jpname;
  final String? wroadAddress;
  final String? wdetailAddress;
  final int jphourlyRate;
  final String? jpworkDays;
  final String? jpenddate;
  final TimeOfDay jpworkStartTime;
  final TimeOfDay jpworkEndTime;

  JobPostingDetail({
    required this.jpno,
    required this.jpname,
    this.wroadAddress,
    this.wdetailAddress,
    required this.jphourlyRate,
    this.jpworkDays,
    this.jpenddate,
    required this.jpworkStartTime,
    required this.jpworkEndTime,
  });

  factory JobPostingDetail.fromJson(Map<String, dynamic> json) {
    return JobPostingDetail(
      jpno: json['jpno'],
      jpname: json['jpname'],
      wroadAddress: json['wroadAddress'],
      wdetailAddress: json['wdetailAddress'],
      jphourlyRate: json['jphourlyRate'],
      jpworkDays: json['jpworkDays'],
      jpenddate: json['jpenddate'],
      jpworkStartTime: _parseTime(json['jpworkStartTime']),
      jpworkEndTime: _parseTime(json['jpworkEndTime']),
    );
  }

  static TimeOfDay _parseTime(String timeString) {
      final parts = timeString.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    }

  static List<String> workDays(String jpworkDays) {
    List<String> days = [];
    List<String> weekDays = ['월', '화', '수', '목', '금', '토', '일'];

    if (jpworkDays.length != 7) {
      print("no data");
    }

    for (int i = 0; i < jpworkDays.length; i++) {
      if (jpworkDays[i] == '1') {
        days.add(weekDays[i]);
      }
    }
    return days;
  }
}

