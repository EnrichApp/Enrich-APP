import 'package:enrich/widgets/texts/subtitle_text.dart';
import 'package:enrich/widgets/buttons/rounded_text_button.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class InfoToUserPage extends StatelessWidget {
  const InfoToUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.onSurface,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TitleText(text: 'Olá!'),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: SubtitleText(
                text:
                    'Para te ajudarmos a melhorar a sua vida financeira, precisaremos de algumas informações sobre a sua renda atual.',
              ),
            ),
            const SizedBox(height: 15),
            RoundedTextButton(
              text: 'Prosseguir',
              width: 300,
              height: 55,
              fontSize: 17,
              onPressed: () {
                Navigator.of(context).pushNamed('/questions_form_page');
              },
            ),
          ],
        ),
      ),
    );
  }
}
