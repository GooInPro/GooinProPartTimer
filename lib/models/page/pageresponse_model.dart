import '../jobpostings/jobpostings_model.dart';

class PageResponseDTO {
  final List<JobPosting> dtoList;
  final int totalPage;
  final bool prev;
  final bool next;

  PageResponseDTO({
    required this.dtoList,
    required this.totalPage,
    required this.prev,
    required this.next,
  });

  // JSON으로부터 객체 생성
  factory PageResponseDTO.fromJson(Map<String, dynamic> json) {
    var list = json['dtoList'] as List;
    List<JobPosting> dtoList = list.map((i) => JobPosting.fromJson(i)).toList();

    return PageResponseDTO(
      dtoList: dtoList,
      totalPage: json['totalPage'],
      prev: json['prev'],
      next: json['next'],
    );
  }
}