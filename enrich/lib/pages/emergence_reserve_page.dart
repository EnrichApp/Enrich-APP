import 'dart:convert';
import 'package:enrich/pages/questions_form_page.dart';
import 'package:enrich/widgets/circular_icon.dart';
import 'package:enrich/widgets/container_widget.dart';
import 'package:enrich/widgets/create_object_widget.dart';
import 'package:enrich/widgets/form_widget.dart';
import 'package:enrich/widgets/historic_emergence.dart';
import 'package:enrich/widgets/home_page_widget.dart';
import 'package:enrich/widgets/little_text_tile.dart';
import 'package:enrich/widgets/texts/amount_text.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/subtitle_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmergenceReservePage extends StatefulWidget {
  const EmergenceReservePage({super.key});

  @override
  State<EmergenceReservePage> createState() => _EmergenceReservePageState();
}

class _EmergenceReservePageState extends State<EmergenceReservePage> {
  
  double? valorTotal;
  double? valorMeta;

  @override
  void initState() {
    super.initState();
    _consultarReservaEmergencia();
  }

  void _abrirModalCriarReservaEmergencia(BuildContext context) {
    final valorMetaController = TextEditingController();
    final valorTotalController = TextEditingController();
    String valorMetaErro = '';
    String valorTotalErro = '';

    showCreateObjectModal(
      context: context,
      title: 'Nova Reserva de Emergência',
      fields: [
        FormWidget(
          hintText: 'Valor da meta final',
          keyboardType: TextInputType.number,
          controller: valorMetaController,
          onChanged: (_) {
            if (valorMetaErro.isNotEmpty) valorMetaErro = '';
          },
          errorText: valorMetaErro,
        ),
        FormWidget(
          hintText: 'Quanto você já tem guardado?',
          keyboardType: TextInputType.number,
          controller: valorTotalController,
          onChanged: (_) {
            if (valorTotalErro.isNotEmpty) valorTotalErro = '';
          },
          errorText: valorTotalErro,
        ),
      ],
      onCancel: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
      onSave: () async {
        final valorMeta =
            double.tryParse(valorMetaController.text.trim()) ?? 0.0;
        final valorTotal =
            double.tryParse(valorTotalController.text.trim()) ?? -1;

        bool valido = true;

        if (valorMeta <= 0) {
          valorMetaErro = 'Informe um valor válido para a meta';
          valido = false;
        }

        if (valorTotal < 0) {
          valorTotalErro = 'Informe quanto você já tem guardado (0 ou mais)';
          valido = false;
        }

        if (!valido) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Preencha todos os campos corretamente')),
          );
          return;
        }

        final body = {
          "valor_meta": valorMeta,
          "valor_total": valorTotal,
          "notificacao": false
        };

        try {
          final response =
              await apiClient.post('reserva/', body: jsonEncode(body));
          if (response.statusCode == 201) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Reserva criada com sucesso!')),
            );
            await _consultarReservaEmergencia();
          } else {
            throw Exception();
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'Ocorreu um erro ao criar a reserva de emergência. Tente novamente mais tarde.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  Future<void> _consultarReservaEmergencia() async {
    try {
      final responseConsulta = await apiClient.get('reserva-detail/');

      if (responseConsulta.statusCode == 200) {
        final responseData = jsonDecode(responseConsulta.body);
        
        setState(() {
          valorTotal = responseData['valor_total'] ?? 0.0;
          valorMeta = responseData['valor_meta'] ?? 0.0;
        });
      } else if (responseConsulta.statusCode == 404) {
        _abrirModalCriarReservaEmergencia(context);
      } else {
        throw Exception(
            'Erro inesperado. Código: ${responseConsulta.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Ocorreu um erro ao consultar a reserva de emergência. Tente novamente mais tarde.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definindo o lucro atual e a meta
    final double currentValue = valorTotal ?? 0.0;
    final double targetValue = valorMeta ?? 1;
    final double progress = currentValue / targetValue;


    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 14,
              ),
              SizedBox(width: 2),
              LittleText(
                text: 'Voltar',
                fontSize: 12,
                underlined: true,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.onSurface,
        child: SingleChildScrollView(
          // Use SingleChildScrollView para evitar problemas de aninhamento
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                TitleText(
                  text: 'Reserva de Emergência',
                  fontSize: 20,
                ),
                const SizedBox(height: 10),
                HomePageWidget(
                  width: MediaQuery.of(context).size.width * 0.9,
                  titleText: "R\$${currentValue.toStringAsFixed(2).replaceAll('.', ',')}",
                  textColor: Colors.green,
                  textSize: 18,
                  menuIcon: GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.more_vert, size: 22),
                  ),
                  content: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const LittleText(
                                  text: "de ",
                                  fontSize: 8,
                                  textAlign: TextAlign.start,
                                ),
                                AmountText(
                                  amount: valorMeta != null
                                      ? valorMeta!.toStringAsFixed(2).replaceAll('.', ',')
                                      : "0,00",
                                  fontSize: 8,
                                  color: Colors.black87,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Barra de progresso
                            SizedBox(
                              width: 250,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    10), // Canto arredondado
                                child: LinearProgressIndicator(
                                  value: progress, // Progresso atual
                                  backgroundColor:
                                      Colors.grey[300], // Cor de fundo
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                    Colors.green,
                                  ), // Cor do progresso
                                  minHeight: 6, // Altura da barra
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            // Opções para adicionar, informar rendimento e remover dinheiro
                            LittleTextTile(
                              iconColor: Colors.green,
                              iconSize: 22,
                              text: "Adicionar dinheiro",
                              icon: CircularIcon(
                                iconData: Icons.add,
                                size: 26,
                                backgroundColor: Colors.green,
                                iconColor: Colors.white,
                              ),
                            ),
                            SizedBox(height: 5),
                            LittleTextTile(
                              iconColor: Colors.green,
                              iconSize: 22,
                              text: "Informar rendimento",
                              icon: CircularIcon(
                                iconData: Icons.show_chart,
                                size: 26,
                                backgroundColor: Colors.green,
                                iconColor: Colors.white,
                              ),
                            ),
                            SizedBox(height: 5),
                            LittleTextTile(
                              iconColor: Colors.red,
                              iconSize: 22,
                              text: "Remover dinheiro",
                              icon: CircularIcon(
                                iconData: Icons.remove,
                                size: 26,
                                backgroundColor: Colors.red,
                                iconColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  showSeeMoreText: false,
                  height: 180,
                  onPressed: () {},
                ),
                const SizedBox(height: 20),
                ContainerWidget(
                  height: 70,
                  width: MediaQuery.of(context).size.width * 0.9,
                  content: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 15.0, top: 9),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleText(
                              text: "Notificação para guardar",
                              fontSize: 16,
                            ),
                            SubtitleText(
                              text:
                                  "Escolha o valor mensal a guardar e o dia para\nser notificado.",
                              fontSize: 9,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 15.0),
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleText(
                        text: "Histórico da Reserva",
                        fontSize: 16,
                      ),
                      SizedBox(height: 10),
                      SubtitleText(
                        text: "27 de setembro - R\$54,90",
                        fontSize: 12,
                      ),
                      SizedBox(height: 10),
                      // Use um ListView.builder para gerar o histórico de maneira dinâmica
                      ListView.builder(
                        shrinkWrap:
                            true, // Para que o ListView não tente ocupar mais espaço
                        physics:
                            NeverScrollableScrollPhysics(), // Impede a rolagem do ListView interno
                        itemCount:
                            1, // Altere para o número real de itens no histórico
                        itemBuilder: (context, index) {
                          return HistoricEmergence(
                            icon:
                                Icon(Icons.add, color: Colors.white, size: 20),
                            typeText: "Guardado",
                            time: "11h45",
                            amount: "+ R\$ 14,90",
                            amountColor: Colors.green,
                            fontSize: 14,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}
