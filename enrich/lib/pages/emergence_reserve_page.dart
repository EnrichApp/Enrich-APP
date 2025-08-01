import 'dart:convert';
import 'package:enrich/pages/questions_form_page.dart';
import 'package:enrich/utils/date_format.dart';
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

class EmergenceReservePage extends StatefulWidget {
  const EmergenceReservePage({super.key});

  @override
  State<EmergenceReservePage> createState() => _EmergenceReservePageState();
}

class _EmergenceReservePageState extends State<EmergenceReservePage> {
  double? valorTotal;
  double? valorMeta;
  bool? notificacao;
  DateTime? diaMesNotificacao;

  int paginaHistorico = 1;
  final int elementosPorPagina = 5;
  bool carregandoMais = false;
  bool chegouNoFim = false;

  List<Map<String, dynamic>> historico = [];

  @override
  void initState() {
    super.initState();
    _consultarReservaEmergencia();
    _consultarHistoricoReservaEmergencia();
  }

  void _menuOpcoes(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.blue),
            title: const Text('Editar', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.pop(_);
              _abrirModalEditarReservaEmergencia(ctx);
            },
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  void _abrirModalNotificacaoParaGuardar(BuildContext context) {
    bool notificacaoAtiva = notificacao ?? false;
    int? diaSelecionado = diaMesNotificacao?.day;
    String? erro;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Notificação para guardar',
              style: TextStyle(color: Colors.black)),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey,
                    title: const Text(
                      'Ativar notificação mensal',
                      style: TextStyle(color: Colors.black),
                    ),
                    value: notificacaoAtiva,
                    onChanged: (val) {
                      setState(() {
                        notificacaoAtiva = val;
                        erro = null;
                      });
                    },
                  ),
                  if (notificacaoAtiva)
                    DropdownButtonFormField<int>(
                      value: diaSelecionado,
                      decoration: InputDecoration(
                          labelText: 'Dia do mês (1-29)',
                          errorText: erro,
                          filled: true,
                          fillColor: Colors.white),
                      dropdownColor: Colors.white,
                      style: const TextStyle(color: Colors.black),
                      items: List.generate(29, (index) {
                        final dia = index + 1;
                        return DropdownMenuItem(
                          value: dia,
                          child: Text(dia.toString()),
                        );
                      }),
                      onChanged: (val) {
                        setState(() {
                          diaSelecionado = val;
                          erro = null;
                        });
                      },
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
                if (notificacaoAtiva && diaSelecionado == null) {
                  setState(() {
                    erro = 'Escolha um dia do mês';
                  });
                  return;
                }

                final body = {
                  "notificacao": notificacaoAtiva,
                  if (notificacaoAtiva)
                    "dia_mes_notificacao": DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      diaSelecionado!,
                    ).toIso8601String(),
                };

                try {
                  final response = await apiClient.patch(
                    'reserva-detail/',
                    body: jsonEncode(body),
                  );

                  if (response.statusCode == 200) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Configuração salva com sucesso!')),
                    );
                    await _consultarReservaEmergencia();
                  } else {
                    throw Exception();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Erro ao salvar configuração.'),
                      backgroundColor: Colors.red,
                    ),
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

  void _abrirModalEditarReservaEmergencia(BuildContext context) {
    final valorMetaController = TextEditingController();
    String valorMetaErro = '';

    showCreateObjectModal(
      context: context,
      title: 'Editar Reserva de Emergência',
      fields: [
        FormWidget(
          hintText: 'Valor da meta final',
          keyboardType: TextInputType.number,
          controller: valorMetaController,
          onChanged: (_) {
            if (valorMetaErro.isNotEmpty) valorMetaErro = '';
          },
          errorText: valorMetaErro,
        )
      ],
      onCancel: () {
        Navigator.of(context).pop();
      },
      onSave: () async {
        final valorMeta =
            double.tryParse(valorMetaController.text.trim()) ?? 0.0;

        bool valido = true;

        if (valorMeta <= 0) {
          valorMetaErro = 'Informe um valor válido para a meta';
          valido = false;
        }

        if (!valido) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Preencha o campo corretamente')),
          );
          return;
        }

        final body = {"valor_meta": valorMeta};

        try {
          final response =
              await apiClient.patch('reserva-detail/', body: jsonEncode(body));

          if (response.statusCode == 200) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Reserva editada com sucesso!')),
            );
            await _consultarReservaEmergencia();
          } else {
            throw Exception();
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'Ocorreu um erro ao editar a reserva de emergência. Tente novamente mais tarde.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
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

  Future<void> _abrirModalTransacaoReserva(
      BuildContext context, String tipoAcao) async {
    final valorController = TextEditingController();
    final double? valorAnterior = valorTotal;

    String titulo;
    String labelBotao;
    // ignore: unused_local_variable
    Color corSnack;

    if (tipoAcao == 'REMOCAO') {
      titulo = 'Valor retirado';
      labelBotao = 'Remover';
      corSnack = Colors.red;
    } else if (tipoAcao == 'RENDIMENTO') {
      titulo = 'Valor do rendimento';
      labelBotao = 'Informar';
      corSnack = Colors.green;
    } else {
      titulo = 'Valor aportado';
      labelBotao = 'Adicionar';
      corSnack = Colors.green;
    }

    await showDialog(
      context: context,
      builder: (BuildContext ctx2) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(titulo, style: const TextStyle(color: Colors.black)),
          content: TextField(
            controller: valorController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              hintText: 'Digite o valor, em reais',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx2),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final valorDigitado = double.tryParse(
                  valorController.text.replaceAll(',', '.'),
                );

                if (valorDigitado == null ||
                    valorDigitado <= 0 ||
                    valorAnterior == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Digite um valor válido.')),
                  );
                  return;
                }

                final novoValor = tipoAcao == 'REMOCAO'
                    ? valorAnterior - valorDigitado
                    : valorAnterior + valorDigitado;

                if (tipoAcao == 'REMOCAO' && novoValor < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Você não pode remover mais do que tem.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final body = {
                  "valor_total": novoValor,
                  "acao": tipoAcao,
                  "data_acao": DateTime.now().toIso8601String(),
                };

                try {
                  final response = await apiClient.patch(
                    'reserva-detail/',
                    body: jsonEncode(body),
                  );

                  if (response.statusCode == 200) {
                    Navigator.pop(ctx2);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Valor modificado com sucesso!'),
                          backgroundColor: Colors.green),
                    );
                    await _consultarReservaEmergencia();
                    await _resetarHistoricoReserva();
                  } else {
                    throw Exception();
                  }
                } catch (e) {
                  Navigator.pop(ctx2);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                          'Erro ao salvar valor. Tente novamente mais tarde'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(labelBotao),
            ),
          ],
        );
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
          notificacao = responseData['notificacao'] ?? false;
          diaMesNotificacao = responseData['dia_mes_notificacao'] != null
              ? DateTime.parse(responseData['dia_mes_notificacao'])
              : null;
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

  Future<void> _resetarHistoricoReserva() async {
    setState(() {
      historico.clear();
      paginaHistorico = 1;
      chegouNoFim = false;
    });
    await _consultarHistoricoReservaEmergencia();
  }

  Future<void> _consultarHistoricoReservaEmergencia(
      {bool carregarMaisPagina = false}) async {
    if (carregandoMais || chegouNoFim) return;

    setState(() {
      carregandoMais = true;
    });

    try {
      final responseConsulta = await apiClient.get(
        'reserva-historico/?pagina=$paginaHistorico&elementosPorPagina=$elementosPorPagina',
      );

      if (responseConsulta.statusCode == 200) {
        final data = jsonDecode(responseConsulta.body);
        final List novosRegistros = data['results'];

        if (novosRegistros.isEmpty || data['next'] == null) {
          chegouNoFim = true;
        }

        setState(() {
          historico.addAll(novosRegistros.cast<Map<String, dynamic>>());
          paginaHistorico++;
        });
      } else if (responseConsulta.statusCode == 404) {
      } else {
        throw Exception('Erro inesperado');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Erro ao consultar histórico.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        carregandoMais = false;
      });
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
                  titleText:
                      "R\$${currentValue.toStringAsFixed(2).replaceAll('.', ',')}",
                  textColor: Colors.green,
                  textSize: 18,
                  menuIcon: GestureDetector(
                    onTap: () => _menuOpcoes(context),
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
                                      ? valorMeta!
                                          .toStringAsFixed(2)
                                          .replaceAll('.', ',')
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
                            GestureDetector(
                              onTap: () => _abrirModalTransacaoReserva(
                                  context, 'ADICAO'),
                              child: LittleTextTile(
                                iconColor: Colors.green,
                                iconSize: 22,
                                text: "Informar aporte",
                                icon: CircularIcon(
                                  iconData: Icons.add,
                                  size: 26,
                                  backgroundColor: Colors.green,
                                  iconColor: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            GestureDetector(
                              onTap: () => _abrirModalTransacaoReserva(
                                  context, 'RENDIMENTO'),
                              child: LittleTextTile(
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
                            ),
                            SizedBox(height: 5),
                            GestureDetector(
                              onTap: () => _abrirModalTransacaoReserva(
                                  context, 'REMOCAO'),
                              child: LittleTextTile(
                                iconColor: Colors.red,
                                iconSize: 22,
                                text: "Informar retirada",
                                icon: CircularIcon(
                                  iconData: Icons.remove,
                                  size: 26,
                                  backgroundColor: Colors.red,
                                  iconColor: Colors.white,
                                ),
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
                GestureDetector(
                  onTap: () => _abrirModalNotificacaoParaGuardar(context),
                  child: ContainerWidget(
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
                                    "Escolha o dia do mês para ser lembrado de\nguardar dinheiro na reserva.",
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
                      SizedBox(height: 20),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: historico.length,
                        itemBuilder: (context, index) {
                          final item = historico[index];
                          final valor = item['valor'];
                          final acao = item['acao'];
                          final dataHora = FormatadorData.formatarUtcParaLocal(
                              item['data_acao']);

                          final ehAdicao =
                              acao == 'ADICAO' || acao == 'RENDIMENTO';

                          return HistoricEmergence(
                            icon: Icon(
                              ehAdicao ? Icons.add : Icons.remove,
                              color: Colors.white,
                              size: 20,
                            ),
                            typeText: acao == 'RENDIMENTO'
                                ? 'Rendimento'
                                : (ehAdicao ? 'Guardado' : 'Retirado'),
                            time: dataHora,
                            amount:
                                "${ehAdicao ? '+' : '-'} R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}",
                            amountColor: ehAdicao ? Colors.green : Colors.red,
                            fontSize: 14,
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 20),
                      ),
                      if (!chegouNoFim)
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          child: SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.grey[200],
                              ),
                              onPressed: carregandoMais
                                  ? null
                                  : () => _consultarHistoricoReservaEmergencia(
                                      carregarMaisPagina: true),
                              child: carregandoMais
                                  ? const CircularProgressIndicator()
                                  : const Text("Carregar mais"),
                            ),
                          ),
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
