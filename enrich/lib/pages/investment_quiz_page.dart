import 'package:enrich/pages/investment_quiz.dart';
import 'package:enrich/widgets/buttons/rounded_text_button.dart';
import 'package:enrich/widgets/texts/subtitle_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class InvestmentQuizPage extends StatelessWidget {
  const InvestmentQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.onSurface, iconTheme: IconThemeData(color: Colors.black),),
      body: Container(
        color: Theme.of(context).colorScheme.onSurface,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TitleText(text: 'Perfil de Investidor'),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: SubtitleText(
                    text:
                        'Olá, Amanda! Para te fornecer sugestões personalizadas de investimentos, precisamos saber qual é o seu perfil de investidor(a). Para isso, preparamos um teste de 2 minutos.'),
              ),
              const SizedBox(height: 15),
              const SubtitleText(text: ' Está pronto(a) para começar?'),
              const SizedBox(height: 15),
              RoundedTextButton(
                  buttonColor: Theme.of(context).colorScheme.tertiary,
                  text: 'Sim, estou pronto(a)!',
                  width: 300,
                  height: 55,
                  fontSize: 17,
                  onPressed: () {
                    Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const QuizScreen()),
                              );
                  }),
            ]),
      ),
    );
  }
}