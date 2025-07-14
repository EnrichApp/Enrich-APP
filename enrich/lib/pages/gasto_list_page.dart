import 'package:enrich/models/financial_planning.dart';
import 'package:flutter/material.dart';
import '../services/financial_planning_service.dart';
import '../utils/api_base_client.dart';

class GastoListPage extends StatefulWidget {
  final int caixinhaId;
  final String caixinhaNome;

  const GastoListPage({
    Key? key,
    required this.caixinhaId,
    required this.caixinhaNome,
  }) : super(key: key);

  @override
  State<GastoListPage> createState() => _GastoListPageState();
}

class _GastoListPageState extends State<GastoListPage> {
  bool loading = true;
  String? errorMsg;
  List<Gasto> gastos = [];

  @override
  void initState() {
    super.initState();
    carregarGastos();
  }

  Future<void> carregarGastos() async {
    setState(() {
      loading = true;
      errorMsg = null;
    });
    try {
      gastos = await FinancialPlanningService(ApiBaseClient())
          .listarGastosDaCaixinha(widget.caixinhaId);
      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        errorMsg = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).colorScheme.onSurface;
    final highlight = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "Gastos de ${widget.caixinhaNome}",
          style: const TextStyle(color: Colors.black),
        ),
        leading: const BackButton(color: Colors.black),
        elevation: 1,
      ),
      backgroundColor: bgColor,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : errorMsg != null
              ? Center(
                  child: Text(errorMsg!,
                      style: const TextStyle(fontSize: 16, color: Colors.red)),
                )
              : gastos.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 14),
                          Text(
                            "Nenhum gasto registrado ainda.",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total de gastos: R\$ ${gastos.fold<double>(0, (sum, g) => sum + g.quantia).toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: highlight,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.separated(
                              itemCount: gastos.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, idx) {
                                final g = gastos[idx];
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                  elevation: 2,
                                  shadowColor: Colors.black12,
                                  child: ListTile(
                                    leading: Container(
                                      decoration: BoxDecoration(
                                        color: highlight.withOpacity(0.14),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: const Icon(
                                        Icons.attach_money,
                                        color: Colors.green,
                                      ),
                                    ),
                                    title: Text(
                                      g.nome,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    trailing: Text(
                                      "R\$ ${g.quantia.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
