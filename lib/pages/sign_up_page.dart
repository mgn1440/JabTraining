import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jab_training/const/color.dart';
import 'package:jab_training/main.dart';
import 'package:jab_training/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jab_training/component/buttons.dart';
import 'package:jab_training/pages/terms_policy_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;
  bool _redirecting = false;
  bool _isFormValid = false;

  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _phoneController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  late final TextEditingController _confirmPasswordController =
      TextEditingController();
  late final TextEditingController _birthController = TextEditingController();
  String? _selectedGender;

  late final StreamSubscription<AuthState> _authStateSubscription;

  void _validateForm() {
    setState(() {
      _isFormValid = _nameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _phoneController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _birthController.text.isNotEmpty &&
          _selectedGender != null;
    });
  }

  Future<void> _onPressd() async {
    if (!await _checkPassword()) return;
    if (!await _checkEmail()) return;
    if (!await _checkPhone()) return;
    if (!await _checkBirth()) return;
    _navigateToTermsPolicyPage();
  }

  Future<bool> _checkPassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      context.showSnackBar('비밀번호가 일치하지 않습니다.', isError: true);
      return false;
    }
    if (_passwordController.text.length < 6) {
      context.showSnackBar('비밀번호는 7자 이상이어야 합니다.', isError: true);
      return false;
    }
    return true;
  }

  Future<bool> _checkEmail() async {
    if (_emailController.text.contains('@') == false) {
      context.showSnackBar('이메일 형식이 일치하지 않습니다.', isError: true);
      return false;
    }
    return true;
  }

  bool _isNum(String numString) {
    final numRegex = RegExp(r'^\d+$');
    return numRegex.hasMatch(numString);
  }

  Future<bool> _checkPhone() async {
    if (_phoneController.text.length < 10 || !_isNum(_phoneController.text)) {
      context.showSnackBar('전화번호 형식이 일치하지 않습니다.', isError: true);
      return false;
    }
    return true;
  }

  Future<bool> _checkBirth() async {
    if (_birthController.text.length < 8 || _birthController.text.length > 9) {
      context.showSnackBar('생년월일 형식이 일치하지 않습니다.', isError: true);
      return false;
    }
    return true;
  }

  void _navigateToTermsPolicyPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermsPolicyPage(
          email: _emailController.text,
          password: _passwordController.text,
          data: {
            'name': _nameController.text,
            'phone': _phoneController.text,
            'birth': _birthController.text,
            'gender': _selectedGender,
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    _nameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
    _birthController.addListener(_validateForm);
    _authStateSubscription = supabase.auth.onAuthStateChange.listen(
      (data) {
        if (_redirecting) return;
        final session = data.session;
        if (session != null) {
          _redirecting = true;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      },
      onError: (error) {
        if (error is AuthException) {
          if (mounted) {
            context.showSnackBar(error.message, isError: true);
          }
        } else {
          if (mounted) {
            context.showSnackBar('Unexpected error occured', isError: true);
          }
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _birthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
              children: [
                const SizedBox(height: 18),
                TextFormField(
                  controller: _nameController,
                  cursorColor: grayscaleSwatch[100],
                  decoration: const InputDecoration(
                    labelText: '이름',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  cursorColor: grayscaleSwatch[100],
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: '이메일 주소',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  cursorColor: grayscaleSwatch[100],
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: '전화번호',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: '성별',
                  ),
                  items: <String>['남성', '여성'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _birthController,
                  cursorColor: grayscaleSwatch[100],
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    labelText: '생년월일 (YYYY-MM-DD)',
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  cursorColor: grayscaleSwatch[100],
                  decoration: const InputDecoration(
                    labelText: '비밀번호',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmPasswordController,
                  cursorColor: grayscaleSwatch[100],
                  decoration: const InputDecoration(
                    labelText: '비밀번호 확인',
                  ),
                  obscureText: true,
                ),
              ],
            ),
          ),
          CustomButton(
            isEnabled: _isFormValid && !_isLoading,
            buttonType: ButtonType.filled,
            onPressed: _onPressd,
            child: Text(_isLoading ? '로딩중...' : "회원가입"),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
