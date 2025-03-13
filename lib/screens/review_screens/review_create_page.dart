import 'package:flutter/material.dart';
import 'package:gooinpro_parttimer/services/api/reviewapi/review_api.dart';
import 'package:gooinpro_parttimer/models/review/review_model.dart';
import 'package:provider/provider.dart';
import 'package:gooinpro_parttimer/providers/user_provider.dart';


class ReviewCreatePage extends StatefulWidget {
  final int eno;
  final String ename;

  const ReviewCreatePage({Key? key, required this.eno, required this.ename}) : super(key: key);

  @override
  _ReviewCreatePageState createState() => _ReviewCreatePageState();
}

class _ReviewCreatePageState extends State<ReviewCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('리뷰 작성 - ${widget.ename}'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('별점', style: Theme.of(context).textTheme.titleLarge),
              Row(
                children: List.generate(5, (index) =>
                    IconButton(
                      icon: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () => setState(() => _rating = index + 1),
                    )
                ),
              ),
              SizedBox(height: 16),
              Text('리뷰 내용', style: Theme.of(context).textTheme.titleLarge),
              TextFormField(
                controller: _contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '리뷰 내용을 입력해주세요.',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '리뷰 내용을 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitReview,
                child: Text('리뷰 제출'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitReview() async {
    if (_formKey.currentState!.validate() && _rating > 0) {
      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final pno = userProvider.pno;

        final review = Review(
          rno: 0,
          pno: pno!,
          eno: widget.eno,
          rstart: _rating,
          rcontent: _contentController.text,
          rregdate: DateTime.now(),
          rdelete: false,
        );

        await ReviewApi().createReview(review);

        // mounted 체크 추가
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('리뷰가 성공적으로 제출되었습니다.')),
        );
        Navigator.pop(context);
      } catch (e) {
        // mounted 체크 추가
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('리뷰 제출에 실패했습니다: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('별점과 리뷰 내용을 모두 입력해주세요.')),
      );
    }
  }
}
