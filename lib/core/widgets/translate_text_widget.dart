import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TranslateText extends StatelessWidget {
  const TranslateText(
      {super.key,
      required this.textAR,
      required this.textEN,
      this.textStyle,
      this.maxLine,
      this.overflow});

  final String textAR;
  final String textEN;
  final TextStyle? textStyle;
  final int? maxLine;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      context.locale.languageCode == 'ar' ? textAR : textEN,
      overflow: overflow,
      maxLines: maxLine,
      style: textStyle,
    );
  }
}
