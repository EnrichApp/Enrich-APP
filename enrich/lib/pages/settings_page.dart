import 'package:enrich/pages/login_page.dart';
import 'package:enrich/pages/settings_pages/about_page.dart';
import 'package:enrich/pages/settings_pages/account_page.dart';
import 'package:enrich/pages/settings_pages/invite_friend_page.dart';
import 'package:enrich/pages/settings_pages/rate_us_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
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
              _buildListTile(context, 'Conta', AccountPage(), false),
              _buildDivider(),
              _buildListTile(context, 'Sobre', AboutPage(), false),
              _buildDivider(),
              _buildListTile(context, 'Convidar amigos', InviteFriendsPage(), false),
              _buildDivider(),
              _buildListTile(context, 'Avalie-nos', RateUsPage(), false),
              _buildDivider(),
              _buildListTile(context, 'Sair', LoginPage(), true)
            ],
          ),
        ),
      ),
    );
  }
}

// Função auxiliar para construir os itens da lista
Widget _buildListTile(
    BuildContext context, String title, Widget page, bool backToLogin) {
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
        onTap: () async {
          if (backToLogin) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('enrichAppAuthToken');

            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => page));
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => page));
          }
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
