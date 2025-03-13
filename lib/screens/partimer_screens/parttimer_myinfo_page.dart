import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:gooinpro_parttimer/models/parttimer/parttimer_model.dart';
import 'package:gooinpro_parttimer/services/api/parttimerapi/parttimer_api.dart';
import 'package:gooinpro_parttimer/utils/file_upload_util.dart';
import 'package:gooinpro_parttimer/widget/parttimer_widgets/parttimer_myinfo_section.dart';
import 'package:gooinpro_parttimer/widget/parttimer_widgets/parttimer_myinfo_edit.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../providers/user_provider.dart';
import '../../models/images/parttimer_image_model.dart';
import '../../services/api/imageapi/parttimer_image_api.dart';

class PartTimerMyInfoPage extends StatefulWidget {
  const PartTimerMyInfoPage({super.key});

  @override
  State<PartTimerMyInfoPage> createState() => _PartTimerMyInfoPageState();
}

class _PartTimerMyInfoPageState extends State<PartTimerMyInfoPage> {
  final PartTimerApi _partTimerApi = PartTimerApi();
  PartTimer? _partTimer;
  bool _isLoading = true;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = context.read<UserProvider>();
    _loadPartTimerInfo();
  }

  Future<void> _loadPartTimerInfo() async {
    try {
      final partTimer = await _partTimerApi.getPartTimerDetail(userProvider.pno!);
      if (!mounted) return;
      setState(() {
        _partTimer = partTimer;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading parttimer info: $e');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && mounted) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미지를 선택해주세요.')),
        );
      }
      return;
    }

    try {
      final baseUrl = dotenv.env['API_UPLOAD_LOCAL_HOST'] ?? 'http://192.168.50.34:8085';
      final uploadUri = Uri.parse(baseUrl).resolve('/upload/api/partTimer/profile').toString();

      List<String> fileNames = await FileUploadUtil.uploadFile(
        context: context,
        images: [_selectedImage!],
        uri: uploadUri,
      );

      if (!mounted) return;

      if (fileNames.isEmpty) {
        throw Exception('파일 업로드에 실패했습니다.');
      }

      parttimerImage data = parttimerImage(
          pifilename: fileNames,
          pno: userProvider.pno!
      );

      await parttimerImageApi().addPartTimerImage(data);

      if (!mounted) return;

      await _loadPartTimerInfo();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('프로필 이미지가 성공적으로 업데이트되었습니다.')),
      );
    } catch (e) {
      print('이미지 업로드 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미지 업로드에 실패했습니다: $e')),
        );
      }
    }
  }

  Future<void> _showEditDialog(BuildContext context) async {
    if (_partTimer == null) return;

    showDialog(
      context: context,
      builder: (context) => PartTimerMyInfoEdit(
        partTimer: _partTimer!,
        onSave: (updatedPartTimer) async {
          try {
            await _partTimerApi.editPartTimerInfo(
              userProvider.pno!,
              updatedPartTimer,
            );
            if (!mounted) return;
            await _loadPartTimerInfo();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('정보가 수정되었습니다.')),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('정보 수정에 실패했습니다.')),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_partTimer == null) {
      return const Center(child: Text('정보를 불러올 수 없습니다.'));
    }

    print('Selected Image Path: ${_selectedImage?.path}');
    print('Profile Image URL: ${_partTimer?.profileImageUrl}');

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: Colors.blue.shade100,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : (_partTimer?.profileImageUrl != null && _partTimer!.profileImageUrl.isNotEmpty)
                      ? NetworkImage(Uri.parse(dotenv.env['API_UPLOAD_LOCAL_HOST']!).resolve(_partTimer!.profileImageUrl).toString())
                      : NetworkImage("https://picsum.photos/200"),
                  onBackgroundImageError: (exception, stackTrace) {
                    print('Error loading image: $exception');
                  },
                  child: (_selectedImage == null && (_partTimer?.profileImageUrl == null || _partTimer!.profileImageUrl.isEmpty))
                      ? const Icon(Icons.person, size: 60, color: Colors.grey)
                      : null,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text('이미지 선택'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: _uploadImage,
                      icon: const Icon(Icons.upload),
                      label: const Text('프로필 이미지 변경'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  _partTimer!.pname,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _partTimer!.pemail,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PartTimerMyInfoSection(
                  title: '생년월일',
                  content: _partTimer!.pbirth.toString().split(' ')[0],
                ),
                PartTimerMyInfoSection(
                  title: '성별',
                  content: _partTimer!.pgender ? '남성' : '여성',
                ),
                PartTimerMyInfoSection(
                  title: '도로명주소',
                  content: _partTimer!.proadAddress,
                ),
                if (_partTimer!.pdetailAddress.isNotEmpty)
                  PartTimerMyInfoSection(
                    title: '상세주소',
                    content: _partTimer!.pdetailAddress,
                  ),
                const SizedBox(height: 24),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => context.go('/parttimer/matchinglogs'),
                            child: const Text('근무 이력 보기'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => context.go('/parttimer/calendartotal'),
                            child: const Text('급여 달력 보기'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => context.go('/review/mylist'),
                            child: const Text('내 리뷰 보기'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _showEditDialog(context),
                            child: const Text('내 정보 수정'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
