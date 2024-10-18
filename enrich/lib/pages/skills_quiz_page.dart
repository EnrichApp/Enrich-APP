import 'package:enrich/widgets/buttons/rounded_text_button.dart';
import 'package:enrich/widgets/texts/subtitle_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class SkillsQuizPage extends StatelessWidget {
  const SkillsQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.onSurface,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TitleText(text: 'Teste de Habilidades e Competências'),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: SubtitleText(
                    text:
                        'Olá, Amanda! Para te fornecer sugestões personalizadas de fontes de renda extra, precisamos saber qual é o seu perfil profissional e o que pode ser aproveitado das suas habilidades e competências para ganhar dinheiro extra. Para isso, preparamos um teste de 5 minutos.'),
              ),
              const SizedBox(height: 15),
              const SubtitleText(text: 'Está pronto(a) para começar?'),
              const SizedBox(height: 15),
              RoundedTextButton(
                  text: 'Sim, estou pronto(a)!',
                  width: 300,
                  height: 55,
                  fontSize: 17,
                  onPressed: () {
                    Navigator.of(context).pushNamed('');
                  }),
            ]),
      ),
    );
  }
}