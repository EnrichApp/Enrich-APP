import 'package:flutter/material.dart';

class ContainerWidget extends StatelessWidget {
  final double width;
  final double height;
  final Widget content;

  const ContainerWidget({
    super.key,
    this.width = 320,
    this.height = 150,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: content,
    );
  }
}
