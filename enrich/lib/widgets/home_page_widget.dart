import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class HomePageWidget extends StatelessWidget {
  final String titleText;
  final Widget menuIcon;
  final Widget content;
  final Function onPressed;
  final bool showSeeMoreText;

  const HomePageWidget({
    super.key,
    required this.titleText,
    required this.content,
    required this.onPressed,
    this.menuIcon = const SizedBox.shrink(),
    this.showSeeMoreText = true, // Exibir "Ver mais" por padrão
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 320,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 14.0),
                child: Row(
                  children: [
                    TitleText(
                      text: titleText,
                      fontSize: 15,
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: menuIcon,
                    ),
                  ],
                ),
              ),
              content
            ],
          ),
          if (showSeeMoreText)
            Positioned(
              bottom: 13,
              right: 21,
              child: GestureDetector(
                onTap: () {
                  onPressed();
                },
                child: TitleText(
                  fontSize: 13,
                  text: "Ver mais",
                  color: Theme.of(context).colorScheme.primary,
                  sublined: true,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
