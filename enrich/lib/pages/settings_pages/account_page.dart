import 'package:enrich/models/settings.dart';
import 'package:enrich/pages/settings_pages/change_password_page.dart';
import 'package:enrich/services/settings_service.dart';
import 'package:enrich/widgets/texts/subtitle_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  void _abrirModalAlterarRenda(BuildContext context) {
    final controller = TextEditingController();
    String erro = '';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Alterar renda',
              style: TextStyle(color: Colors.black)),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Nova renda (R\$)',
                      errorText: erro.isEmpty ? null : erro,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final renda =
                    double.tryParse(controller.text.replaceAll(',', '.'));
                if (renda == null || renda <= 0) {
                  setState(() => erro = 'Informe um valor válido');
                  return;
                }

                final service = AtualizarRendaService();
                final result = await service
                    .updateIncome(UpdateIncomeModel(rendaLiquidaFixa: renda));

                if (result == null) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: Color(0xFF16804C),
                        content: Text('Renda atualizada com sucesso!')),
                  );
                } else {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Erro ao Atualizar renda."), backgroundColor: Colors.red),
                  );
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildListTile(BuildContext context, String title, Widget? page,
      {bool isDelete = false, bool isAlterarRenda = false}) {
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
                context,
                MaterialPageRoute(builder: (context) => page),
              );
            } else if (isAlterarRenda) {
              _abrirModalAlterarRenda(context);
            }
          },
        ),
        const Divider(height: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
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
            _buildListTile(context, "Alterar senha", ChangePasswordPage()),
            _buildDivider(),
            _buildListTile(context, "Alterar renda", null,
                isAlterarRenda: true),
            _buildDivider(),
            _buildListTile(context, "Excluir conta", null, isDelete: true),
            _buildDivider(),
          ],
        ),
      ),
    );
  }
}

void _showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const TitleText(
          text: "Confirmar exclusão",
          fontSize: 18,
        ),
        content: const SubtitleText(
            text: "Tem certeza que deseja excluir sua conta?"),
        actions: <Widget>[
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Excluir"),
            onPressed: () async {
              Navigator.of(context).pop(); // Fecha o diálogo

              final service = ExcluirContaService();
              final errorMessage = await service.deleteAccount();

              if (context.mounted) {
                if (errorMessage == null) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs
                      .clear(); // Remove token e outras informações locais

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Conta excluída com sucesso!')),
                  );

                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage)),
                  );
                }
              }
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
