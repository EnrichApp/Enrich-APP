import 'package:enrich/pages/skills_quiz.dart';
import 'package:enrich/widgets/buttons/rounded_text_button.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/subtitle_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class SkillsQuizPage extends StatelessWidget {
  const SkillsQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 14,
              ),
              SizedBox(width: 2),
              LittleText(
                text: 'Voltar',
                fontSize: 12,
                underlined: true,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.onSurface,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TitleText(text: 'Teste de Habilidades e Competências', textAlign: TextAlign.center,),
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
                    Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SkillsQuiz()),
                              );
                  }),
            ]),
      ),
    );
  }
}