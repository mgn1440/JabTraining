import 'package:flutter/material.dart';
import 'package:jab_training/component/custom_app_bar.dart';
import 'package:jab_training/component/custom_buttons.dart';
import 'package:jab_training/main.dart';
import 'package:jab_training/provider/terms_policy_provider.dart';

class TermsPolicyShowPage extends StatefulWidget {
  @override
  _TermsPolicyShowPageState createState() => _TermsPolicyShowPageState();
}

class _TermsPolicyShowPageState extends State<TermsPolicyShowPage> {
  bool _showTerms = true;
  final TermsPolicyProvider _termsPolicyProvider =
      TermsPolicyProvider(supabase);

  late Future<String> _termsText;
  late Future<String> _policyText;

  @override
  void initState() {
    super.initState();
    _termsPolicyProvider.updateTermsAndPrivacyPolicy();
    _termsText = _termsPolicyProvider.getTerms();
    _policyText = _termsPolicyProvider.getPrivacyPolicy();
  }

  void _onButtonSelected(int index) {
    setState(() {
      _showTerms = index == 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "서비스 약관", iconStat: true),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SelectButtonGroup(
                buttonLabels: const ["이용약관", "개인정보 처리방침"],
                onSelected: _onButtonSelected,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: _showTerms
                  ? FutureBuilder<String>(
                      future: _termsText,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Text(snapshot.data ?? 'No terms available.');
                        }
                      },
                    )
                  : FutureBuilder<String>(
                      future: _policyText,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Text(
                              snapshot.data ?? 'No privacy policy available.');
                        }
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
