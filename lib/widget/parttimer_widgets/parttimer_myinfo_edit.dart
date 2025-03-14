import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  late TextEditingController _nameController;
  late TextEditingController _birthController;
  late TextEditingController _addressController;
  late TextEditingController _detailAddressController;
  late bool _gender;
  DateTime? _selectedBirth;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.partTimer.pname);
    _birthController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(widget.partTimer.pbirth),
    );
    _addressController = TextEditingController(text: widget.partTimer.proadAddress);
    _detailAddressController = TextEditingController(text: widget.partTimer.pdetailAddress);
    _gender = widget.partTimer.pgender;
    _selectedBirth = widget.partTimer.pbirth;
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirth) {
      setState(() {
        _selectedBirth = picked;
        _birthController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _searchAddress() async {
    // 주소 검색 API 연동 (예: 카카오 주소 검색)
    // final result = await AddressSearchAPI.search();
    // if (result != null) {
    //   _addressController.text = result;
    // }
  }

  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _selectedBirth != null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('개인정보 수정', style: TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '이름',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) => value?.isEmpty ?? true ? '이름을 입력해주세요' : null,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectBirthDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _birthController,
                  decoration: const InputDecoration(
                    labelText: '생년월일',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? '생년월일을 선택해주세요' : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('성별', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 20),
                Radio<bool>(
                  value: true,
                  groupValue: _gender,
                  onChanged: (value) => setState(() => _gender = value!),
                ),
                const Text('남성'),
                Radio<bool>(
                  value: false,
                  groupValue: _gender,
                  onChanged: (value) => setState(() => _gender = value!),
                ),
                const Text('여성'),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: '도로명 주소',
                prefixIcon: Icon(Icons.location_on),
                suffixIcon: Icon(Icons.search),
              ),
              readOnly: true,
              onTap: _searchAddress,
              validator: (value) => value?.isEmpty ?? true ? '주소를 검색해주세요' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _detailAddressController,
              decoration: const InputDecoration(
                labelText: '상세 주소',
                prefixIcon: Icon(Icons.home),
              ),
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
          onPressed: _isFormValid
              ? () {
            final updatedPartTimer = PartTimer(
              pno: widget.partTimer.pno,
              pemail: widget.partTimer.pemail,
              pname: _nameController.text,
              pbirth: _selectedBirth!,
              pgender: _gender,
              proadAddress: _addressController.text,
              pdetailAddress: _detailAddressController.text,
              pregdate: widget.partTimer.pregdate,
            );
            widget.onSave(updatedPartTimer);
            Navigator.pop(context);
          }
              : null,
          child: const Text('저장'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthController.dispose();
    _addressController.dispose();
    _detailAddressController.dispose();
    super.dispose();
  }
}
