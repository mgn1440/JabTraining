import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jab_training/pages/sign_in_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jab_training/pages/sign_up_page.dart';
import 'package:jab_training/component/buttons.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          /* 로고 */
          Expanded(
            child: Center(
              child: SvgPicture.asset('assets/image/Logo.svg', width: 240),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomButton(
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                isEnabled: true,
                buttonType: ButtonType.outlined,
                columnCount: 3,
                child: const Text('회원가입'),
              ),
              const SizedBox(width: 16),
              CustomButton(
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                  );
                },
                isEnabled: true,
                buttonType: ButtonType.filled,
                columnCount: 3,
                child: const Text('로그인'),
              ),
            ],
          ),
          const SizedBox(height: 77),
        ],
      ),
    ));
  }
}
