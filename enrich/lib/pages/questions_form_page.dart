import 'package:enrich/widgets/buttons/rounded_text_button.dart';
import 'package:enrich/widgets/form_widget.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class QuestionsFormPage extends StatefulWidget {
  const QuestionsFormPage({super.key});

  @override
  State<QuestionsFormPage> createState() => _QuestionsFormPageState();
}

class _QuestionsFormPageState extends State<QuestionsFormPage> {
  final TextEditingController rendaFixaController = TextEditingController();
  final TextEditingController nomeRendaExtraController =
      TextEditingController();

  bool isHoveringSim = false;
  bool isHoveringNao = false;

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
        color: Theme.of(context).colorScheme.background,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Qual a sua renda fixa líquida\nmensal, em reais? ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        WidgetSpan(
                          child: Tooltip(
                            message:
                                'Renda Fixa Líquida Mensal é o valor que você recebe mensalmente após descontos de impostos e outras taxas.',
                            child: Icon(
                              Icons.info_outline,
                              size: 18, // Ajusta o tamanho do ícone
                            ),
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center, // Centraliza o texto
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
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botão "Sim"
                  MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        isHoveringSim = true;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        isHoveringSim = false;
                      });
                    },
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Lógica para o botão "Sim"
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isHoveringSim ? Colors.green : Colors.white,
                        side: const BorderSide(color: Colors.black, width: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(0), // Botão quadrado
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 50),
                      ),
                      child: Text(
                        'Sim',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isHoveringSim
                              ? Colors.white
                              : Colors.green, // Texto branco no hover
                        ),
                      ),
                    ),
                  ),

                  // Botão "Não"
                  MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        isHoveringNao = true;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        isHoveringNao = false;
                      });
                    },
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Lógica para o botão "Não"
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isHoveringNao ? Colors.red : Colors.white,
                        side: const BorderSide(color: Colors.black, width: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(0), // Botão quadrado
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 50),
                      ),
                      child: Text(
                        'Não',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isHoveringNao
                              ? Colors.white
                              : Colors.red, // Texto branco no hover
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
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
              const SizedBox(height: 18),
              RoundedTextButton(
                  text: 'Finalizar Cadastro',
                  width: 300,
                  height: 55,
                  fontSize: 17,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/home');
                  }),
              const SizedBox(height: 20),
            ]),
      ),
    );
  }
}
