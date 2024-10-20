import 'package:enrich/widgets/texts/subtitle_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RateUsPage extends StatelessWidget {
  const RateUsPage({super.key});

  // Função para abrir o link no navegador
  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://m.youtube.com/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Não foi possível abrir o link $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, // Altere para a cor desejada
        ),
        title: const TitleText(
          text: "Avalie-nos",
          color: Colors.black,
        ),
        backgroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const TitleText(
              text: 'Gostou do Enrich? Avalie-nos!',
              fontSize: 18,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            const SubtitleText(
              text: 'Sua avaliação é importante para continuarmos melhorando e oferecendo uma experiência financeira personalizada.',
            ),
            const SizedBox(height: 16.0),

            // Botão de Avaliação
            Center(
              child: ElevatedButton(
                onPressed: _launchUrl, // Abre o link de avaliação
                child: const Text('Avaliar o Enrich'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
