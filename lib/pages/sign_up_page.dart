import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jab_training/main.dart';
import 'package:jab_training/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;
  bool _redirecting = false;

  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _phoneController = TextEditingController();
  late final TextEditingController _passwordController = TextEditingController();
  late final TextEditingController _confirmPasswordController = TextEditingController();
  late final TextEditingController _birthController = TextEditingController();
  String? _selectedGender;

  late final StreamSubscription<AuthState> _authStateSubscription;

  Future<void> _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      context.showSnackBar('비밀번호가 일치하지 않습니다.', isError: true);
      return ;
    }
    try {
      setState(() {
        _isLoading = true;
      });

      final AuthResponse res = await supabase.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
        data: {
          'name': _nameController.text,
          'phone': _phoneController.text,
          'birth': _birthController.text,
          'gender': _selectedGender,
        },
      );
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
  void initState() {
    _authStateSubscription = supabase.auth.onAuthStateChange.listen(
        (data) {
          if (_redirecting) return ;
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          const SizedBox(height: 18),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: '이름',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: '이메일 주소',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneController,
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
            decoration: const InputDecoration(
              labelText: '생년월일 (YYYY-MM-DD)',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: '비밀번호',
            ),
            obscureText: true,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(
              labelText: '비밀번호 확인',
            ),
            obscureText: true,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _isLoading ? null : _signUp,
            child: Text(_isLoading ? '로딩중...' : '회원가입'),
          ),
        ],
      ),
    );
  }
}
























































