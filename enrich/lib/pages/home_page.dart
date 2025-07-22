import 'package:enrich/models/caixinha.dart';
import 'package:enrich/models/financial_planning.dart';
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
  List<Caixinha>? caixinhas;
  Map<String, dynamic>? planejamentoFinanceiro;

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
    _buscarCaixinhas();
    _buscarPlanejamentoFinanceiro();
  }

  Future<void> _buscarPlanejamentoFinanceiro() async {
    final response = await apiClient.get('planejamento/listar/');
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        planejamentoFinanceiro = responseData['planejamento'];
      });
    } else if (response.statusCode == 404) {
      setState(() {
        planejamentoFinanceiro = null;
      });
    } else {
      // Erro inesperado, pode exibir um erro ou deixar como null
      setState(() {
        planejamentoFinanceiro = null;
      });
    }
  }

  Future<void> _buscarCaixinhas() async {
    try {
      final lista = await planningService.listarCaixinhas();
      setState(() {
        caixinhas = lista;
      });
    } catch (e) {
      setState(() {
        caixinhas = [];
      });
    }
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

  void _abrirModalAdicionarGanho() async {
    final nomeController = TextEditingController();
    final valorController = TextEditingController();

    // Estado para paginação
    List<Ganho> ganhos = [];
    int paginaAtual = 1;
    bool carregandoMais = false;
    bool carregouTudo = false;

    Future<void> carregarGanhos({bool mais = false}) async {
      if (carregandoMais || carregouTudo) return;
      carregandoMais = true;
      try {
        final resp =
            await planningService.listarGanhosPaginado(pagina: paginaAtual);
        final novos =
            (resp['results'] as List).map((e) => Ganho.fromJson(e)).toList();
        ganhos.addAll(novos);
        final next = resp['next'];
        carregouTudo = next == null;
        paginaAtual++;
      } catch (e) {}
      carregandoMais = false;
    }

    await carregarGanhos(); // Carrega a primeira página

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF4F4F4),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setStateModal) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: TitleText(text: 'Ganhos do mês', fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                              child: ganhos.isEmpty ? 
                              Center(
                                child: Text("Nenhum ganho registrado.",
                                    style: TextStyle(color: Colors.black)),
                              ) :
                              NotificationListener<ScrollNotification>(
                                onNotification: (scrollNotification) {
                                  if (scrollNotification
                                          is ScrollEndNotification &&
                                      scrollController.position.pixels >=
                                          scrollController
                                                  .position.maxScrollExtent -
                                              100) {
                                    if (!carregouTudo && !carregandoMais) {
                                      setStateModal(() {
                                        carregarGanhos()
                                            .then((_) => setStateModal(() {}));
                                      });
                                    }
                                  }
                                  return false;
                                },
                                child: ListView.separated(
                                  controller: scrollController,
                                  itemCount:
                                      ganhos.length + (carregouTudo ? 0 : 1),
                                  separatorBuilder: (_, __) => const Divider(
                                      height: 1, color: Colors.black),
                                  itemBuilder: (context, idx) {
                                    if (idx >= ganhos.length) {
                                      // Loader ao buscar mais
                                      return const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2)),
                                      );
                                    }
                                    final g = ganhos[idx];
                                    return ListTile(
                                      dense: true,
                                      leading: const Icon(Icons.attach_money,
                                          color: Colors.green),
                                      title: Text(g.nome,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                      trailing: Text(
                                          "R\$ ${g.quantia.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                              color: Colors.green)),
                                    );
                                  },
                                ),
                              ),
                            ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 8),
                      TitleText(text: 'Adicionar novo ganho', fontSize: 16),
                      const SizedBox(height: 6),
                      FormWidget(
                        hintText: 'Nome do Ganho',
                        controller: nomeController,
                        onChanged: (_) {},
                      ),
                      const SizedBox(height: 8),
                      FormWidget(
                        hintText: 'Valor',
                        controller: valorController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onChanged: (_) {},
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Adicionar Ganho'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () async {
                            final nome = nomeController.text.trim();
                            final valor =
                                double.tryParse(valorController.text.trim()) ??
                                    0.0;
                            if (nome.isEmpty || valor <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Preencha os campos corretamente')),
                              );
                              return;
                            }
                            try {
                              await planningService.adicionarGanho(
                                  nome: nome, quantia: valor);
                              if (mounted) Navigator.of(context).pop();
                              Provider.of<ResumoFinanceiroProvider>(context,
                                      listen: false)
                                  .buscarResumo(apiClient);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Ganho adicionado!')),
                              );
                            } catch (e) {}
                          },
                        ),
                      ),
                      SizedBox(height: 25,)
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _abrirModalAdicionarGasto() async {
    final nomeController = TextEditingController();
    final valorController = TextEditingController();
    int? caixinhaSelecionada;

    // Carrega as caixinhas ANTES de abrir o modal
    final caixinhas = await planningService.listarCaixinhas();
    if (caixinhas.isEmpty) {
      // Modal padrão se não houver caixinhas
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Crie um Planejamento Financeiro antes de registrar um gasto.',
            style: TextStyle(color: Colors.red, fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
      );
      return;
    }

    int _pagina = 1;
    bool _temMais = true;
    bool _carregando = false;
    List<Gasto> _gastos = [];
    final ScrollController _scrollController = ScrollController();

    Future<void> _carregarMais() async {
      if (_carregando || !_temMais) return;
      _carregando = true;
      try {
        final resp = await planningService.listarGastosPaginado(
          pagina: _pagina,
          elementosPorPagina: 10,
        );
        final novos = (resp['results'] as List<dynamic>)
            .map((g) => Gasto.fromJson(g as Map<String, dynamic>))
            .toList();
        _gastos.addAll(novos);
        final next = resp['next'];
        _temMais = next != null;
        if (_temMais) _pagina++;
      } catch (_) {
        // Ignore erro silenciosamente
      }
      _carregando = false;
    }

    await _carregarMais();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        await _carregarMais();
        // Força rebuild para mostrar mais itens
        (context as Element).markNeedsBuild();
      }
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollSheetController) {
            return StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text('Gastos do mês',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: _gastos.isEmpty
                            ? const Center(
                                child: Text("Nenhum gasto registrado.",
                                    style: TextStyle(color: Colors.black)),
                              )
                            : ListView.separated(
                                controller: _scrollController,
                                itemCount: _gastos.length +
                                    (_temMais ? 1 : 0), // Loader ao fim
                                separatorBuilder: (_, __) => const Divider(
                                    height: 1, color: Colors.black),
                                itemBuilder: (context, idx) {
                                  if (idx == _gastos.length && _temMais) {
                                    // Loader do fim
                                    return const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  }
                                  final g = _gastos[idx];
                                  return ListTile(
                                    dense: true,
                                    leading: const Icon(Icons.money_off,
                                        color: Colors.red),
                                    title: Text(g.nome,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    trailing: Text(
                                      "R\$ ${g.quantia.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 20),
                      const Divider(),
                      const SizedBox(height: 8),
                      const Text('Adicionar novo gasto',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      const SizedBox(height: 6),
                      FormWidget(
                        hintText: 'Nome do Gasto',
                        controller: nomeController,
                        onChanged: (_) {},
                      ),
                      const SizedBox(height: 8),
                      FormWidget(
                        hintText: 'Valor',
                        controller: valorController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
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
                                    child: Text(c
                                        .nome), // este texto é para a lista aberta
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                caixinhaSelecionada = val;
                              });
                            },
                            selectedItemBuilder: (BuildContext context) {
                              return caixinhas.map((c) {
                                final isSelected = caixinhaSelecionada == c.id;
                                return Text(
                                  c.nome,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.black,
                                  ),
                                );
                              }).toList();
                            },
                          )),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text('Adicionar Gasto',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () async {
                            final nome = nomeController.text.trim();
                            final valor =
                                double.tryParse(valorController.text.trim()) ??
                                    0.0;
                            if (nome.isEmpty ||
                                valor <= 0 ||
                                caixinhaSelecionada == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Preencha todos os campos corretamente')),
                              );
                              return;
                            }
                            try {
                              await planningService.adicionarGasto(
                                nome: nome,
                                quantia: valor,
                                caixinhaId: caixinhaSelecionada!,
                              );
                              if (ctx.mounted) Navigator.of(ctx).pop();
                              Provider.of<ResumoFinanceiroProvider>(context,
                                      listen: false)
                                  .buscarResumo(apiClient);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Gasto adicionado!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Erro: $e')),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void handlePlanningNavigation() async {
    final response = await apiClient.get('planejamento/listar/');
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final planejamento = responseData['planejamento'];
      final nome = (planejamento?['nome'] ?? '').toString().trim();

      if (nome == 'Método das 6 Jarras' || nome == '50-30-20') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FinancialPlanningPage(),
          ),
        ).then((_) => _buscarPlanejamentoFinanceiro());
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomFinancialPlanningPage(),
          ),
        ).then((_) => _buscarPlanejamentoFinanceiro());
      }
    } else if (response.statusCode == 404) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChooseFinancialPlanningPage(),
        ),
      ).then((_) => _buscarPlanejamentoFinanceiro());
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
      throw Exception('Erro ao buscar Obrigações Financeiras.');
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
                    content: Builder(
                      builder: (context) {
                        if (planejamentoFinanceiro == null) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 5),
                            child: LittleText(
                              text: "Nenhum planejamento foi criado.",
                            ),
                          );
                        }
                        if (caixinhas == null) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (caixinhas!.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "Nenhuma categoria cadastrada.",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.orange),
                            ),
                          );
                        }

                        Color getCaixinhaColor(int idx) {
                          final cores = [
                            Color(0xFFF82E52), // Essenciais
                            Color(0xFFFFCE06), // Lazer
                            Color(0xFF2D8BBA), // Investimentos
                            Color(0xFF5FAF46), // Educação
                            Color(0xFFCB6CE6), // Obrigações
                            Colors.grey, // ...
                          ];
                          return cores[idx % cores.length];
                        }

                        final bool temMais = caixinhas!.length > 4;
                        final displayCaixinhas =
                            temMais ? caixinhas!.take(3).toList() : caixinhas!;

                        final chartData = [
                          ...displayCaixinhas.asMap().entries.map((entry) =>
                              ChartData(
                                  entry.value.nome,
                                  entry.value.porcentagem,
                                  getCaixinhaColor(entry.key))),
                          if (temMais) ChartData("...", 0.0, Colors.grey),
                        ];

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 110,
                              width: 100,
                              child: SfCircularChart(
                                legend: Legend(isVisible: false),
                                series: <CircularSeries>[
                                  PieSeries<ChartData, String>(
                                    dataSource: chartData,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y,
                                    pointColorMapper: (ChartData data, _) =>
                                        data.color,
                                    dataLabelSettings:
                                        DataLabelSettings(isVisible: false),
                                  )
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...displayCaixinhas
                                    .asMap()
                                    .entries
                                    .map((entry) => LittleListTile(
                                          circleColor:
                                              getCaixinhaColor(entry.key),
                                          category: entry.value.nome,
                                          percentage:
                                              "${entry.value.porcentagem.toStringAsFixed(0)}%",
                                        )),
                                if (temMais)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 1, bottom: 2),
                                    child: Text(
                                      "...",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            )
                          ],
                        );
                      },
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
                    titleText: "Obrigações Financeiras",
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
                                        text:
                                            "Nenhuma obrigação financeira encontrada.")
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
