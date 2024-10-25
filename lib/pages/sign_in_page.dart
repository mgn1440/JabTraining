import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jab_training/component/buttons.dart';
import 'package:jab_training/const/color.dart';
import 'package:jab_training/main.dart';
import 'package:jab_training/pages/find_password_page.dart';
import 'package:jab_training/pages/home_page.dart';
import 'package:jab_training/component/custom_app_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:jab_training/provider/calendar_provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;
  bool _redirecting = false;
  bool _isFormValid = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final StreamSubscription<AuthState> _authStateSubscription;

  void _validateForm() {
    setState(() {
      _isFormValid = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  Future<void> _signIn() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
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
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _authStateSubscription = supabase.auth.onAuthStateChange.listen(
      (data) {
        if (_redirecting) return;
        final session = data.session;
        if (session != null) {
          _redirecting = true;
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  create: (context) => CalendarProvider(),
                  child: const HomePage(),
                ),
              ),
              (Route<dynamic> route) => false, // 모든 스택을 제거
            );
          }
        }
      },
      onError: (error) {
        if (error is AuthException) {
          if (mounted) {
            context.showSnackBar(error.toString(), isError: true);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: '로그인', iconStat: true),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                children: [
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _emailController,
                    cursorColor: grayscaleSwatch[100],
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: '이메일',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _passwordController,
                    cursorColor: grayscaleSwatch[100],
                    decoration: const InputDecoration(
                      labelText: '비밀번호',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                ],
              ),
            ),
            CustomButton(
              isEnabled: true,
              buttonType: ButtonType.text,
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FindPasswordPage(),
                  ),
                );
              },
              child: const Text('비밀번호 찾기'),
            ),
            CustomButton(
              isEnabled: _isFormValid,
              buttonType: ButtonType.filled,
              onPressed: _signIn,
              child: Text(_isLoading ? '로딩중...' : "로그인"),
            ),
            const SizedBox(height: 40),
          ],
        ));
  }
}
