class jobPostingsImage {
  List<String> jpifilename;

  jobPostingsImage({
    required this.jpifilename
});

  factory jobPostingsImage.fromJson(Map<String, dynamic>Json) {
    return jobPostingsImage(
        jpifilename: Json['jpifilename']
    );
  }
}