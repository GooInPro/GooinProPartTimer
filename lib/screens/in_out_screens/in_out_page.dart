import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gooinpro_parttimer/models/jobmatchings/work_tims_model.dart';
import 'package:gooinpro_parttimer/models/worklogs/worklog_real_time_model.dart';
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
  RealTime? realTime;
  InOutapi inoutapi = InOutapi();
  WorkLogApi workLogApi = WorkLogApi();

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

  Future<void> sendStartTime(WorkLogSend sendData) async {
    WorkLogStart data = await workLogApi.sendStartTime(sendData);
    WorkLogStart realData = await workLogApi.realStartTime(userProvider.pno!, widget.jmno);

    setState(() {
      realTime = RealTime(
        wlstartTime: realData.wlstartTime,
        wlendTime: null,
        wlworkStatus: realData.wlworkStatus,
      );
    });
  }

  Future<void> sendEndTime(WorkLogSend sendData) async {
    WorkLogEnd data = await workLogApi.sendEndTime(sendData);
    WorkLogEnd realData = await workLogApi.realEndTime(userProvider.pno!, widget.jmno);

    setState(() {
      realTime = RealTime(
        wlstartTime: realTime?.wlstartTime,
        wlendTime: realData.wlendTime,
        wlworkStatus: realData.wlworkStatus,
      );
    });
  }

  Future<void> getRealStart(int pno, int jmno) async {
    WorkLogStart data = await workLogApi.realStartTime(pno, jmno);
    setState(() {
      workLogStart = data; // realStart 데이터 저장
      realTime = RealTime(
        wlstartTime: data.wlstartTime,
        wlendTime: null,
        wlworkStatus: data.wlworkStatus,
      );
    });
  }

  Future<void> getRealEnd(int pno, int jmno) async {
    WorkLogEnd data = await workLogApi.realEndTime(pno, jmno);
    setState(() {
      workLogEnd = data; // realStart 데이터 저장
      realTime = RealTime(
        wlstartTime: realTime?.wlstartTime,
        wlendTime: data.wlendTime,
        wlworkStatus: data.wlworkStatus,
      );
    });
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
      case 5:
        return '출근이전';
      default:
        return '출근이전';
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget inOutButton;

    // 출근/퇴근 버튼
    if (realTime?.wlstartTime == null) {
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 출근/퇴근 버튼
            Text('정규 출퇴근 시간', style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
            // 출근 시간과 퇴근 시간 (박스로 묶기)
            Center(
              child: Container(
              width: MediaQuery.of(context).size.width / 2 ,
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
                  Text('-',style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  Text(
                    workTimes?.jmworkEndTim != null
                        ? DateFormat('HH:mm').format(workTimes!.jmworkEndTim!)
                        : '',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            ),

            SizedBox(height: 20),
            Text('본인 출퇴근 시간', style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
            // 실제 출근 시간과 퇴근 시간 (박스로 묶기)
            Container(
              width: MediaQuery.of(context).size.width / 2 ,
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
                    realTime?.wlstartTime != null
                        ? DateFormat('HH:mm').format(realTime!.wlstartTime!)
                        : '',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Text('-',style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  Text(
                    realTime?.wlendTime != null
                        ? DateFormat('HH:mm').format(realTime!.wlendTime!)
                        : '',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // 출근 상태 (출근 상태도 박스로 묶기)
            // 출근 상태 (출근 상태도 박스로 묶기)
            Text(
              getWorkStatusString(realTime?.wlworkStatus ?? 5),
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 30),
            inOutButton,
          ],
        ),
      ),
    );
  }
}