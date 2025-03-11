class parttimerDocumentImage{
  final List<String> pdifilename;
  final int pno;

  parttimerDocumentImage({
    required this.pdifilename,
    required this.pno
  });

  Map<String, dynamic> toJson() {
    return {
      "pdifilename" : pdifilename,
      "pno" : pno
    };
  }
}
