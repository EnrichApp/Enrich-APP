import 'package:enrich/widgets/buttons/rounded_text_button.dart';
import 'package:enrich/widgets/form_widget.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
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
            // Campo de senha com onChanged e controller
        
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
              onPressed: () {
                //TODO: Chamada pra API
                print(email);
                print(senha);
                Navigator.of(context).pushReplacementNamed('/bottom_navigation_page');
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LittleText(text: 'Ainda não tem uma conta? '),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/register_page');
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
