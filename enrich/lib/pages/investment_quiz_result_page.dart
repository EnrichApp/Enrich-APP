import 'dart:convert';

import 'package:enrich/pages/investment_quiz_page.dart';
import 'package:enrich/pages/investments_page.dart';
import 'package:enrich/utils/api_base_client.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:flutter/material.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:enrich/widgets/buttons/rounded_text_button.dart';

class InvestmentQuizResultPage extends StatelessWidget {
  final String perfil;
  final List<String> sugestoes;
  final bool jaSalvo;

  InvestmentQuizResultPage(
      {super.key,
      required this.perfil,
      required this.sugestoes,
      this.jaSalvo = false});

  Color _getPerfilColor(String perfil) {
    switch (perfil.toLowerCase()) {
      case 'conservador':
        return Colors.green.shade700;
      case 'moderado':
        return Colors.amber.shade800;
      case 'arrojado':
        return Colors.red.shade600;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _getPerfilIcon(String perfil) {
    switch (perfil.toLowerCase()) {
      case 'conservador':
        return Icons.shield;
      case 'moderado':
        return Icons.trending_up;
      case 'arrojado':
        return Icons.whatshot;
      default:
        return Icons.insights;
    }
  }

  final ApiBaseClient apiClient = ApiBaseClient();

  Future<void> _salvarPerfil(BuildContext context) async {
    try {
      final response = await apiClient.post(
        'investimento/perfil_investidor/',
        body: jsonEncode({'perfil': perfil}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil de investidor salvo com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context)
            .popUntil((route) => route.settings.name == '/investments_page');
      } else {
        final erro = jsonDecode(response.body);
        final msg =
            erro['perfil']?.first ?? 'Erro ao salvar o perfil de investidor.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao salvar o perfil de investidor.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final perfilColor = _getPerfilColor(perfil);
    final perfilIcon = _getPerfilIcon(perfil);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: GestureDetector(
          onTap: () => Navigator.of(context)
              .popUntil((route) => route.settings.name == '/investments_page'),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_ios_new, size: 14),
              SizedBox(width: 2),
              LittleText(text: 'Voltar', fontSize: 12, underlined: true),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(perfilIcon, size: 72, color: perfilColor),
              ),
              const SizedBox(height: 20),
              Center(
                child: TitleText(
                  text: 'Seu perfil de investidor(a) é:',
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  perfil,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: perfilColor,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TitleText(text: 'Sugestões de investimento:', fontSize: 18),
              const SizedBox(height: 10),
              ...sugestoes.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              jaSalvo
                  ? Center(
                      child: RoundedTextButton(
                        text: 'Refazer teste',
                        fontSize: 16,
                        buttonColor: Theme.of(context).colorScheme.tertiary,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => InvestmentQuizPage()),
                        ),
                        width: 360,
                        height: 50,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundedTextButton(
                          text: 'Refazer teste',
                          fontSize: 16,
                          buttonColor: Theme.of(context).colorScheme.tertiary,
                          onPressed: () => Navigator.of(context).pop(),
                          width: 200,
                          height: 50,
                        ),
                        const SizedBox(width: 10),
                        RoundedTextButton(
                          text: 'Salvar',
                          fontSize: 16,
                          buttonColor: Colors.green.shade700,
                          onPressed: () => _salvarPerfil(context),
                          width: 150,
                          height: 50,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
