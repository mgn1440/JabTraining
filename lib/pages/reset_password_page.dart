import 'package:flutter/material.dart';
import 'package:jab_training/component/custom_app_bar.dart';
import 'package:jab_training/component/custom_buttons.dart';
import 'package:jab_training/const/color.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jab_training/main.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  bool _isFormValid = false;

  void _validateForm() {
    setState(() {
      _isFormValid = _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _passwordController.text == _confirmPasswordController.text &&
          _passwordController.text.length >= 7;
    });
  }

  Future<void> _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    await supabase.auth
        .updateUser(
      UserAttributes(
        password: _passwordController.text,
      ),
    )
        .then((value) {
      if (mounted) {
        context.showSnackBar("비밀번호가 변경되었습니다.");
      }
      return;
    }).catchError((error) {
      if (mounted) {
        context.showSnackBar(error.toString(), isError: true);
      }
    });

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '비밀번호 변경',
        iconStat: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 36),
            TextField(
              controller: _passwordController,
              cursorColor: grayscaleSwatch[100],
              decoration: const InputDecoration(
                labelText: '비밀번호',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmPasswordController,
              cursorColor: grayscaleSwatch[100],
              decoration: const InputDecoration(
                labelText: '비밀번호 확인',
              ),
              obscureText: true,
            ),
            Expanded(child: Container()),
            CustomButton(
              isEnabled: _isFormValid && !_isLoading,
              buttonType: ButtonType.filled,
              onPressed: _resetPassword,
              child: Text(_isLoading ? '로딩중...' : '비밀번호 바꾸기'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
