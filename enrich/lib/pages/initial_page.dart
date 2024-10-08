import 'package:enrich/widgets/buttons/rounded_text_button.dart';
import 'package:enrich/widgets/form_widget.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});
  //Pendente: quando teclado abrir, evitar problema de overflow
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                './assets/images/logo_enrich.png',
                height: 300,
              ),
              const TitleText(text: 'Faça seu login'),
              const SizedBox(height: 20),
              const FormWidget(hintText: 'Digite o seu e-mail.'),
              const SizedBox(height: 12),
              const FormWidget(
                hintText: 'Digite a sua senha.',
                obscureText: true,
              ),
              const SizedBox(height: 12),
              RoundedTextButton(
                  text: 'Acessar',
                  width: 300,
                  height: 55,
                  fontSize: 17,
                  onPressed: () {}),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LittleText(text: 'Ainda não tem uma conta? '),
                  GestureDetector(
                    onTap: () {
                      //Ir para página Cadastro
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
