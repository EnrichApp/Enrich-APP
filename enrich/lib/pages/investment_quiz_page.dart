import 'package:enrich/pages/investment_quiz.dart';
import 'package:enrich/widgets/buttons/rounded_text_button.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/subtitle_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class InvestmentQuizPage extends StatelessWidget {
  const InvestmentQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leadingWidth: 100,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: GestureDetector(
          onTap: () => Navigator.of(context)
              .popUntil((route) => route.settings.name == '/investments_page'),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_ios_new, size: 14),
              SizedBox(width: 2),
              LittleText(text: 'Voltar', fontSize: 12, underlined: true),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                        'Para te fornecer sugestões personalizadas de investimentos, precisamos saber qual é o seu perfil de investidor(a). Para isso, preparamos um teste de 2 minutos.'),
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