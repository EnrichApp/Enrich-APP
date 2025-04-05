import 'dart:ui';
import 'dart:convert';
import 'package:enrich/widgets/buttons/rounded_text_button.dart';
import 'package:enrich/widgets/form_widget.dart';
import 'package:flutter/material.dart';
import 'package:enrich/utils/api_base_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionsFormPage extends StatefulWidget {
  const QuestionsFormPage({super.key});

  @override
  State<QuestionsFormPage> createState() => _QuestionsFormPageState();
}

final ApiBaseClient apiClient = ApiBaseClient();

class _QuestionsFormPageState extends State<QuestionsFormPage> {
  final TextEditingController rendaFixaController = TextEditingController();

  String rendaFixaMensal = '';
  String erroRendaFixa = '';

  @override
  void dispose() {
    rendaFixaController.dispose();
    super.dispose();
  }

  Future<void> atualizarRendaFixa(double renda) async {
    try {
      final response = await apiClient.patch(
        'profile/me/',
        body: jsonEncode({
          'renda_liquida_fixa_mensal': renda,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Cadastro finalizado!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context)
          .pushReplacementNamed('/bottom_navigation_page');
      } else {
        throw Exception();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erro ao atualizar a renda.'),
            backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.onSurface,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Qual a sua renda fixa líquida\nmensal, em reais? ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            _showInfoDialog(
                              context,
                              'Renda Fixa Líquida Mensal é o valor que você recebe mensalmente após descontos de impostos e outras taxas.',
                            );
                          },
                          child: Icon(
                            Icons.info_outline,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign
                      .center, // Aplica o alinhamento centralizado corretamente
                ),
              ],
            ),
            const SizedBox(height: 15),
            FormWidget(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              hintText: 'Ex.: 2000,00',
              controller: rendaFixaController,
              errorText: erroRendaFixa,
              onChanged: (value) {
                setState(() {
                  rendaFixaMensal = value;
                });
              },
            ),
            const SizedBox(height: 30),
            RoundedTextButton(
              text: 'Finalizar Cadastro',
              width: 300,
              height: 55,
              fontSize: 17,
              onPressed: () async {
                if (rendaFixaMensal.isNotEmpty) {
                  final renda =
                      double.tryParse(rendaFixaMensal.replaceAll(',', '.'));
                  if (renda != null) {
                    await atualizarRendaFixa(renda);
                  }
                }
                else {
                  setState(() {
                    erroRendaFixa = 'Insira uma renda válida.';
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String infoText) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AlertDialog(
            backgroundColor: Colors.white,
            content: Text(
              infoText,
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      },
    );
  }
}
