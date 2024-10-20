import 'package:enrich/widgets/texts/little_text.dart';
import 'package:enrich/widgets/texts/title_text.dart';
import 'package:flutter/material.dart';

class HomePageDividaWidget extends StatelessWidget {
  final String category;
  final String debtName;

  const HomePageDividaWidget({
    super.key,
    required this.category,
    required this.debtName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          text: category,
          fontSize: 12,
        ),
        LittleText(text: debtName)
      ],
    );
  }
}
