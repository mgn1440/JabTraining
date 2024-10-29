import 'package:flutter/material.dart';
import 'package:jab_training/component/custom_app_bar.dart';
import 'package:jab_training/component/custom_buttons.dart';
import 'package:jab_training/const/color.dart';
import 'package:jab_training/main.dart';

class FindPasswordPage extends StatefulWidget {
  const FindPasswordPage({super.key});

  @override
  FindPasswordPageState createState() => FindPasswordPageState();
}

class FindPasswordPageState extends State<FindPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isFormValid = false;

  void _onEmailChanged() {
    setState(() {
      _isFormValid = _emailController.text.isNotEmpty;
    });
  }

  Future<void> _sendResetEmail() async {
    setState(() {
      _isLoading = true;
    });
    supabase.auth
        .resetPasswordForEmail(
      _emailController.text,
      redirectTo: 'jabtraining://reset-password',
    )
        .then((value) {
      context.showSnackBar('비밀번호 재설정 이메일을 보냈습니다.');
    }).catchError((error) {
      context.showSnackBar(error.toString(), isError: true);
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '비밀번호 찾기', iconStat: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 36),
            TextField(
              controller: _emailController,
              cursorColor: grayscaleSwatch[100],
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: '이메일',
                border: OutlineInputBorder(),
              ),
            ),
            Expanded(child: Container()),
            CustomButton(
              isEnabled: _isFormValid && !_isLoading,
              buttonType: ButtonType.filled,
              onPressed: _sendResetEmail,
              child: Text(_isLoading ? '로딩중...' : '전송'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
