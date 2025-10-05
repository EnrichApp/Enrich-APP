import 'dart:convert';
import 'package:enrich/pages/forgot_password_page.dart';
import 'package:enrich/pages/investments_page.dart';
import 'package:enrich/pages/questions_form_page.dart';
import 'package:enrich/pages/verify_email_page.dart';
import 'package:enrich/pages/info_to_user_page.dart';
import 'package:enrich/pages/login_page.dart';
import 'package:enrich/pages/register_page.dart';
import 'package:enrich/providers/resumo_financeiro_provider.dart';
import 'package:enrich/themes/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enrich/pages/navigation/bottom_navigation_page.dart';
import 'package:enrich/utils/api_base_client.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  
  await initializeDateFormatting('pt_BR', null);
  String initialRoute = await determinarRotaInicial();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ResumoFinanceiroProvider()),
      ],
      child: Enrich(initialRoute: initialRoute),
    ),
  );
}

class Enrich extends StatelessWidget {
  final String initialRoute;

  const Enrich({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', ''), // fallback se necessário
      ],
      routes: {
        '/': (context) => const LoginPage(),
        '/register_page': (context) => const RegisterPage(),
        '/verify_email_page': (context) => const VerifyEmailPage(),
        '/info_to_user_page': (context) => const InfoToUserPage(),
        '/questions_form_page': (context) => const QuestionsFormPage(),
        '/bottom_navigation_page': (context) => const BottomNavigationPage(),
        '/investments_page': (context) => const InvestmentsPage(),
        '/forgot_password_page': (context) => const ForgotPasswordPage(),
      },
    );
  }
}

Future<String> determinarRotaInicial() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('enrichAppAuthToken');

  if (token == null) {
    return '/';
  }

  final bool tokenValido = await validarToken(token);

  if (tokenValido) {
    return '/bottom_navigation_page';
  } else {
    return '/';
  }
}

Future<bool> validarToken(String token) async {
  try {
    final response = await ApiBaseClient().post(
      'authentication/token/validate/',
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
