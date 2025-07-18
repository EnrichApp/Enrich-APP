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
      setState(() {
        carregandoMetas = false;
      });
    }
  }

  void _abrirModalAdicionarDinheiro(BuildContext context, int metaId) {
    final valorController = TextEditingController();
    String erro = '';

    showCreateObjectModal(
      context: context,
      title: 'Registrar investimento',
      fields: [
        FormWidget(
          hintText: 'Valor investido',
          controller: valorController,
          keyboardType: TextInputType.number,
          onChanged: (_) {
            if (erro.isNotEmpty) erro = '';
          },
          errorText: erro,
        ),
      ],
      onSave: () async {
        final valor = double.tryParse(valorController.text.trim()) ?? 0.0;

        if (valor <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Informe um valor válido')),
          );
          return;
        }

        final body = {"receitas": valor, "despesas": 0.0};

        try {
          final response = await ApiBaseClient()
              .post('metas/$metaId/movimentacoes/', body: jsonEncode(body));

          if (response.statusCode == 201 || response.statusCode == 200) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Investimento registrado com sucesso!')),
            );
            await _buscarMetas();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Erro ao registrar investimento.')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ocorreu um erro. Tente novamente mais tarde.')),
          );
        }
      },
    );
  }

  void _abrirModalRemoverDinheiro(BuildContext context, int metaId) {
    final valorController = TextEditingController();
    String erro = '';

    showCreateObjectModal(
      context: context,
      title: 'Registrar retirada',
      fields: [
        FormWidget(
          hintText: 'Valor retirado',
          controller: valorController,
          keyboardType: TextInputType.number,
          onChanged: (_) {
            if (erro.isNotEmpty) erro = '';
          },
          errorText: erro,
        ),
      ],
      onSave: () async {
        final valor = double.tryParse(valorController.text.trim()) ?? 0.0;

        if (valor <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Informe um valor válido')),
          );
          return;
        }

        final body = {"receitas": 0.0, "despesas": valor};

        try {
          final response = await ApiBaseClient()
              .post('metas/$metaId/movimentacoes/', body: jsonEncode(body));

          if (response.statusCode == 201 || response.statusCode == 200) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Retirada registrada com sucesso!')),
            );
            await _buscarMetas();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Erro ao registrar retirada')),
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

  void _mostrarOpcoesMeta(
    BuildContext bottomSheetCtx,
    int metaId,
    String nome,
    double valorAtual,
  ) {
    showModalBottomSheet(
      context: bottomSheetCtx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text('Editar', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.of(bottomSheetCtx).pop();
                _abrirModalEditarMeta(bottomSheetCtx, metaId, nome, valorAtual);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Excluir', style: TextStyle(color: Colors.black)),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: bottomSheetCtx,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Confirmar exclusão',
                        style: TextStyle(color: Colors.black)),
                    content: const Text('Deseja realmente excluir esta meta?',
                        style: TextStyle(color: Colors.black)),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Cancelar')),
                      TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Excluir')),
                    ],
                  ),
                );
                if (confirm != true) return;
                try {
                  final resp = await ApiBaseClient().delete('metas/$metaId/');
                  if (resp.statusCode == 204) {
                    ScaffoldMessenger.of(bottomSheetCtx).showSnackBar(
                      const SnackBar(
                          content: Text('Meta excluída com sucesso!')),
                    );
                    await _buscarMetas();
                  } else {
                    ScaffoldMessenger.of(bottomSheetCtx).showSnackBar(
                      SnackBar(
                          content: Text('Erro ao excluir: ${resp.statusCode}')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(bottomSheetCtx).showSnackBar(
                    SnackBar(content: Text('Erro inesperado: $e')),
                  );
                }
                Navigator.of(bottomSheetCtx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _abrirModalEditarMeta(
    BuildContext context,
    int metaId,
    String nomeAtual,
    double valorAtual,
  ) {
    final nomeController = TextEditingController(text: nomeAtual);
    final valorController = TextEditingController(text: valorAtual.toString());

    showCreateObjectModal(
      context: context,
      title: 'Editar Meta',
      fields: [
        FormWidget(
          hintText: 'Nome da Meta',
          controller: nomeController,
          onChanged: (_) {},
          errorText: '',
        ),
        FormWidget(
          hintText: 'Valor da Meta',
          controller: valorController,
          keyboardType: TextInputType.number,
          onChanged: (_) {},
          errorText: '',
        ),
      ],
      onSave: () async {
        final novoNome = nomeController.text.trim();
        final valorTexto = valorController.text.trim();
        final body = <String, dynamic>{};
        if (novoNome.isNotEmpty && novoNome != nomeAtual)
          body['nome'] = novoNome;
        final novoValor = double.tryParse(valorTexto);
        if (valorTexto.isNotEmpty &&
            novoValor != null &&
            novoValor != valorAtual) {
          body['valor_meta'] = novoValor;
        }
        if (body.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Nenhuma alteração detectada')),
          );
          return;
        }
        try {
          final resp = await ApiBaseClient()
              .put('metas/$metaId/', body: jsonEncode(body));
          if (resp.statusCode == 200 || resp.statusCode == 204) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Meta atualizada com sucesso!')),
            );
            await _buscarMetas();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro ao atualizar: ${resp.statusCode}')),
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
          final response =
              await ApiBaseClient().post('metas/', body: jsonEncode(body));
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
              final metaId = meta['id'];
              final nome = meta['nome'] ?? 'Meta sem nome';
              final valorMeta = meta['valor_meta'] ?? 0.0;
              final total = meta['total'] ?? 0.0;
              final progresso = meta['porcentagem_meta'] ?? 0.0;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: HomePageWidget(
                  titleText: nome,
                  menuIcon: GestureDetector(
                    onTap: () =>
                        _mostrarOpcoesMeta(context, metaId, nome, valorMeta),
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
                              amount: '${total.toStringAsFixed(2)}',
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
                                  amount: '${valorMeta.toStringAsFixed(2)}',
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
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
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
                                  text: "Registrar investimento",
                                  icon: Icon(Icons.add_circle_sharp),
                                  iconSize: 24,
                                  fontSize: 9,
                                  onIconTap: () => _abrirModalAdicionarDinheiro(
                                      context, metaId),
                                ),
                                const SizedBox(width: 7),
                                LittleTextTile(
                                  iconColor: Colors.red,
                                  text: "Registrar retirada",
                                  icon: Icon(Icons.remove_circle_sharp),
                                  iconSize: 24,
                                  fontSize: 9,
                                  onIconTap: () => _abrirModalRemoverDinheiro(
                                      context, metaId),
                                ),
                                const SizedBox(width: 75),
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
