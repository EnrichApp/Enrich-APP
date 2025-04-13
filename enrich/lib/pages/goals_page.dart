import 'dart:convert';
import 'package:enrich/utils/api_base_client.dart';
import 'package:enrich/widgets/create_object_widget.dart';
import 'package:enrich/widgets/dotted_button.dart';
import 'package:enrich/widgets/form_widget.dart';
import 'package:enrich/widgets/home_page_widget.dart';
import 'package:enrich/widgets/little_text_tile.dart';
import 'package:enrich/widgets/texts/amount_text.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController valorMetaController = TextEditingController();

  List<dynamic>? metas;
  bool carregandoMetas = true;

  @override
  void initState() {
    super.initState();
    _buscarMetas();
  }

  Future<void> _buscarMetas() async {
    try {
      final response = await ApiBaseClient().get('metas/listar/');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          metas = data;
          carregandoMetas = false;
        });
      } else {
        throw Exception('Erro ao buscar metas');
      }
    } catch (e) {
      print('Erro ao buscar metas: $e');
      setState(() {
        carregandoMetas = false;
      });
    }
  }

  void _abrirModalNovaMeta(BuildContext context) {
    final nomeController = TextEditingController();
    final valorMetaController = TextEditingController();
    String nomeErro = '';
    String valorErro = '';

    showCreateObjectModal(
      context: context,
      title: 'Nova Meta',
      fields: [
        FormWidget(
          hintText: 'Nome da Meta',
          controller: nomeController,
          onChanged: (_) {
            if (nomeErro.isNotEmpty) {
              nomeErro = '';
            }
          },
          errorText: nomeErro,
        ),
        FormWidget(
          hintText: 'Valor da Meta',
          keyboardType: TextInputType.number,
          controller: valorMetaController,
          onChanged: (_) {
            if (valorErro.isNotEmpty) {
              valorErro = '';
            }
          },
          errorText: valorErro,
        ),
      ],
      onSave: () async {
        final nome = nomeController.text.trim();
        final valor = double.tryParse(valorMetaController.text) ?? 0.0;

        bool valido = true;

        if (nome.isEmpty) {
          nomeErro = 'Informe o nome da meta';
          valido = false;
        }

        if (valor <= 0) {
          valorErro = 'Informe um valor válido';
          valido = false;
        }

        if (!valido) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Preencha todos os campos corretamente'),
            ),
          );
          return;
        }

        final body = {
          "nome": nome,
          "valor_meta": valor,
        };

        try {
          final response = await ApiBaseClient().post('metas/', body: jsonEncode(body));
          if (response.statusCode == 201 || response.statusCode == 200) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Meta criada com sucesso!')),
            );
            await _buscarMetas();
          } else {
            print('Erro: ${response.body}');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Erro ao salvar a meta')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro inesperado: $e')),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 14),
              SizedBox(width: 2),
              LittleText(text: 'Voltar', fontSize: 12, underlined: true),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 20.0),
            child: TitleText(text: 'Metas', fontSize: 20),
          ),
          const SizedBox(height: 20),

          if (carregandoMetas)
            const Center(child: CircularProgressIndicator())
          else if (metas == null || metas!.isEmpty)
            const Center(child: LittleText(text: 'Nenhuma meta cadastrada.'))
          else
            ...metas!.map((meta) {
              final nome = meta['nome'] ?? 'Meta sem nome';
              final valorMeta = meta['valor_meta'] ?? 0.0;
              final total = meta['total'] ?? 0.0;
              final progresso = meta['porcentagem_meta'] ?? 0.0;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: HomePageWidget(
                  titleText: nome,
                  menuIcon: GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.more_vert, size: 22),
                  ),
                  content: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AmountText(
                              amount: 'R\$ ${total.toStringAsFixed(2)}',
                              fontSize: 18,
                            ),
                            Row(
                              children: [
                                const LittleText(
                                  text: "de ",
                                  fontSize: 8,
                                  textAlign: TextAlign.start,
                                ),
                                AmountText(
                                  amount: 'R\$ ${valorMeta.toStringAsFixed(2)}',
                                  fontSize: 8,
                                  color: Colors.black87,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: progresso / 100,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.green,
                                  ),
                                  minHeight: 6,
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                LittleTextTile(
                                  iconColor: Colors.green,
                                  text: "Adicionar dinheiro",
                                  icon: Icon(Icons.add_circle_sharp),
                                  iconSize: 24,
                                  fontSize: 9,
                                ),
                                SizedBox(width: 5),
                                LittleTextTile(
                                  iconColor: Colors.red,
                                  text: "Remover dinheiro",
                                  icon: Icon(Icons.remove_circle_sharp),
                                  iconSize: 24,
                                  fontSize: 9,
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: TitleText(
                                    text: "${progresso.toStringAsFixed(0)}%",
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  showSeeMoreText: false,
                  onPressed: () {},
                ),
              );
            }).toList(),
          const SizedBox(height: 10),
          DottedButton(
            onPressed: () => _abrirModalNovaMeta(context),
            icon: const Icon(Icons.add_circle_outline),
            text: "Adicionar nova meta",
            textSize: 14,
            iconSize: 20,
          ),
        ],
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