import 'package:enrich/models/caixinha.dart';
import 'package:enrich/pages/credit_cards_invoice_page.dart';
import 'package:enrich/pages/custom_financial_planning_page.dart';
import 'package:enrich/pages/debts_page.dart';
import 'package:enrich/pages/emergence_reserve_page.dart';
import 'package:enrich/pages/choose_financial_planning_page.dart';
import 'package:enrich/pages/financial_planning_page.dart';
import 'package:enrich/pages/goals_page.dart';
import 'package:enrich/pages/reports_page.dart';
import 'package:enrich/providers/resumo_financeiro_provider.dart';
import 'package:enrich/services/cartao_service.dart';
import 'package:enrich/services/financial_planning_service.dart';
import 'package:enrich/widgets/create_object_widget.dart';
import 'package:enrich/widgets/floating_action_menu.dart';
import 'package:enrich/widgets/form_widget.dart';
import 'package:enrich/widgets/home_page_divida_widget.dart';
import 'package:enrich/widgets/texts/amount_text.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../widgets/home_page_widget.dart';
import '../widgets/little_list_tile.dart';
import '../widgets/texts/title_text.dart';
import 'package:enrich/utils/api_base_client.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? nomeUsuario;
  final ApiBaseClient apiClient = ApiBaseClient();
  late final FinancialPlanningService planningService;
  List<dynamic>? metas;
  List<dynamic>? dividas;
  double? valorTotalReserva = 0.0;
  double? valorMetaReserva = 0.0;
  List<dynamic>? faturasCartao;

  @override
  void initState() {
    super.initState();
    planningService = FinancialPlanningService(apiClient);
    _initResumoFinanceiro();
    _buscarNomeUsuario();
    _buscarMetas();
    _buscarDividas();
    _consultarReservaEmergencia();
    _buscarFaturasCartao();
  }

  void _initResumoFinanceiro() {
    final provider =
        Provider.of<ResumoFinanceiroProvider>(context, listen: false);
    provider.buscarResumo(apiClient);
  }

  String get mesAnoAtual {
    final data = DateFormat('MMMM \'de\' y', 'pt_BR').format(DateTime.now());
    return data[0].toUpperCase() + data.substring(1);
  }

  void _abrirModalAdicionarGanho() {
    final nomeController = TextEditingController();
    final valorController = TextEditingController();

    showCreateObjectModal(
      context: context,
      title: 'Adicionar Ganho',
      fields: [
        FormWidget(
          hintText: 'Nome do Ganho',
          controller: nomeController,
          onChanged: (_) {},
        ),
        FormWidget(
          hintText: 'Valor',
          controller: valorController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) {},
        ),
      ],
      onSave: () async {
        final nome = nomeController.text.trim();
        final valor = double.tryParse(valorController.text.trim()) ?? 0.0;

        if (nome.isEmpty || valor <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Preencha os campos corretamente')),
          );
          return;
        }
        try {
          await planningService.adicionarGanho(nome: nome, quantia: valor);
          Provider.of<ResumoFinanceiroProvider>(context, listen: false)
              .buscarResumo(apiClient);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ganho adicionado!')),
          );
        } catch (e) {}
      },
    );
  }

  void _abrirModalAdicionarGasto() {
    final nomeController = TextEditingController();
    final valorController = TextEditingController();
    int? caixinhaSelecionada;

    // Carrega as caixinhas ANTES de abrir o modal
    planningService.listarCaixinhas().then((caixinhas) {
      showCreateObjectModal(
        context: context,
        title: 'Adicionar Gasto',
        fields: caixinhas.isEmpty
            ? [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Crie um Planejamento Financeiro antes de registrar um gasto.',
                    style: TextStyle(color: Colors.red, fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ),
              ]
            : [
                FormWidget(
                  hintText: 'Nome do Gasto',
                  controller: nomeController,
                  onChanged: (_) {},
                ),
                FormWidget(
                  hintText: 'Valor',
                  controller: valorController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) {},
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 4),
                  child: DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Caixinha',
                      border: OutlineInputBorder(),
                    ),
                    isExpanded: true,
                    value: caixinhaSelecionada,
                    items: caixinhas
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.nome),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      caixinhaSelecionada = val;
                    },
                  ),
                ),
              ],
        onSave: () async {
          // Impede salvar caso não haja caixinhas
          if (caixinhas.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'Crie um Planejamento Financeiro para registrar um gasto.')),
            );
            return;
          }

          final nome = nomeController.text.trim();
          final valor = double.tryParse(valorController.text.trim()) ?? 0.0;

          if (nome.isEmpty || valor <= 0 || caixinhaSelecionada == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Preencha todos os campos corretamente')),
            );
            return;
          }
          try {
            await planningService.adicionarGasto(
              nome: nome,
              quantia: valor,
              caixinhaId: caixinhaSelecionada!,
            );
            Provider.of<ResumoFinanceiroProvider>(context, listen: false)
                .buscarResumo(apiClient);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Gasto adicionado!')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro: $e')),
            );
          }
        },
      );
    });
  }

  void handlePlanningNavigation() async {
    final response = await apiClient.get('planejamento/listar/');
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final planejamento = responseData['planejamento'];
      final nome = (planejamento?['nome'] ?? '').toString().trim();

      // Compare nome para saber se é template ou personalizado
      if (nome == 'Método das 6 Jarras' || nome == '50-30-20') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FinancialPlanningPage(),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomFinancialPlanningPage(),
          ),
        );
      }
    } else if (response.statusCode == 404) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChooseFinancialPlanningPage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao consultar planejamento financeiro.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _buscarNomeUsuario() async {
    final response = await apiClient.get(
      'profile/primeiro_nome/',
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        nomeUsuario = responseData['primeiro_nome'];
      });
    } else {
      throw Exception('Erro ao buscar o nome do usuário.');
    }
  }

  Future<void> _buscarMetas() async {
    final response = await apiClient.get('metas/listar/');
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        metas = responseData is List
            ? responseData.cast<Map<String, dynamic>>()
            : [];
      });
    } else {
      throw Exception('Erro ao buscar Metas.');
    }
  }

  Future<void> _buscarDividas() async {
    final response = await apiClient.get('debts/listar/');
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        // converte para List<Map<...>>
        dividas = responseData is List
            ? responseData.cast<Map<String, dynamic>>()
            : [];

        // ➊ prioridade: Em atraso → Pendente → resto
        const prioridade = ['Em atraso', 'Pendente'];

        dividas!.sort((a, b) {
          int idxA = prioridade.indexOf(a['status'] ?? '');
          int idxB = prioridade.indexOf(b['status'] ?? '');

          // quem não é "Em atraso" nem "Pendente" recebe peso maior
          if (idxA == -1) idxA = prioridade.length;
          if (idxB == -1) idxB = prioridade.length;

          return idxA.compareTo(idxB);
        });
      });
    } else {
      throw Exception('Erro ao buscar Dívidas.');
    }
  }

  Future<void> _consultarReservaEmergencia() async {
    try {
      final responseConsulta = await apiClient.get('reserva-detail/');

      if (responseConsulta.statusCode == 200) {
        final responseData = jsonDecode(responseConsulta.body);

        setState(() {
          valorTotalReserva = responseData['valor_total'] ?? 0.0;
          valorMetaReserva = responseData['valor_meta'] ?? 0.0;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Ocorreu um erro ao consultar a sua reserva de emergência. Tente novamente mais tarde.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _buscarFaturasCartao() async {
    final service = CartaoService();
    try {
      final lista = await service.listar();

      // Prioridade: Em atraso > Data próxima
      const prioridade = ['Em atraso', 'Data próxima'];

      lista.sort((a, b) {
        int idxA = prioridade.indexOf(a.status);
        int idxB = prioridade.indexOf(b.status);

        if (idxA == -1) idxA = prioridade.length;
        if (idxB == -1) idxB = prioridade.length;

        return idxA.compareTo(idxB);
      });

      setState(() {
        faturasCartao = lista.take(2).toList();
      });
    } catch (e) {
      // Trate erros de forma apropriada
      print('Erro ao buscar faturas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final resumoProvider = Provider.of<ResumoFinanceiroProvider>(context);

    final List<ChartData> chartData = [
      ChartData('David', 25),
      ChartData('Steve', 38),
      ChartData('Jack', 34),
      ChartData('Others', 52)
    ];

    final double valorAtualReservaEmergencia = valorTotalReserva ?? 0.0;
    final double valorMetaReservaEmergencia = valorMetaReserva ?? 1;
    final double progressoReservaEmergencia =
        (valorMetaReserva != null && valorMetaReserva! > 0)
            ? valorAtualReservaEmergencia / valorMetaReserva!
            : 0.0;

    return Scaffold(
        floatingActionButton: FloatingActionMenu(
          onAdicionarGanho: _abrirModalAdicionarGanho,
          onAdicionarGasto: _abrirModalAdicionarGasto,
        ),
        body: Container(
          color: Theme.of(context).colorScheme.onSurface,
          child: ListView(padding: EdgeInsets.zero, children: [
            Container(
              color: Theme.of(context).colorScheme.onSurface,
              child: Column(
                children: [
                  Container(
                    height: 330,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          TitleText(
                            text: 'Olá, ${nomeUsuario ?? 'Usuário'}!',
                            fontSize: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SubtitleText(
                                text: '$mesAnoAtual - ',
                                fontSize: 13,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ReportsPage()),
                                  );
                                },
                                child: TitleText(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    text: 'Exibir relatórios',
                                    fontSize: 13,
                                    sublined: true),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          ListTile(
                            leading: Icon(Icons.north,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 30),
                            title: Row(
                              children: [
                                LittleText(text: 'Ganhos:  '),
                                TitleText(
                                  color: Theme.of(context).colorScheme.primary,
                                  text:
                                      "R\$${resumoProvider.ganhos.toStringAsFixed(2)}",
                                  fontSize: 17,
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.south,
                                color: Theme.of(context).colorScheme.surface,
                                size: 30),
                            title: Row(
                              children: [
                                LittleText(text: 'Gastos:  '),
                                TitleText(
                                  color: Theme.of(context).colorScheme.surface,
                                  text:
                                      'R\$${resumoProvider.gastos.toStringAsFixed(2)}',
                                  fontSize: 17,
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.wallet_sharp,
                              color: Colors.black,
                              size: 30,
                            ),
                            title: Row(
                              children: [
                                LittleText(text: 'Total:  '),
                                TitleText(
                                  text:
                                      'R\$${resumoProvider.total.toStringAsFixed(2)}',
                                  fontSize: 17,
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                  const SizedBox(height: 30),
                  HomePageWidget(
                    titleText: "Planejamento Financeiro",
                    onPressed: handlePlanningNavigation,
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 110,
                          width: 100,
                          child: SfCircularChart(series: <CircularSeries>[
                            PieSeries<ChartData, String>(
                                dataSource: chartData,
                                pointColorMapper: (ChartData data, _) =>
                                    data.color,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y)
                          ]),
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LittleListTile(
                              circleColor: Color(0xFFF82E52),
                              category: "Essenciais",
                              percentage: "55%",
                            ),
                            LittleListTile(
                              circleColor: Color(0xFFFFCE06),
                              category: "Lazer",
                              percentage: "10%",
                            ),
                            LittleListTile(
                              circleColor: Color(0xFF2D8BBA),
                              category: "Investimentos",
                              percentage: "20%",
                            ),
                            LittleListTile(
                              circleColor: Color(0xFF5FAF46),
                              category: "Educação",
                              percentage: "5%",
                            ),
                            LittleListTile(
                              circleColor: Color(0xFFCB6CE6),
                              category: "Dívidas",
                              percentage: "10%",
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  HomePageWidget(
                    titleText: "Metas",
                    content: Padding(
                      padding: const EdgeInsets.only(left: 17.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: metas == null
                            ? [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2), // Loading
                                )
                              ]
                            : metas!.isEmpty
                                ? [LittleText(text: "Nenhuma meta foi criada.")]
                                : metas!.take(3).map((meta) {
                                    final nome =
                                        meta['nome'] ?? 'Meta sem nome';
                                    final porcentagem =
                                        meta['porcentagem_meta'] ?? 0.0;
                                    return LittleText(
                                      text:
                                          "- $nome: ${porcentagem.toStringAsFixed(0)}%",
                                      fontSize: 12,
                                    );
                                  }).toList(),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GoalsPage()),
                      ).then((_) => _buscarMetas());
                    },
                  ),
                  SizedBox(height: 20),
                  HomePageWidget(
                    titleText: "Dívidas",
                    content: Padding(
                      padding: const EdgeInsets.only(left: 17.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: dividas == null
                            ? [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              ]
                            : dividas!.isEmpty
                                ? [
                                    LittleText(
                                        text: "Nenhuma dívida encontrada.")
                                  ]
                                : dividas!.take(2).map((d) {
                                    final String status =
                                        d['status'] ?? 'Sem status';
                                    final String nome = d['nome'] ?? 'Sem nome';
                                    final String? raw = d['data_vencimento'];

                                    String dataFmt = '';
                                    if (raw != null) {
                                      final dt = DateTime.tryParse(raw);
                                      if (dt != null) {
                                        dataFmt =
                                            '${dt.day.toString().padLeft(2, '0')}/'
                                            '${dt.month.toString().padLeft(2, '0')}/'
                                            '${dt.year}';
                                      }
                                    }

                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 7.0),
                                      child: HomePageDividaWidget(
                                        category: status,
                                        debtName:
                                            '- $nome${dataFmt.isNotEmpty ? ': $dataFmt' : ''}',
                                      ),
                                    );
                                  }).toList(),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DebtsPage()),
                      ).then((_) => _buscarDividas());
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  HomePageWidget(
                    titleText: "Faturas de Cartão",
                    content: Padding(
                      padding: const EdgeInsets.only(left: 17.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: faturasCartao == null
                            ? [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              ]
                            : faturasCartao!.isEmpty
                                ? [
                                    LittleText(
                                        text: "Nenhuma fatura encontrada.")
                                  ]
                                : faturasCartao!.map((c) {
                                    final dataFmt =
                                        '${c.dataFinal.day.toString().padLeft(2, '0')}/'
                                        '${c.dataFinal.month.toString().padLeft(2, '0')}/'
                                        '${c.dataFinal.year}';

                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 7.0),
                                      child: HomePageDividaWidget(
                                        category: c.status,
                                        debtName: "- ${c.nome}: $dataFmt",
                                      ),
                                    );
                                  }).toList(),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const CreditCardsInvoicePage()),
                      ).then((_) => _buscarFaturasCartao());
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  HomePageWidget(
                      titleText: "Reserva de Emergência",
                      content: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, top: 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AmountText(
                                    amount: valorAtualReservaEmergencia != null
                                        ? valorAtualReservaEmergencia!
                                            .toStringAsFixed(2)
                                            .replaceAll('.', ',')
                                        : "0,00"),
                                Row(
                                  children: [
                                    const LittleText(
                                      text: "de ",
                                      fontSize: 8,
                                      textAlign: TextAlign.start,
                                    ),
                                    AmountText(
                                      amount: valorMetaReservaEmergencia != null
                                          ? valorMetaReservaEmergencia!
                                              .toStringAsFixed(2)
                                              .replaceAll('.', ',')
                                          : "0,00",
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
                                      value: progressoReservaEmergencia,
                                      backgroundColor: Colors.grey[300],
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                        Colors.green,
                                      ),
                                      minHeight: 6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const EmergenceReservePage()),
                        ).then((_) => _consultarReservaEmergencia());
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  HomePageWidget(
                      titleText: "Investimentos",
                      content: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, top: 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    AmountText(
                                      amount: '29.657,92',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                    LittleText(
                                      fontSize: 8,
                                      text: '  investidos',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TitleText(
                                      text: 'Próximo investimento programado:',
                                      fontSize: 13,
                                    ),
                                    LittleText(
                                      text: '05/10/2024',
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/investments_page');
                      }),
                  SizedBox(height: 90),
                ],
              ),
            ),
          ]),
        ));
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}
