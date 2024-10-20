import 'package:enrich/pages/home_page.dart';
import 'package:enrich/widgets/little_list_tile.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePageWidget extends StatelessWidget {
  final String titleText;
  final Widget content;
  final Function onPressed;

  const HomePageWidget(
      {super.key,
      required this.titleText,
      required this.content,
      required this.onPressed
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
                child: TitleText(
                  text: titleText,
                  fontSize: 15,
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
