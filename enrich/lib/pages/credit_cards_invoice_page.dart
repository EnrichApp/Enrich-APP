import 'package:enrich/models/cartao.dart';
import 'package:enrich/services/cartao_service.dart';
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

class CreditCardsInvoicePage extends StatefulWidget {
  const CreditCardsInvoicePage({super.key});

  @override
  State<CreditCardsInvoicePage> createState() => _CreditCardsInvoicePageState();
}

class _CreditCardsInvoicePageState extends State<CreditCardsInvoicePage> {
  final _service = CartaoService();
  late Future<List<Cartao>> _future;
  late Future<double> _totalFuture;

  @override
  void initState() {
    super.initState();
    _future = _service.listar();
    _totalFuture = _service.obterTotal();
  }

  void _refresh() {
    setState(() {
      _future = _service.listar();
      _totalFuture = _service.obterTotal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: _buildAppBar(context),
      body: FutureBuilder<List<Cartao>>(
        future: _future,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Erro: ${snap.error}'));
          }

          final cartoes = snap.data ?? [];

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 30, top: 20),
                child: TitleText(text: 'Faturas', fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 20),
                child: FutureBuilder<double>(
                  future: _totalFuture,
                  builder: (ctx, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const TitleText(text: 'Total: ...', fontSize: 20);
                    }

                    final total = snap.data ?? 0.0;
                    final valorFormatado = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                        .format(total);

                    return TitleText(text: 'Total: $valorFormatado', fontSize: 20);
                  },
                ),
              ),
              const SizedBox(height: 20),
              if (cartoes.isEmpty)
                const Center(child: LittleText(text: 'Nenhuma fatura cadastrada.'))
              else
                ...cartoes.map(
                  (c) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: _CartaoTile(
                      cartao: c,
                      onEdit: () async {
                        await _openForm(context, c);
                        _refresh();
                      },
                      onRefresh: _refresh,
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              DottedButton(
                onPressed: () async {
                  await _openForm(context, null);
                  _refresh();
                },
                icon: const Icon(Icons.add_circle_outline),
                text: 'Adicionar nova fatura',
                textSize: 14,
                iconSize: 20,
              ),
            ],
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext ctx) => AppBar(
        leadingWidth: 100,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: GestureDetector(
          onTap: () => Navigator.pop(ctx),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.arrow_back_ios_new, size: 14),
              SizedBox(width: 2),
              LittleText(text: 'Voltar', fontSize: 12, underlined: true),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      );

  Future<void> _openForm(BuildContext context, Cartao? original) async {
    final nomeCtrl  = TextEditingController(text: original?.nome ?? '');
    final valorCtrl =
        TextEditingController(text: original?.valor.toString() ?? '');
    final dataCtrl  = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(original?.dataFinal ?? DateTime.now()));
    bool isPago     = original?.isPago ?? false;

    Future<void> _salvarAsync() async {
      final parsedDate = DateFormat('dd/MM/yyyy').parse(dataCtrl.text);
      final cartao = Cartao(
        id       : original?.id ?? 0,
        nome     : nomeCtrl.text.trim(),
        valor    : double.parse(valorCtrl.text),
        dataFinal: parsedDate,
        isPago   : isPago,
        status   : original?.status ?? '',
      );
      if (original == null) {
        await _service.criar(cartao);
      } else {
        await _service.atualizar(original.id, cartao);
      }
      if (context.mounted) Navigator.pop(context);
      _refresh();
    }

    showCreateObjectModal(
      context: context,
      title: original == null ? 'Nova fatura' : 'Editar fatura',
      fields: [
        FormWidget(
          hintText: 'Nome do cartão',
          controller: nomeCtrl,
          onChanged: (_) {},
        ),
        FormWidget(
          hintText: 'Valor',
          controller: valorCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (_) {},
        ),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context   : context,
              initialDate: DateFormat('dd/MM/yyyy').parse(dataCtrl.text),
              firstDate : DateTime(2020),
              lastDate  : DateTime(2035),
              builder: (ctx, child) => Theme(
                data: Theme.of(ctx).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary   : Colors.black,
                    onPrimary : Colors.white,
                    surface   : Colors.white,
                    onSurface : Colors.black,
                  ),
                ),
                child: child!,
              ),
            );
            if (picked != null) {
              dataCtrl.text = DateFormat('dd/MM/yyyy').format(picked);
            }
          },
          child: AbsorbPointer(
            child: FormWidget(
              hintText: 'Data final (dd/mm/aaaa)',
              controller: dataCtrl,
              keyboardType: TextInputType.datetime,
              onChanged: (_) {},
            ),
          ),
        ),
        StatefulBuilder(
          builder: (ctx, setModalState) => GestureDetector(
            onTap: () => setModalState(() => isPago = !isPago),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(isPago ? Icons.check_box : Icons.check_box_outline_blank,
                      color: Colors.black),
                  const SizedBox(width: 12),
                  const Text('Fatura paga', style: TextStyle(fontSize: 16, color: Colors.black)),
                ],
              ),
            ),
          ),
        ),
      ],
      onSave: () { _salvarAsync(); },
    );
  }
}

class _CartaoTile extends StatelessWidget {
  const _CartaoTile({
    required this.cartao,
    required this.onRefresh,
    required this.onEdit,
  });

  final Cartao cartao;
  final VoidCallback onRefresh;
  final VoidCallback onEdit;

  Color _corStatus(String s) => switch (s) {
        'Pago'      => Colors.green,
        'Em atraso' => Colors.red,
        _           => Colors.orange,
      };

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
            title : const Text('Editar', style: TextStyle(color: Colors.black)),
            onTap : () { Navigator.pop(_); onEdit(); },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title : const Text('Excluir', style: TextStyle(color: Colors.black)),
            onTap : () async {
              Navigator.pop(_);
              final ok = await showDialog<bool>(
                    context: ctx,
                    builder: (dCtx) => AlertDialog(
                    title : const Text('Confirmar exclusão', style: TextStyle(color: Colors.black)),
                      content: const Text('Deseja realmente excluir esta fatura?', style: TextStyle(color: Colors.black)),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(dCtx, false),
                                   child: const Text('Cancelar')),
                        TextButton(onPressed: () => Navigator.pop(dCtx, true),
                                   child: const Text('Excluir')),
                      ],
                    ),
                  ) ?? false;
              if (ok) {
                await CartaoService().excluir(cartao.id);
                onRefresh();
              }
            },
          ),
          SizedBox(height: 30,)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final df  = DateFormat('dd/MM/yyyy').format(cartao.dataFinal);
    final val = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
        .format(cartao.valor);

    return HomePageWidget(
      titleText: cartao.nome,
      menuIcon : GestureDetector(
        onTap : () => _menuOpcoes(context),
        child : const Icon(Icons.more_vert, size: 22),
      ),
      content: Padding(
        padding: const EdgeInsets.only(left: 16, top: 2, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleText(text: 'Fatura atual', fontSize: 12),
            SubtitleText(text: 'Data final: $df', fontSize: 10),
            SubtitleText(
              text : 'Status: ${cartao.status}',
              fontSize: 10,
              color: _corStatus(cartao.status),
            ),
            SubtitleText(text: 'Valor: $val', fontSize: 10),
            const SizedBox(height: 6),
            Row(
              children: [
                RoundedTextButton(
                  text : 'Marcar paga',
                  width: 90,
                  height: 20,
                  fontSize: 9,
                  onPressed: () async {
                    await CartaoService().marcarPago(cartao);
                    onRefresh();
                  },
                ),
                const SizedBox(width: 7),
                if (cartao.status == 'Em atraso')
                  RoundedTextButton(
                    text : 'Prazo excedido',
                    width: 140,
                    height: 20,
                    fontSize: 9,
                    onPressed: () {},
                    buttonColor: Colors.red,
                    borderWidth: 0,
                  ),
              ],
            ),
          ],
        ),
      ),
      showSeeMoreText: false,
      onPressed: () {},
    );
  }
}
