import 'package:enrich/pages/settings_pages/about_page.dart';
import 'package:enrich/pages/settings_pages/account_page.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.onSurface, // Cor de fundo da tela
      appBar: AppBar(
        title: const Text('Configurações',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildListTile(context, 'Conta', AccountPage()),
              _buildDivider(),
              _buildListTile(context, 'Sobre', AboutPage()),
              _buildDivider(),
              _buildListTile(context, 'Convidar amigos', ConvidarAmigosPage()),
              _buildDivider(),
              _buildListTile(context, 'Notificações', NotificacoesPage()),
              _buildDivider(),
              _buildListTile(context, 'Avalie-nos', AvalieNosPage()),
            ],
          ),
        ),
      ),
    );
  }
}

// Função auxiliar para construir os itens da lista
Widget _buildListTile(BuildContext context, String title, Widget page) {
  return Column(
    children: [
      ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
      ),
      const Divider(height: 1),
    ],
  );
}

Widget _buildDivider() {
  return const Divider(
    height: 1,
    thickness: 1,
    color: Colors.black,
  );
}

// Páginas temporárias


class AjudaPage extends StatelessWidget {
  const AjudaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajuda'),
      ),
      body: const Center(
        child: Text('Página de Ajuda'),
      ),
    );
  }
}

class TelaPage extends StatelessWidget {
  const TelaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela'),
      ),
      body: const Center(
        child: Text('Página de Tela'),
      ),
    );
  }
}

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
      ),
      body: const Center(
        child: Text('Página Sobre Nós'),
      ),
    );
  }
}

class ConvidarAmigosPage extends StatelessWidget {
  const ConvidarAmigosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Convidar Amigos'),
      ),
      body: const Center(
        child: Text('Página para Convidar Amigos'),
      ),
    );
  }
}

class NotificacoesPage extends StatelessWidget {
  const NotificacoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
      ),
      body: const Center(
        child: Text('Página de Notificações'),
      ),
    );
  }
}

class AvalieNosPage extends StatelessWidget {
  const AvalieNosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avalie-nos'),
      ),
      body: const Center(
        child: Text('Página para Avaliações'),
      ),
    );
  }
}
