import 'dart:ui';
import 'package:enrich/widgets/buttons/rounded_text_button.dart';
import 'package:enrich/widgets/form_widget.dart';
import 'package:flutter/material.dart';

class QuestionsFormPage extends StatefulWidget {
  const QuestionsFormPage({super.key});

  @override
  State<QuestionsFormPage> createState() => _QuestionsFormPageState();
}

class _QuestionsFormPageState extends State<QuestionsFormPage> {
  final TextEditingController rendaFixaController = TextEditingController();
  final TextEditingController nomeRendaExtraController = TextEditingController();

  bool isSimPressed = false;
  bool isNaoPressed = false;
  bool showRendaVariavelForm = false;

  String rendaFixaMensal = '';
  String nomeRendaExtra = '';

  @override
  void dispose() {
    rendaFixaController.dispose();
    nomeRendaExtraController.dispose();
    super.dispose();
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
                  textAlign: TextAlign.center, // Aplica o alinhamento centralizado corretamente
                ),
              ],
            ),
            const SizedBox(height: 15),
            FormWidget(
              hintText: 'Ex.: 2000.00',
              controller: rendaFixaController,
              onChanged: (value) {
                setState(() {
                  rendaFixaMensal = value;
                });
              },
            ),
            const SizedBox(height: 30),
            const Text.rich(
              TextSpan(
                text: 'Você possui alguma fonte de\nrenda extra variável?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            // Botões Sim e Não
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botão "Sim"
                Listener(
                  onPointerDown: (_) {
                    setState(() {
                      isSimPressed = true;
                      isNaoPressed = false;
                      showRendaVariavelForm = true;
                    });
                  },
                  onPointerUp: (_) {
                    setState(() {
                      isSimPressed = false;
                    });
                  },
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isSimPressed ? Colors.green : Colors.white,
                      side: const BorderSide(color: Colors.black, width: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 50),
                      splashFactory: NoSplash.splashFactory,
                    ),
                    child: Text(
                      'Sim',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSimPressed ? Colors.white : Colors.green,
                      ),
                    ),
                  ),
                ),

                // Botão "Não"
                Listener(
                  onPointerDown: (_) {
                    setState(() {
                      isNaoPressed = true;
                      isSimPressed = false;
                      showRendaVariavelForm = false;
                    });
                  },
                  onPointerUp: (_) {
                    setState(() {
                      isNaoPressed = false;
                    });
                  },
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isNaoPressed ? Colors.red : Colors.white,
                      side: const BorderSide(color: Colors.black, width: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 50),
                      splashFactory: NoSplash.splashFactory,
                    ),
                    child: Text(
                      'Não',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isNaoPressed ? Colors.white : Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Exibe o formulário de renda variável somente se "Sim" for pressionado
            if (showRendaVariavelForm) ...[
              const Text.rich(
                TextSpan(
                  text: 'Qual o nome da sua renda variável?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              FormWidget(
                hintText: 'Ex.: Vendas de Roupas',
                controller: nomeRendaExtraController,
                onChanged: (value) {
                  setState(() {
                    nomeRendaExtra = value;
                  });
                },
              ),
            ],

            const SizedBox(height: 18),
            RoundedTextButton(
              text: 'Finalizar Cadastro',
              width: 300,
              height: 55,
              fontSize: 17,
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed('/bottom_navigation_page');
              },
            ),
            const SizedBox(height: 20),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      },
    );
  }
}
