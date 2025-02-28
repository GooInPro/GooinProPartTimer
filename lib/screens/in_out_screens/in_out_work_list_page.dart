import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // 추가된 부분
import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/models/jobmatchings/work_list_model.dart';
import 'package:gooinpro_parttimer/services/api/inoutapi/in_out_api.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class InOutWorkListPage extends StatefulWidget {
  @override
  _InOutWorkListPageState createState() => _InOutWorkListPageState();
}

class _InOutWorkListPageState extends State<InOutWorkListPage> {
  late UserProvider userProvider; // provider 1
  final InOutapi inOutapi = InOutapi();
  List<WorkList> workList = [];


  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = context.read<UserProvider>();
    if (userProvider.pno != null) {
      getWorkList(userProvider.pno!);
    }
  }


  Future<void> getWorkList(int pno) async {
      List<WorkList> listdata = await inOutapi.getWorkList(pno);
      setState(() {
        workList = listdata;
        for (var work in workList) {
          work.jpworkDays = WorkList.workDays(work.jpworkDays).join(", ");
        }
        print(workList);
      });
  }

  void onClickMove(int jpno) {
    // 버튼 클릭 시 실행할 로직을 추가할 수 있습니다.
    int? jmno = workList.map((data) => data.jmno).first;
    print(jmno);
    context.go('/inoutwork/inout', extra: {'jpno': jpno, 'jmno': jmno});
    // 예: 구직 신청 API 호출 등
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Work List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: workList.isEmpty
          ? Center(child: CircularProgressIndicator()) // 로딩 중일 때 표시
          : ListView.builder(
        itemCount: workList.length,
        itemBuilder: (context, index) {
          final work = workList[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                work.jpname,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blueAccent,
                ),
              ),
              subtitle: Text(
                '출근 요일: ${work.jpworkDays}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
              onTap: () {
                // 해당 항목을 클릭했을 때의 동작
                onClickMove(work.jpno);
                print('Tapped on ${work.jpname}');
              },
            ),
          );
        },
      ),
    );
  }
}