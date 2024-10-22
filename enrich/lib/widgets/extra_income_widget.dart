import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class ExtraIncomeWidget extends StatelessWidget {
  final String titleText;
  final String littleText;
  final Widget content;
  final Function onPressed;

  const ExtraIncomeWidget(
      {super.key,
      required this.titleText,
      required this.littleText,
      required this.content,
      required this.onPressed
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
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
                child: TitleText(
                  text: titleText,
                  fontSize: 15,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 14.0),
                child: LittleText(
                  text: littleText,
                  fontSize: 8,
                  textAlign: TextAlign.start,
                ),
              ),
              content
            ],
          ),
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
          )
        ],
      ),
    );
  }
}
