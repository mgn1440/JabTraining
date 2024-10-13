import 'package:flutter/material.dart';
import 'dart:async';
import 'package:jab_training/component/buttons.dart';
import 'package:jab_training/const/color.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jab_training/main.dart';

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
  bool _isLoading = false;

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
    } on AuthException catch (error) {
      if (mounted) {
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

  void _showDialog(String title, String content) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
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
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: SingleChildScrollView(
                            child: Text(content),
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
                          child: const Text('닫기'),
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('약관 동의'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
                    _showDialog("이용 약관", "이용 약관 내용");
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
                    _showDialog("개인정보 이용 약관", "개인정보 이용 약관 내용");
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
            Expanded(child: Container()),
            CustomButton(
              isEnabled: _isTermsChecked && _isPrivacyChecked && !_isLoading,
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
