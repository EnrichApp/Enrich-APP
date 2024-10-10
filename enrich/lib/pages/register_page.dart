import 'package:enrich/widgets/buttons/rounded_text_button.dart';
import 'package:enrich/widgets/form_widget.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers para os TextFormFields
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmacaoSenhaController =
      TextEditingController();

  // Variáveis para armazenar os valores dos campos
  String nome = '';
  String email = '';
  String senha = '';
  String confirmacaoSenha = '';

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmacaoSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TitleText(text: 'Faça seu cadastro'),
              const SizedBox(height: 30),
              FormWidget(
                hintText: 'Digite o seu primeiro nome.',
                controller: nomeController,
                onChanged: (value) {
                  setState(() {
                    nome = value;
                  });
                },
              ),
              const SizedBox(height: 15),
              FormWidget(
                hintText: 'Digite o seu e-mail.',
                controller: emailController,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              const SizedBox(height: 15),
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
              const SizedBox(height: 15),
              FormWidget(
                hintText: 'Confirme a sua senha.',
                obscureText: true,
                controller: confirmacaoSenhaController,
                onChanged: (value) {
                  setState(() {
                    confirmacaoSenha = value;
                  });
                },
              ),
              const SizedBox(height: 15),
              RoundedTextButton(
                  text: 'Prosseguir',
                  width: 300,
                  height: 55,
                  fontSize: 17,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/verify_email_page');
                  }),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LittleText(text: 'Já tem uma conta? '),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: LittleText(
                      text: 'Clique aqui.',
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                ],
              )
            ]),
      ),
    );
  }
}
