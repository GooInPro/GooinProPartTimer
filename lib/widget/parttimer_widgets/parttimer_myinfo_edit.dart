import 'package:flutter/material.dart';
import 'package:gooinpro_parttimer/models/parttimer/parttimer_model.dart';

class PartTimerMyInfoEdit extends StatefulWidget {
  final PartTimer partTimer;
  final Function(PartTimer) onSave;

  const PartTimerMyInfoEdit({
    super.key,
    required this.partTimer,
    required this.onSave,
  });

  @override
  State<PartTimerMyInfoEdit> createState() => _PartTimerMyInfoEditState();
}

class _PartTimerMyInfoEditState extends State<PartTimerMyInfoEdit> {
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController detailAddressController;
  late bool gender;
  late DateTime birthDate;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.partTimer.pname);
    addressController = TextEditingController(text: widget.partTimer.proadAddress);
    detailAddressController = TextEditingController(text: widget.partTimer.pdetailAddress);
    gender = widget.partTimer.pgender;
    birthDate = widget.partTimer.pbirth;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('개인정보 수정'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: '이름'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('성별: '),
                Radio(
                  value: true,
                  groupValue: gender,
                  onChanged: (value) => setState(() => gender = value!),
                ),
                const Text('남성'),
                Radio(
                  value: false,
                  groupValue: gender,
                  onChanged: (value) => setState(() => gender = value!),
                ),
                const Text('여성'),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: '도로명주소'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: detailAddressController,
              decoration: const InputDecoration(labelText: '상세주소'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            final updatedPartTimer = PartTimer(
              pno: widget.partTimer.pno,
              pemail: widget.partTimer.pemail,
              pname: nameController.text,
              pbirth: birthDate,
              pgender: gender,
              proadAddress: addressController.text,
              pdetailAddress: detailAddressController.text,
              pregdate: widget.partTimer.pregdate,
            );
            widget.onSave(updatedPartTimer);
            Navigator.pop(context);
          },
          child: const Text('저장'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    detailAddressController.dispose();
    super.dispose();
  }
}