import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TermsPolicyProvider with ChangeNotifier {
  String? _terms;
  String? _privacyPolicy;
  final SupabaseClient supabase;

  TermsPolicyProvider(this.supabase);

  final List<Map<String, dynamic>> _terms_and_policy = [
    {'id': 1, 'title': 'terms'},
    {'id': 2, 'title': 'privacy'},
  ];

  Future<void> updateTermsAndPrivacyPolicy() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime? lastUpdated =
        DateTime.tryParse(prefs.getString('lastUpdated') ?? '');

    if (lastUpdated == null ||
        DateTime.now().difference(lastUpdated).inDays >= 1) {
      // Fetch new terms and privacy policy from the database
      final response = await supabase.from('terms').select('*');
      final data = response as List<dynamic>;

      // Update the local storage
      final newTerms =
          data.firstWhere((item) => item['title'] == 'terms')['body'];
      final newPrivacyPolicy =
          data.firstWhere((item) => item['title'] == 'privacy')['body'];

      await prefs.setString(
        'terms',
        newTerms,
      );
      await prefs.setString('privacy', newPrivacyPolicy);

      await prefs.setString('lastUpdated', DateTime.now().toIso8601String());

      // Update the local variables
      _terms = newTerms;
      _privacyPolicy = newPrivacyPolicy;

      notifyListeners();
    }
  }

  Future<String> getTerms() async {
    if (_terms == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _terms = prefs.getString('terms');
    }
    return _terms!;
  }

  Future<String> getPrivacyPolicy() async {
    if (_privacyPolicy == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _privacyPolicy = prefs.getString('privacy');
    }
    return _privacyPolicy!;
  }
}
