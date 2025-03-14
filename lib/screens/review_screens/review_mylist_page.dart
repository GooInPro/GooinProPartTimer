import 'package:flutter/material.dart';
import 'package:gooinpro_parttimer/services/api/reviewapi/review_api.dart';
import 'package:gooinpro_parttimer/models/review/review_model.dart';
import 'package:provider/provider.dart';
import 'package:gooinpro_parttimer/providers/user_provider.dart';

class ReviewMyListPage extends StatefulWidget {
  const ReviewMyListPage({Key? key}) : super(key: key);

  @override
  _ReviewMyListPageState createState() => _ReviewMyListPageState();
}

class _ReviewMyListPageState extends State<ReviewMyListPage> {
  late Future<List<Review>> _reviewsFuture;
  final ReviewApi _reviewApi = ReviewApi();

  @override
  void initState() {
    super.initState();
    _loadMyReviews();
  }

  void _loadMyReviews() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final pno = userProvider.pno;

    print('사용자 ID: $pno');

    if (pno != null) {
      _reviewsFuture = _reviewApi.getReviewList(pno: pno);
    } else {
      print('사용자 ID가 null입니다');
      _reviewsFuture = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내가 작성한 리뷰'),
      ),
      body: FutureBuilder<List<Review>>(
        future: _reviewsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러 발생: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('작성한 리뷰가 없습니다.'));
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
                        // 공고명 추가
                        Text(
                          review.jpname.isNotEmpty ? review.jpname : '(공고명 없음)',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '별점: ${review.rstart}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
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
}
