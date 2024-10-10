import 'package:enrich/widgets/texts/subtitle_text.dart';
import 'package:flutter/material.dart';

import '../widgets/buttons/rounded_text_button.dart';
import '../widgets/form_widget.dart';
import '../widgets/texts/title_text.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  // Controllers para os TextFormFields
  final TextEditingController codigoVerificacaoController = TextEditingController();

  // Variáveis para armazenar os valores dos campos
  String codigoVerificacao = '';

  @override
  void dispose() {
    codigoVerificacaoController.dispose();
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
              const TitleText(text: 'Verifique seu e-mail'),
              const SizedBox(height: 15),
              const Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: SubtitleText(text: 'Um e-mail foi enviado para {email} com um código de verificação. Por favor, insira-o no campo abaixo:'),
              ),
              const SizedBox(height: 15),
              FormWidget(
                hintText: 'Ex.: 123456',
                controller: codigoVerificacaoController,
                onChanged: (value) {
                  setState(() {
                    codigoVerificacao = value;
                  });
                },
              ),
              const SizedBox(height: 15),
              RoundedTextButton(
                  text: 'Validar E-mail',
                  width: 300,
                  height: 55,
                  fontSize: 17,
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/info_to_user_page');
                  }),
            ]),
      ),
    );
  }
}