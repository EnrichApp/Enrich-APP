import 'package:enrich/utils/api_base_client.dart';
import 'package:enrich/widgets/buttons/rounded_text_button.dart';
import 'package:enrich/widgets/form_widget.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers para os TextFormFields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  // Variáveis para armazenar os valores dos campos
  String email = '';
  String senha = '';

  final ApiBaseClient apiClient = ApiBaseClient();

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future<void> realizarLogin(String email, String senha) async {
    try {
      final response = await apiClient.post(
        'authentication/token/',
        body: jsonEncode({'username': email, 'password': senha}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['access'];
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('enrichAppAuthToken', token);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Login bem-sucedido!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pushReplacementNamed('/bottom_navigation_page');
      } else if (response.statusCode == 401) {
        final data = jsonDecode(response.body);
        final code = data['detail'];

        if (code == 'USUARIO_NAO_VERIFICADO') {
          await apiClient.post(
            'profile/enviar_codigo_verificacao/',
            body: jsonEncode({'email': email}),
          );

          Navigator.of(context)
              .pushNamed('/verify_email_page', arguments: {'email': email});
        } else if (code == 'CADASTRO_INCOMPLETO') {
          Navigator.of(context)
              .pushNamed('/info_to_user_page');
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Usuário ou senha inválidos.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Ocorreu algum erro. Tente novamente mais tarde.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.onSurface,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              './assets/images/logo_enrich.png',
              height: 160,
            ),
            const SizedBox(height: 25),
            const TitleText(text: 'Faça seu login'),
            const SizedBox(height: 20),
            FormWidget(
              hintText: 'Digite o seu e-mail.',
              controller: emailController,
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
            ),
            const SizedBox(height: 12),
            FormWidget(
              hintText: 'Digite a sua senha.',
              obscureText: true,
              controller: senhaController,
              onChanged: (value) {
                setState(() {
                  senha = value;
                });
              },
            ),
            const SizedBox(height: 12),
            RoundedTextButton(
              text: 'Acessar',
              width: 300,
              height: 55,
              fontSize: 17,
              onPressed: () async {
                if (email != '' && senha != '') {
                  await realizarLogin(email, senha);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          'Os campos de e-mail e senha devem ser preenchidos.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LittleText(text: 'Ainda não tem uma conta? '),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed('/register_page');
                  },
                  child: LittleText(
                    text: 'Clique aqui.',
                    color: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
