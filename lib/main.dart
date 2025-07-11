import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page.dart';
import 'register_page.dart';

void main() => runApp(const BarberFlqApp());

class BarberFlqApp extends StatelessWidget {
  const BarberFlqApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.dark(useMaterial3: true);

    return MaterialApp(
      title: 'BarberFlq',
      theme: base.copyWith(
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: base.colorScheme.copyWith(
          primary: const Color(0xFF004D40),
          secondary: const Color(0xFF00796B),
        ),
        textTheme: GoogleFonts.openSansTextTheme(base.textTheme),
      ),
      initialRoute: '/login',
      routes: {
        '/login':    (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
      },
    );
  }
}