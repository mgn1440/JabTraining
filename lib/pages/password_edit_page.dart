import 'package:flutter/material.dart';
import 'package:jab_training/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jab_training/component/custom_buttons.dart';
import 'package:jab_training/const/color.dart';
import 'package:jab_training/component/custom_app_bar.dart';

class PasswordEditPage extends StatefulWidget {
  const PasswordEditPage({super.key});

  @override
  State<PasswordEditPage> createState() => _PasswordEditPageState();
}

class _PasswordEditPageState extends State<PasswordEditPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  bool _isLoading = false;
  bool _isFormValid = false;

  @override
  void initState() {
    _currentPasswordController.addListener(_validateForm);
    _newPasswordController.addListener(_validateForm);
    _confirmNewPasswordController.addListener(_validateForm);
    super.initState();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _currentPasswordController.text.isNotEmpty &&
          _newPasswordController.text.isNotEmpty &&
          _confirmNewPasswordController.text.isNotEmpty;
    });
  }

  Future<void> _updatePassword() async {
    if (_newPasswordController.text != _confirmNewPasswordController.text) {
      context.showSnackBar('새 비밀번호가 일치하지 않습니다.', isError: true);
      return;
    }
    try {
      setState(() {
        _isLoading = true;
      });
      final User? user = supabase.auth.currentUser;
      final email = user?.email;

      if (email == null) {
        context.showSnackBar('사용자의 이메일을 확인할 수 없습니다.', isError: true);
        return;
      }

      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: _currentPasswordController.text,
      );

      final Session? session = res.session;
      final User? currentUser = res.user;
      if (session == null || currentUser == null) {
        if (mounted) {
          context.showSnackBar('현재 사용자 정보를 확인할 수 없습니다.', isError: true);
        }
        return;
      }

      await supabase.auth.updateUser(
        UserAttributes(
          password: _newPasswordController.text,
        ),
      );
      final User? updatedUser = supabase.auth.currentUser;
      if (updatedUser == null) {
        if (mounted) {
          context.showSnackBar('비밀번호 변경에 실패했습니다.', isError: true);
        }
        return;
      }
      if (mounted) {
        context.showSnackBar('비밀번호가 성공적으로 변경되었습니다.', isError: false);
        Navigator.pop(context);
      }
    } on AuthException catch (error) {
      if (mounted) {
        print(error.message); // DEBUG
        context.showSnackBar("현재 비밀번호가 올바르지 않습니다", isError: true);
      }
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Unexpected error occurred', isError: true);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: '비밀번호 변경', iconStat: true),
        body: Column(
          children: [
            Expanded(
                child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
              children: [
                const SizedBox(height: 18),
                TextField(
                  controller: _currentPasswordController,
                  cursorColor: grayscaleSwatch[100],
                  decoration: const InputDecoration(
                    labelText: '현재 비밀번호',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _newPasswordController,
                  cursorColor: grayscaleSwatch[100],
                  decoration: const InputDecoration(
                    labelText: '새 비밀번호',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _confirmNewPasswordController,
                  cursorColor: grayscaleSwatch[100],
                  decoration: const InputDecoration(
                    labelText: '새 비밀번호 확인',
                  ),
                  obscureText: true,
                ),
              ],
            )),
            CustomButton(
              isEnabled: _isFormValid,
              buttonType: ButtonType.filled,
              onPressed: () async => await _updatePassword(),
              child: Text(_isLoading ? '로딩중...' : '비밀번호 바꾸기'),
            ),
            const SizedBox(height: 40),
          ],
        ));
  }
}
