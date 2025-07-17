import 'dart:convert';
import 'package:enrich/utils/api_base_client.dart';
import 'package:enrich/utils/date_format.dart';
import 'package:enrich/widgets/buttons/rounded_text_button.dart';
import 'package:enrich/widgets/create_object_widget.dart';
import 'package:enrich/widgets/dotted_button.dart';
import 'package:enrich/widgets/form_widget.dart';
import 'package:enrich/widgets/home_page_widget.dart';
import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/subtitle_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DebtsPage extends StatefulWidget {
  const DebtsPage({super.key});
  @override
  State<DebtsPage> createState() => _DebtsPageState();
}

class _DebtsPageState extends State<DebtsPage> {
  List<Map<String, dynamic>> debts = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _buscarDebts();
  }

  Future<void> _buscarDebts() async {
    final r = await ApiBaseClient().get('debts/listar/');
    if (r.statusCode == 200) {
      debts = List<Map<String, dynamic>>.from(jsonDecode(r.body));
    }
    setState(() => loading = false);
  }

  Future<void> _quitarParcela(int id) async {
    final r = await ApiBaseClient().post('debts/$id/pagar/');
    if (r.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parcela paga!')),
      );
      await _buscarDebts();
    }
  }

  void _abrirModalEditarDivida(BuildContext ctx, Map<String, dynamic> d) {
    final nomeCtrl = TextEditingController(text: d['nome']);
    final valorCtrl = TextEditingController(text: d['valor'].toString());
    final qtdCtrl = TextEditingController(text: d['quantidade'].toString());
    final dataCtrl =
        TextEditingController(text: d['data_vencimento'].toString());
    showCreateObjectModal(
      context: ctx,
      title: 'Editar Obrigação Financeira',
      fields: [
        FormWidget(hintText: 'Nome', controller: nomeCtrl, onChanged: (_) {}),
        FormWidget(
            hintText: 'Valor',
            controller: valorCtrl,
            keyboardType: TextInputType.number,
            onChanged: (_) {}),
        FormWidget(
            hintText: 'Parcelas',
            controller: qtdCtrl,
            keyboardType: TextInputType.number,
            onChanged: (_) {}),
        FormWidget(
            hintText: 'Data vencimento (01/01/2025)',
            controller: dataCtrl,
            keyboardType: TextInputType.datetime,
            onChanged: (_) {}),
      ],
      onSave: () async {
        final body = <String, dynamic>{};
        if (nomeCtrl.text.trim() != d['nome'])
          body['nome'] = nomeCtrl.text.trim();
        if (valorCtrl.text.trim() != d['valor'].toString())
          body['valor'] = double.tryParse(valorCtrl.text) ?? 0;
        if (qtdCtrl.text.trim() != d['quantidade'].toString())
          body['quantidade'] = int.tryParse(qtdCtrl.text) ?? 0;
        if (dataCtrl.text.trim() != d['data_vencimento'])
          body['data_vencimento'] = ddMMyyyyToIso(dataCtrl.text.trim());
        if (body.isEmpty) return;
        final r = await ApiBaseClient()
            .patch('debts/${d['id']}/', body: jsonEncode(body));
        if (r.statusCode == 200) {
          Navigator.pop(ctx);
          await _buscarDebts();
        }
      },
    );
  }

  Future<void> _softDeleteDebt(BuildContext ctx, int id) async {
    final ok = await showDialog<bool>(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('Excluir obrigação financeira?',
            style: TextStyle(color: Colors.black)),
        content: const Text('Isto excluirá esta obrigação da lista.',
            style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(_, false),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () => Navigator.pop(_, true),
              child: const Text('Excluir')),
        ],
      ),
    );
    if (ok != true) return;
    final r = await ApiBaseClient().delete('debts/$id/');
    if (r.statusCode == 204) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('Meta excluída com sucesso!')),
      );
    }
    await _buscarDebts();
  }

  void _menuOpcoes(BuildContext ctx, Map<String, dynamic> d) {
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
              _abrirModalEditarDivida(ctx, d);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Excluir', style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.pop(_);
              _softDeleteDebt(ctx, d['id']);
            },
          ),
        ],
      ),
    );
  }

  void _novo() => _abrirModalNovaDivida();

  String _fmt(String iso) =>
      DateFormat('dd/MM/yyyy').format(DateTime.parse(iso));
  Color _cor(String s) => s == 'Paga'
      ? Colors.green
      : s == 'Em atraso'
          ? Colors.red
          : Colors.orange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
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
            padding: EdgeInsets.only(left: 30, top: 20),
            child: TitleText(text: 'Obrigações Financeiras', fontSize: 20),
          ),
          const SizedBox(height: 20),
          if (loading)
            const Center(child: CircularProgressIndicator())
          else if (debts.isEmpty)
            const Center(child: LittleText(text: 'Nenhuma obrigação financeira cadastrada.'))
          else
            ...debts.map((d) {
              final status = d['status'];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: HomePageWidget(
                  titleText: d['nome'],
                  menuIcon: GestureDetector(
                    onTap: () => _menuOpcoes(context, d),
                    child: const Icon(Icons.more_vert, size: 22),
                  ),
                  content: Padding(
                    padding: const EdgeInsets.only(left: 16, top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TitleText(text: 'Próxima parcela', fontSize: 12),
                        SubtitleText(
                            text: 'Data final: ${_fmt(d['data_vencimento'])}',
                            fontSize: 10),
                        SubtitleText(
                            text: 'Status: $status',
                            fontSize: 10,
                            color: _cor(status)),
                        SubtitleText(
                            text:
                                'Valor: R\$ ${d['valor_parcela'].toStringAsFixed(2)}',
                            fontSize: 10),
                        SubtitleText(
                            text: 'Parcelas: ${d['status_parcelas']}',
                            fontSize: 10),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            RoundedTextButton(
                              text: 'Parcela Paga',
                              width: 90,
                              height: 20,
                              fontSize: 9,
                              onPressed: () => _quitarParcela(d['id']),
                              borderColor: null,
                              borderWidth: 0,
                            ),
                            const SizedBox(width: 7),
                            if (status == 'Em atraso')
                              RoundedTextButton(
                                text: 'Prazo excedido',
                                width: 140,
                                height: 20,
                                fontSize: 9,
                                onPressed: () {},
                                borderColor: null,
                                borderWidth: 0,
                                buttonColor: Colors.red,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  showSeeMoreText: false,
                  onPressed: () {},
                ),
              );
            }),
          const SizedBox(height: 10),
          DottedButton(
            onPressed: _novo,
            icon: const Icon(Icons.add_circle_outline),
            text: 'Adicionar nova obrigação financeira',
            textSize: 14,
            iconSize: 20,
          ),
        ],
      ),
    );
  }

  void _abrirModalNovaDivida() {
    final nomeCtrl = TextEditingController();
    final valorCtrl = TextEditingController();
    final qtdCtrl = TextEditingController();
    final dataCtrl = TextEditingController();
    showCreateObjectModal(
      context: context,
      title: 'Nova Obrigação Financeira',
      fields: [
        FormWidget(hintText: 'Nome', controller: nomeCtrl, onChanged: (_) {}),
        FormWidget(
            hintText: 'Valor',
            controller: valorCtrl,
            keyboardType: TextInputType.number,
            onChanged: (_) {}),
        FormWidget(
            hintText: 'Parcelas',
            controller: qtdCtrl,
            keyboardType: TextInputType.number,
            onChanged: (_) {}),
        FormWidget(
            hintText: 'Data vencimento (01/01/2025)',
            controller: dataCtrl,
            keyboardType: TextInputType.datetime,
            onChanged: (_) {}),
      ],
      onSave: () async {
        final body = {
          'nome': nomeCtrl.text.trim(),
          'valor': double.tryParse(valorCtrl.text) ?? 0,
          'quantidade': int.tryParse(qtdCtrl.text) ?? 0,
          'data_vencimento': ddMMyyyyToIso(dataCtrl.text.trim()),
        };
        if (body.values.any((v) => v == 0 || v == '')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Preencha todos os campos.')),
          );
          return;
        }
        final r = await ApiBaseClient().post('debts/', body: jsonEncode(body));
        if (r.statusCode == 201) {
          Navigator.pop(context);
          await _buscarDebts();
        }
      },
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}
