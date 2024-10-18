import 'package:enrich/widgets/buttons/rounded_text_button.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class InvestmentQuizResultPage extends StatelessWidget {
  const InvestmentQuizResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.onSurface,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TitleText(text: 'Seu perfil de investidor(a) é {Resultado}.'),
              const SizedBox(height: 15),
              RoundedTextButton(
                  text: 'Ver sugestões de investimento personalizadas',
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