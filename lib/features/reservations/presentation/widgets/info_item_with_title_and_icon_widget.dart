import 'package:dakeh_service_provider/core/widgets/translate_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InfoItemWithIconAndTitle extends StatelessWidget {
  const InfoItemWithIconAndTitle({
    super.key,
    required this.iconPath,
    required this.title,
    required this.subTitleAR,
    required this.subTitleEN,
    this.colorFilter,
    this.size,
    this.borderRadius = BorderRadius.zero
  });

  final String iconPath;
  final String title;
  final String subTitleAR;
  final String subTitleEN;
  final ColorFilter? colorFilter;
  final double? size;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: borderRadius,
          child: SvgPicture.asset(
            iconPath,
            colorFilter: colorFilter,
            height: size,
            width: size,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
          ),
        ),
        TranslateText(
          textAR: subTitleAR,
          textEN: subTitleEN,
          maxLine: 1,
          overflow: TextOverflow.ellipsis,
          textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
        )
      ],
    );
  }
}
