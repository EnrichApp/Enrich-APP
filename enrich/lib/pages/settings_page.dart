import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.background, // Cor de fundo da tela
      appBar: AppBar(
        title: const Text('Configurações',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // Ajusta a largura
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20), // Bordas arredondadas
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Sombra
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildListTile(context, 'Conta', ContaPage()),
              _buildDivider(),
              _buildListTile(context, 'Ajuda', AjudaPage()),
              _buildDivider(),
              _buildListTile(context, 'Tela', TelaPage()),
              _buildDivider(),
              _buildListTile(context, 'Sobre', SobrePage()),
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
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
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
class ContaPage extends StatelessWidget {
  const ContaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conta'),
      ),
      body: const Center(
        child: Text('Página de Conta'),
      ),
    );
  }
}

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