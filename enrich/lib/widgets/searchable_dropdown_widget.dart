import 'package:flutter/material.dart';

class SearchableDropdown extends StatefulWidget {
  final String? selected;
  final String label;
  final List<String> items;
  final ValueChanged<String> onChanged;
  const SearchableDropdown({
    required this.items,
    required this.label,
    this.selected,
    required this.onChanged,
  });

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.selected ?? '');
  }

  Future<void> _openSheet() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        String filtro = '';
        return StatefulBuilder(
          builder: (ctx, setModalState) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: TextField(
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      labelText: 'Buscar…',
                      prefixIcon: Icon(Icons.search),
                    ),
                    autofocus: true,
                    onChanged: (v) => setModalState(() => filtro = v),
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: ListView(
                    children: widget.items
                        .where((e) =>
                            e.toLowerCase().contains(filtro.toLowerCase()))
                        .map(
                          (e) => ListTile(
                            title: Text(
                              e,
                              style: const TextStyle(
                                  color: Colors.black),                            ),
                            onTap: () => Navigator.pop(ctx, e),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (result != null) {
      widget.onChanged(result);
      setState(() => _controller.text = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: const Icon(Icons.arrow_drop_down),
      ),
      onTap: _openSheet,
    );
  }
}
