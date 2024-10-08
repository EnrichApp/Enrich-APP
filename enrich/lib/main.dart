import 'package:enrich/pages/initial_page.dart';
import 'package:enrich/pages/register_page.dart';
import 'package:enrich/themes/theme_data.dart';
import 'package:flutter/material.dart';

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
        '/': (context) => const InitialPage(),
        '/register_page': (context) => const RegisterPage(),
      },
    );
  }
}
