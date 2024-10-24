import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jab_training/pages/auth_gate.dart';
import 'package:jab_training/pages//profile_edit_page.dart';
import 'package:jab_training/pages//password_edit_page.dart';
import 'package:jab_training/pages/terms_policy_show_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Future<void> _signOut() async {
    final supabase = Supabase.instance.client;
    try {
      await supabase.auth.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthGate()),
        );
      }
    } on AuthException catch (error) {
      if (mounted) {
        _showSnackBar(error.message, isError: true);
      }
    } catch (error) {
      if (mounted) {
        _showSnackBar('Unexpected error occurred', isError: true);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildListTile('프로필 설정', () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ProfileEditPage()),
            );
          }),
          _buildListTile('서비스 약관', () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => TermsPolicyShowPage()),
            );
          }),
          _buildListTile('비밀번호 바꾸기', () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const PasswordEditPage()),
            );
          }),
          _buildListTile('로그아웃', _signOut),
          _buildListTile('회원탈퇴', () {
            // 회원 탈퇴 로직
          }),
        ],
      ),
    );
  }

  Widget _buildListTile(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
