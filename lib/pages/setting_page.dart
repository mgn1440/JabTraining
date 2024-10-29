import 'package:flutter/material.dart';
import 'package:jab_training/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jab_training/pages/auth_gate.dart';
import 'package:jab_training/pages//profile_edit_page.dart';
import 'package:jab_training/pages//password_edit_page.dart';
import 'package:jab_training/pages/terms_policy_show_page.dart';
import 'package:http/http.dart' as http;
import 'package:jab_training/provider/session_provider.dart';
import 'package:provider/provider.dart';

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
      if (mounted) {
        SessionProvider sessionProvider =
            Provider.of<SessionProvider>(context, listen: false);
        sessionProvider.setSession(false);
      }
    } on AuthException catch (error) {
      if (mounted) {
        context.showSnackBar(error.message, isError: true);
      }
    } catch (error) {
      if (mounted) {
        context.showSnackBar('Unexpected error occurred', isError: true);
      }
    }
  }

  Future<void> _deleteUser() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      context.showSnackBar('사용자를 찾을 수 없습니다.', isError: true);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'https://fxplgtgwynaldjiyvpii.supabase.co/functions/v1/delete-user'),
        headers: {
          'Authorization':
              'Bearer ${Supabase.instance.client.auth.currentSession?.accessToken}',
        },
        body: {
          'user_id': userId,
        },
      );
      if (response.statusCode == 200) {
        if (mounted) {
          await Supabase.instance.client.auth.signOut(); // 세션제거
          context.showSnackBar('회원 탈퇴가 완료되었습니다.');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AuthGate()),
          );
        }
      } else {
        if (mounted) {
          context.showSnackBar('회원 탈퇴에 실패했습니다.', isError: true);
        }
      }
    } catch (error) {
      if (mounted) {
        context.showSnackBar('알 수 없는 에러가 발생했습니다.', isError: true);
      }
    }
  }

  void _confirmDeleteUser() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('회원 탈퇴'),
          content: const Text('정말 탈퇴 하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('아니요'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteUser();
              },
              child: const Text('예'),
            ),
          ],
        );
      },
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
          _buildListTile('회원탈퇴', _confirmDeleteUser),
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
