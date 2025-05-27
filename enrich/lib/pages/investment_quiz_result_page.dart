import 'package:flutter/material.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:enrich/widgets/buttons/rounded_text_button.dart';

class InvestmentQuizResultPage extends StatelessWidget {
  final String perfil;
  final List<String> sugestoes;

  const InvestmentQuizResultPage({
    super.key,
    required this.perfil,
    required this.sugestoes,
  });

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

  @override
  Widget build(BuildContext context) {
    final perfilColor = _getPerfilColor(perfil);
    final perfilIcon = _getPerfilIcon(perfil);

    return Scaffold(
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
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: RoundedTextButton(
                  fontSize: 16,
                  buttonColor: Theme.of(context).colorScheme.tertiary, 
                  text: 'Voltar ao início',
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  width: 260,
                  height: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
