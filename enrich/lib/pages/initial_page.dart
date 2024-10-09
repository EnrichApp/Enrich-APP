import 'package:enrich/widgets/buttons/rounded_text_button.dart';
import 'package:enrich/widgets/form_widget.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  // Controllers para os TextFormFields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  // Variáveis para armazenar os valores dos campos
  String email = '';
  String senha = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Image.asset(
                './assets/images/logo_enrich.png',
                height: 160,
              ),
              const SizedBox(height: 25),
              const TitleText(text: 'Faça seu login'),
              const SizedBox(height: 20),
              // Campo de e-mail com onChanged e controller
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
                  // Ações quando o botão for pressionado
                  print('E-mail');
                  print('Senha: $senha');
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
      ),
    );
  }

  @override
  void dispose() {
    // Libera os controladores quando o widget for removido
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }
}
