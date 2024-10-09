import 'package:enrich/widgets/buttons/rounded_text_button.dart';
import 'package:enrich/widgets/form_widget.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
              const FormWidget(hintText: 'Digite o seu primeiro nome.'),
              const SizedBox(height: 15),
              const FormWidget(hintText: 'Digite o seu e-mail.'),
              const SizedBox(height: 15),
              const FormWidget(
                hintText: 'Digite a sua senha.',
                obscureText: true,
              ),
              const SizedBox(height: 15),
              const FormWidget(
                hintText: 'Confirme a sua senha.',
                obscureText: true,
              ),
              const SizedBox(height: 15),
              RoundedTextButton(
                  text: 'Prosseguir',
                  width: 300,
                  height: 55,
                  fontSize: 17,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/email_confirm_page');
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
