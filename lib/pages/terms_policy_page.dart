import 'package:flutter/material.dart';
import 'dart:async';
import 'package:jab_training/component/custom_buttons.dart';
import 'package:jab_training/const/color.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jab_training/main.dart';
import 'package:jab_training/provider/terms_policy_provider.dart';
import 'package:jab_training/component/custom_app_bar.dart';
import 'package:jab_training/provider/session_provider.dart';
import 'package:provider/provider.dart';

class TermsPolicyPage extends StatefulWidget {
  final String email;
  final String password;
  final Map<String, dynamic> data;
  const TermsPolicyPage({
    required this.email,
    required this.password,
    required this.data,
    super.key,
  });

  @override
  TermsPolicyPageState createState() => TermsPolicyPageState();
}

class TermsPolicyPageState extends State<TermsPolicyPage> {
  bool _isTermsChecked = false;
  bool _isPrivacyChecked = false;
  bool _isOver14Checked = false;
  bool _isLoading = false;
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

  Future<void> _signUp() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await supabase.auth.signUp(
        email: widget.email,
        password: widget.password,
        data: widget.data,
      );
      if (mounted) {
        SessionProvider sessionProvider =
            Provider.of<SessionProvider>(context, listen: false);
        sessionProvider.setSession(true);
      }
    } on AuthException catch (error) {
      if (mounted) {
        print(error.message);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            // backgroundColor: error.messageColor,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unexpected error occured'),
            // backgroundColor: error.messageColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDialog(String title, Future<String> content) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return FutureBuilder(
          future: content,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                title: Text(title),
                content: const CircularProgressIndicator(),
                actions: <Widget>[
                  TextButton(
                    child: const Text('닫기'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                title: Text(title),
                content: Text('Error: ${snapshot.error}'),
                actions: <Widget>[
                  TextButton(
                    child: Text('닫기',
                        style: TextStyle(color: grayscaleSwatch[600])),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                title: Text(title),
                content: const Text('No content available.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('닫기',
                        style: TextStyle(color: grayscaleSwatch[600])),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            } else {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                    padding: EdgeInsets.zero,
                    viewInsets: EdgeInsets.zero,
                    viewPadding: EdgeInsets.zero),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.6,
                        padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                        margin: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                title,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                child: SingleChildScrollView(
                                  child: Text(snapshot.data.toString()),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15.0),
                                  bottomRight: Radius.circular(15.0),
                                ),
                              ),
                              width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15.0),
                                      bottomRight: Radius.circular(15.0),
                                    ),
                                  ),
                                ),
                                child: Text('닫기',
                                    style:
                                        TextStyle(color: grayscaleSwatch[600])),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '약관 동의', iconStat: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Checkbox(
                  value: _isTermsChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isTermsChecked = value ?? false;
                    });
                  },
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isTermsChecked = !_isTermsChecked;
                    });
                  },
                  child: const Text('이용 약관에 동의합니다.'),
                ),
                Expanded(child: Container()),
                CustomButton(
                  isEnabled: true,
                  buttonType: ButtonType.text,
                  onPressed: () async {
                    _showDialog("이용 약관", _termsText);
                  },
                  child: Text(
                    '자세히보기',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: primarySwatch[500],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _isPrivacyChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isPrivacyChecked = value ?? false;
                    });
                  },
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPrivacyChecked = !_isPrivacyChecked;
                    });
                  },
                  child: const Text('개인정보 이용에 동의합니다.'),
                ),
                Expanded(child: Container()),
                CustomButton(
                  isEnabled: true,
                  buttonType: ButtonType.text,
                  onPressed: () async {
                    _showDialog("개인정보 이용 약관", _policyText);
                  },
                  child: Text(
                    '자세히보기',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: primarySwatch[500],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _isOver14Checked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isOver14Checked = value ?? false;
                    });
                  },
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isOver14Checked = !_isOver14Checked;
                    });
                  },
                  child: const Text('만 14세 이상입니다.'),
                ),
                Expanded(child: Container()),
              ],
            ),
            Expanded(child: Container()),
            CustomButton(
              isEnabled: _isTermsChecked &&
                  _isPrivacyChecked &&
                  _isOver14Checked &&
                  !_isLoading,
              onPressed: _signUp,
              buttonType: ButtonType.filled,
              child: const Text('동의'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
