import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/models/jobmatchings/work_tims_model.dart';
import 'package:gooinpro_parttimer/models/worklogs/worklog_start_model.dart';
import 'package:gooinpro_parttimer/services/api/inoutapi/in_out_api.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../models/worklogs/worklog_end_model.dart';
import '../../models/worklogs/worklog_send_model.dart';
import '../../providers/user_provider.dart';
import '../../services/api/worklogapi/worklog_api.dart';

class InOutPage extends StatefulWidget {
  final int jmno;
  final int jpno;

  InOutPage({Key? key, required this.jmno, required this.jpno}) : super(key: key);

  @override
  _InOutPageState createState() => _InOutPageState();
}

class _InOutPageState extends State<InOutPage> {
  late UserProvider userProvider; // provider 1
  WorkTimes? workTimes; // 회사의 출퇴근 기준 9시 ~ 18시
  WorkLogStart? workLogStart; // 본인 출근 시간
  WorkLogEnd? workLogEnd;
  InOutapi inoutapi = InOutapi();
  WorkLogApi workLogApi = WorkLogApi();
  bool inout = false; // fase = 출근, true = 퇴근
  int workStatus = 7;


  @override
  void initState() {
    super.initState();
  }

  @override // provider 2
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = context.read<UserProvider>();
    getWorkTimes();
    getRealStart(userProvider.pno!, widget.jmno);
  }

  Future<void> getWorkTimes() async {
    WorkTimes data = await inoutapi.getWorkTime(userProvider.pno!, widget.jpno);
    setState(() {
      workTimes = data;
    });
  }

  Future<WorkLogStart> sendStartTime(WorkLogSend sendData) async {
    WorkLogStart data = await workLogApi.sendStartTime(sendData);
    setState(() {
      workLogStart = WorkLogStart(
        wlstartTime: data.wlstartTime,
        wlworkStatus: data.wlworkStatus,
      );
    });
    inout = true;
    workStatus = data.wlworkStatus;
    return data; // 정상적으로 데이터를 반환
  }

  Future<WorkLogEnd> sendEndTime(WorkLogSend sendData) async {
    WorkLogEnd data = await workLogApi.sendEndTime(sendData);
    setState(() {
      workLogEnd = WorkLogEnd(
        wlendTime: data.wlendTime,
        wlworkStatus: data.wlworkStatus,
      );
    });
    inout = false;
    workStatus = data.wlworkStatus;
    return data;
  }

  Future<String> getRealStart(int pno, int jmno) async {
    String data = await workLogApi.realStartTime(pno, jmno);
    return data;
  }

  String getWorkStatusString(int status) {
    switch (status) {
      case 0:
        return '정상출근';
      case 1:
        return '지각';
      case 2:
        return '조퇴';
      case 3:
        return '결근';
      case 4:
        return '지각/조퇴';
      default:
        return '출근이전';
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget inOutButton;

    // 출근/퇴근 버튼
    if (inout == false) {
      inOutButton = ElevatedButton(
        onPressed: () {
          WorkLogSend sendData = WorkLogSend(
            pno: userProvider.pno!,
            jmno: widget.jmno,
          );
          sendStartTime(sendData);
        },
        child: Text(
          '출근',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          backgroundColor: Colors.lightBlue, // 하늘색
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // 둥근 모서리
          ),
          elevation: 5, // 버튼에 그림자 추가
        ),
      );
    } else {
      inOutButton = ElevatedButton(
        onPressed: () {
          WorkLogSend sendData = WorkLogSend(
            pno: userProvider.pno!,
            jmno: widget.jmno,
          );
          sendEndTime(sendData);
        },
        child: Text(
          '퇴근',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          backgroundColor: Colors.lightBlue, // 하늘색
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // 둥근 모서리
          ),
          elevation: 5, // 버튼에 그림자 추가
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("출퇴근"),
        backgroundColor: Colors.blueAccent,
      ),
      body: workTimes == null
          ? Center(child: CircularProgressIndicator()) // 데이터가 로딩 중일 때 표시
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 출근/퇴근 버튼
            inOutButton,

            SizedBox(height: 30),

            // 출근 시간과 퇴근 시간 (박스로 묶기)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightBlue[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.lightBlue, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    workTimes?.jmworkStartTime != null
                        ? DateFormat('HH:mm').format(
                        workTimes!.jmworkStartTime!)
                        : '',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    workTimes?.jmworkEndTim != null
                        ? DateFormat('HH:mm').format(workTimes!.jmworkEndTim!)
                        : '',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // 실제 출근 시간과 퇴근 시간 (박스로 묶기)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightBlue[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.lightBlue, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    workLogStart?.wlstartTime != null
                        ? DateFormat('HH:mm').format(workLogStart!.wlstartTime)
                        : '',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    workLogEnd?.wlendTime != null
                        ? DateFormat('HH:mm').format(workLogEnd!.wlendTime)
                        : '',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // 출근 상태 (출근 상태도 박스로 묶기)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightBlue[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.lightBlue, width: 2),
              ),
              child: Text(
                getWorkStatusString(workStatus),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}