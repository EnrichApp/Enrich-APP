import 'package:flutter/material.dart';

class FloatingActionMenu extends StatefulWidget {
  final VoidCallback onAdicionarGanho;
  final VoidCallback onAdicionarGasto;

  const FloatingActionMenu({
    super.key,
    required this.onAdicionarGanho,
    required this.onAdicionarGasto,
  });

  @override
  State<FloatingActionMenu> createState() => _FloatingActionMenuState();
}

class _FloatingActionMenuState extends State<FloatingActionMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  void _toggle() {
    setState(() {
      isOpen = !isOpen;
      if (isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Overlay esbranquiçado
        if (isOpen)
          GestureDetector(
            onTap: _toggle,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isOpen ? 0.75 : 0.0,
              child: Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(right: 25, bottom: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizeTransition(
                sizeFactor: _expandAnimation,
                axisAlignment: -1,
                child: _ActionButton(
                  text: "Adicionar Gasto",
                  icon: Icons.remove,
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  onTap: () async {
                    _toggle();
                    Future.delayed(const Duration(milliseconds: 150), () {
                      widget.onAdicionarGasto();
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizeTransition(
                sizeFactor: _expandAnimation,
                axisAlignment: -1,
                child: _ActionButton(
                  text: "Adicionar Ganho",
                  icon: Icons.add,
                  color: theme.colorScheme.primary,
                  alignment: Alignment.centerRight,
                  onTap: () {
                    _toggle();
                    widget.onAdicionarGanho();
                  },
                ),
              ),
              const SizedBox(height: 12),
              // FAB some completamente quando aberto
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isOpen
                    ? const SizedBox.shrink()
                    : FloatingActionButton(
                        key: const ValueKey("main-fab"),
                        backgroundColor: theme.colorScheme.primary,
                        shape: const CircleBorder(),
                        elevation: 6,
                        onPressed: _toggle,
                        child: const Icon(Icons.menu,
                            size: 30, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final Alignment alignment;
  final VoidCallback onTap;

  const _ActionButton({
    required this.text,
    required this.icon,
    required this.color,
    this.alignment = Alignment.centerRight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(left: 40),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 5)
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(text,
                    style: const TextStyle(fontSize: 18, color: Colors.black)),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: color,
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
