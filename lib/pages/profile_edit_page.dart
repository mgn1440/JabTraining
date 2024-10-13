import 'package:flutter/material.dart';
import 'package:jab_training/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jab_training/component/buttons.dart';
import 'package:jab_training/const/color.dart';
import 'package:jab_training/component/custom_app_bar.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  String? _selectedGender;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    final User? user = supabase.auth.currentUser;
    if (user != null) {
      final profile =
          await supabase.from('profiles').select().eq('id', user.id).single();
      if (profile.isNotEmpty) {
        setState(() {
          _nameController.text = profile['name'] as String? ?? '';
          _emailController.text = user.email ?? ''; // Supabase에서 로그인된 사용자의 이메일
          _phoneController.text = profile['phone'] as String? ?? '';
          _birthController.text = profile['birth'] as String? ?? '';
          _selectedGender = profile['gender'] as String?; // 성별 초기값 설정
        });
      }
    }
  }

  Future<void> _updateProfile() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await supabase.from('profiles').update({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'birth': _birthController.text,
        'gender': _selectedGender,
      }).eq('id', supabase.auth.currentUser!.id);
    } on AuthException catch (error) {
      if (mounted) {
        context.showSnackBar(error.message, isError: true);
      }
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Unexpected error occured', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '프로필 설정',
        iconStat: true,
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            children: [
              const SizedBox(height: 18),
              TextField(
                controller: _nameController,
                cursorColor: grayscaleSwatch[100],
                decoration: const InputDecoration(labelText: '이름'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                cursorColor: grayscaleSwatch[100],
                decoration: const InputDecoration(labelText: '이메일'),
                enabled: false, // 이메일 수정 불가
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                cursorColor: grayscaleSwatch[100],
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: '전화번호'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                decoration: const InputDecoration(labelText: '성별'),
                items: ['남성', '여성'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _birthController,
                cursorColor: grayscaleSwatch[100],
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  labelText: '생년월일 (YYYY-MM-DD)',
                ),
              ),
              const SizedBox(height: 282),
              // TODO: 뉴스 및 프로모션 알림
              // TODO: Unsubscribe from everything
              // TODO: 계정 삭제 요청
            ],
          )),
          CustomButton(
            isEnabled: true,
            buttonType: ButtonType.filled,
            onPressed: () async {
              _updateProfile();
              Navigator.pop(context);
            },
            child: Text(_isLoading ? '로딩중...' : '완료'),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
