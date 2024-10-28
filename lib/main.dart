import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jab_training/provider/terms_policy_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jab_training/pages/auth_gate.dart';
import 'package:jab_training/pages/home_page.dart';
import 'package:jab_training/const/color.dart';
import 'package:jab_training/provider/calendar_provider.dart';
import 'package:provider/provider.dart';
import 'package:jab_training/provider/location_provider.dart';
import 'package:jab_training/provider/gym_equipment_provider.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_KEY']!,
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CalendarProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(
            create: (context) => GymEquipmentsProvider(supabase)),
        ChangeNotifierProvider(
            create: (context) => TermsPolicyProvider(supabase)),
      ],
      child: MaterialApp(
        title: 'Supabase Flutter',
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: background,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: grayscaleSwatch[100]!),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: grayscaleSwatch[100]!),
            ),
            labelStyle: TextStyle(color: grayscaleSwatch[100]),
          ),
          primaryColor: Colors.green,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.green,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
            ),
          ),
        ),
        navigatorKey: navigatorKey,
        home: _getInitialPage(),
      ),
    );
  }

  Widget _getInitialPage() {
    final session = supabase.auth.currentSession;
    if (session == null) {
      return const AuthGate();
    } else {
      return const HomePage();
    }
  }
}

extension ContextExtension on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(this).colorScheme.error
            : Theme.of(this).snackBarTheme.backgroundColor,
      ),
    );
  }
}
