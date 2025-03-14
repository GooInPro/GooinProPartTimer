import 'package:flutter/material.dart';
import 'package:gooinpro_parttimer/services/api/reviewapi/review_api.dart';
import 'package:gooinpro_parttimer/models/review/review_model.dart';

class ReviewJobPostingsPage extends StatefulWidget {
  final int eno;

  const ReviewJobPostingsPage({Key? key, required this.eno}) : super(key: key);

  @override
  _ReviewJobPostingsPageState createState() => _ReviewJobPostingsPageState();
}

class _ReviewJobPostingsPageState extends State<ReviewJobPostingsPage> {
  late Future<List<Review>> _reviewsFuture;
  final ReviewApi _reviewApi = ReviewApi();

  @override
  void initState() {
    super.initState();
    _loadEmployerReviews();
  }

  void _loadEmployerReviews() {
    _reviewsFuture = _reviewApi.getReviewList(eno: widget.eno);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('근무지 리뷰 목록'),
      ),
      body: FutureBuilder<List<Review>>(
        future: _reviewsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러 발생: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('이 근무지에 대한 리뷰가 없습니다.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final review = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildStarRating(review.rstart),
                            const Spacer(),
                            Text(
                              review.rregdate.toString().split(' ')[0],
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(review.rcontent),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildStarRating(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }
}
