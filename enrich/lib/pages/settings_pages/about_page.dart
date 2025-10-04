import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, // Altere para a cor desejada
        ),
        title: const TitleText(
          text: "Sobre",
          color: Colors.black,
        ),
        backgroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título da página
            Text(
              'Enrich',
              style: TextStyle(
                color: Colors.black,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),

            // Descrição do aplicativo
            Text(
              textAlign: TextAlign.justify,
              'O Enrich é um aplicativo de gestão financeira pessoal desenvolvido para ajudar você a mudar '
              'sua vida financeira. Nossa promessa é que você comece a investir dinheiro e '
              'alcance suas metas financeiras rapidamente, com um plano personalizado baseado em suas condições atuais.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                wordSpacing: 1.5,
              ),
            ),
            SizedBox(height: 8.0),

            // Missão do aplicativo
            Text(
              'Nossa Missão',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              textAlign: TextAlign.justify,
              'No Enrich, nossa missão é oferecer uma solução prática e eficiente para você organizar suas '
              'finanças, sair das dívidas e alcançar suas metas de investimento de forma sustentável e acessível.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                wordSpacing: 1.5,
              ),
            ),
            SizedBox(height: 16.0),

            // Contato
            Text(
              'Entre em Contato',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              textAlign: TextAlign.justify,
              'Se tiver dúvidas ou sugestões, entre em contato conosco através do e-mail: enrichapptech@gmail.com',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                wordSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
