import 'package:enrich/widgets/texts/subtitle_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class InviteFriendsPage extends StatelessWidget {
  const InviteFriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const TitleText(
          text: "Convidar Amigos",
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
              text: 'Convide seus amigos para usar o Enrich!',
              fontSize: 18,
              textAlign: TextAlign.center
            ),
            const SizedBox(height: 16.0),
            const SubtitleText(
              text: 'Compartilhe o link abaixo com seus amigos e ajude-os a melhorar suas finanças com o Enrich.Me!',
            ),
            const SizedBox(height: 16.0),

            // Exemplo de link a ser compartilhado
            const SelectableText(
              'https://enrich.me/invite?ref=12345',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 16.0),

            // Botão de compartilhar o link
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Ação para compartilhar o link
                  Share.share(
                    'Ei! Eu estou usando o Enrich para organizar minhas finanças. Junte-se a mim: https://enrich.me/invite?ref=12345',
                  );
                },
                icon: const Icon(Icons.share),
                label: const Text('Compartilhar Link'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
