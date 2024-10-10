import 'package:enrich/widgets/texts/subtitle_text.dart';
import 'package:flutter/material.dart';

import '../widgets/buttons/rounded_text_button.dart';
import '../widgets/texts/title_text.dart';

class InfoToUserPage extends StatelessWidget {
  const InfoToUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TitleText(text: 'Olá, {Usuário}'),
              const SizedBox(height: 15),
              const Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: const SubtitleText(text: 'Para te ajudarmos a melhorar a sua vida financeira, precisaremos de algumas informações sobre a sua renda atual.'),
              ),
              const SizedBox(height: 15),
              RoundedTextButton(
                  text: 'Prosseguir',
                  width: 300,
                  height: 55,
                  fontSize: 17,
                  onPressed: () {}),
            ]),
      ),
    );
  }
}