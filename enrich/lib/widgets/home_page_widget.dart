import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class HomePageWidget extends StatelessWidget {
  final String titleText;
  final Widget menuIcon;
  final Widget content;
  final Function onPressed;
  final bool showSeeMoreText;
  final Widget? titleWidget;
  final double height;
  final double width;
  final String seeMoreTextString;
  final Color? seeMoreTextColor;

  const HomePageWidget(
      {super.key,
      required this.titleText,
      this.titleWidget,
      this.height = 150,
      this.width = 320,
      required this.content,
      required this.onPressed,
      this.menuIcon = const SizedBox.shrink(),
      this.showSeeMoreText = true, // Exibir "Ver mais" por padrão
      this.seeMoreTextString = 'Ver mais',
      this.seeMoreTextColor
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
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 14.0),
                child: Row(
                  children: [
                    titleWidget ??
                        TitleText(
                          text: titleText!,
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
                  text: seeMoreTextString,
                  color: seeMoreTextColor ?? Theme.of(context).colorScheme.primary,
                  sublined: true,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
