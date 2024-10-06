import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jab_training/pages/auth_gate.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final supabase = Supabase.instance.client;
            await supabase.auth.signOut();  // Supabase 로그아웃 메서드

            // 로그아웃 후에 로그인 페이지나 다른 페이지로 이동
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const AuthGate()),
            );
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
