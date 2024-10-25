import 'package:flutter/material.dart';
import 'package:jab_training/component/custom_app_bar.dart';
import 'package:jab_training/component/buttons.dart';
import 'package:jab_training/const/color.dart';

class FindPasswordPage extends StatefulWidget {
  const FindPasswordPage({super.key});

  @override
  State<FindPasswordPage> createState() => _FindPasswordPageState();
}

class _FindPasswordPageState extends State<FindPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isFormValid = false;
  bool _isLoading = false;

  void _validateForm() {
    setState(() {
      _isFormValid = _emailController.text.isNotEmpty;
    });
  }

  Future<void> _requestPasswordReset() async {
    setState(() {
      _isLoading = true;
    });

    // Add your password reset logic here

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: '비밀번호 찾기',
        iconStat: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 18),
            TextField(
              controller: _emailController,
              cursorColor: grayscaleSwatch[100],
              decoration: const InputDecoration(
                labelText: '이메일',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            Expanded(child: Container()),
            CustomButton(
              isEnabled: _isFormValid && !_isLoading,
              buttonType: ButtonType.filled,
              onPressed: _requestPasswordReset,
              child: Text(_isLoading ? '로딩중...' : '비밀번호 초기화 요청'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
