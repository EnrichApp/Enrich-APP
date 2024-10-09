import 'package:enrich/widgets/texts/subtitle_text.dart';
import 'package:flutter/material.dart';

import '../widgets/buttons/rounded_text_button.dart';
import '../widgets/form_widget.dart';
import '../widgets/texts/title_text.dart';

class EmailConfirmPage extends StatelessWidget {
  const EmailConfirmPage({super.key});

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
              const SubtitleText(text: 'Um e-mail foi enviado para amandalreis@me.com com um código de verificação. Por favor, insira-o no campo abaixo.'),
              const SizedBox(height: 15),
              const FormWidget(hintText: 'Ex.: 123456 '),
              const SizedBox(height: 15),
              RoundedTextButton(
                  text: 'Validar E-mail',
                  width: 300,
                  height: 55,
                  fontSize: 17,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/info_to_user_page');
                  }),
            ]),
      ),
    );
  }
}