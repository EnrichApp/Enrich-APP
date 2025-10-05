import 'package:enrich/widgets/buttons/rounded_text_button.dart';
import 'package:enrich/widgets/form_widget.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  String email = '';
  String erroEmail = '';

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> solicitarRecuperacaoSenha(String email) async {
    // TODO: Implementar chamada ao service de recuperação de senha
    // Exemplo:
    // await PasswordRecoveryService.sendRecoveryEmail(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.onSurface,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Digite o e-mail cadastrado para recuperar sua senha',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                FormWidget(
                  hintText: 'E-mail',
                  controller: emailController,
                  errorText: erroEmail,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    setState(() {
                      email = value;
                      erroEmail = '';
                    });
                  },
                ),
                const SizedBox(height: 30),
                RoundedTextButton(
                  text: 'Recuperar Senha',
                  width: 300,
                  height: 55,
                  fontSize: 17,
                  onPressed: () async {
                    if (email.isNotEmpty && email.contains('@')) {
                      await solicitarRecuperacaoSenha(email);
                    } else {
                      setState(() {
                        erroEmail = 'Insira um e-mail válido.';
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
