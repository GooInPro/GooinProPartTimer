class parttimerImage{
  final List<String> pifilename;
  final int pno;

  parttimerImage({
    required this.pifilename,
    required this.pno
});

  Map<String, dynamic> toJson() {
    return {
      "pifilename" : pifilename,
      "pno" : pno
    };
  }

}
