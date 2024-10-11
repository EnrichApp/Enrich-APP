import 'package:enrich/pages/verify_email_page.dart';
import 'package:enrich/pages/info_to_user_page.dart';
import 'package:enrich/pages/login_page.dart';
import 'package:enrich/pages/register_page.dart';
import 'package:enrich/themes/theme_data.dart';
import 'package:flutter/material.dart';

import 'pages/navigation/bottom_navigation_page.dart';

void main() {
  runApp(const Enrich());
}

class Enrich extends StatelessWidget {
  const Enrich({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register_page': (context) => const RegisterPage(),
        '/verify_email_page': (context) => const VerifyEmailPage(),
        '/info_to_user_page': (context) => const InfoToUserPage(),
        '/bottom_navigation_page': (context) => const BottomNavigationPage(),
      },
    );
  }
}
