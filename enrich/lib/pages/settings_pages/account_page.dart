import 'package:enrich/pages/settings_pages/change_password_page.dart';
import 'package:enrich/widgets/texts/subtitle_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, // Altere para a cor desejada
        ),
        title: const TitleText(
          text: "Conta",
          color: Colors.black,
        ),
        backgroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildDivider(),
            _buildListTile(context, "Alterar senha", ChangePasswordPage()),
            _buildDivider(),
            _buildListTile(context, "Excluir conta", null, isDelete: true),
            _buildDivider(),
          ],
        ),
      ),
    );
  }
}

Widget _buildListTile(BuildContext context, String title, Widget? page, {bool isDelete = false}) {
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
          if (isDelete) {
            _showConfirmationDialog(context);
          } else if (page != null) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => page));
          }
        },
      ),
      const Divider(height: 1),
    ],
  );
}

void _showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const TitleText(text: "Confirmar exclusão", fontSize: 18,),
        content: const SubtitleText(text: "Tem certeza que deseja excluir sua conta?"),
        actions: <Widget>[
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Excluir"),
            onPressed: () {
              Navigator.of(context).pop();
              //TODO lógica para excluir a conta
              Navigator.of(context).pushNamed("/");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Conta excluída com sucesso!')),
              );
            },
          ),
        ],
      );
    },
  );
}

Widget _buildDivider() {
  return const Divider(
    height: 1,
    thickness: 1,
    color: Colors.black,
  );
}
