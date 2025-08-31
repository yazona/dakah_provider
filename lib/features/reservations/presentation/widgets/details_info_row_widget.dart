import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailsInfoRow extends StatelessWidget {
  const DetailsInfoRow({
    super.key,
    required this.iconPath,
    required this.title,
    this.fontSize = 13,
    this.fontWeight = FontWeight.w400,
    this.fontColor = ColorsManager.kBlack,
  });

  final String iconPath;
  final dynamic title;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? fontColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 15,
          height: 15,
        ),
        const SizedBox(
          width: 8,
        ),
        title is String
            ? Expanded(
              child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: fontWeight,
                    fontSize: fontSize,
                    color: fontColor
                  ),
                ),
            )
            : Expanded(child: title)
      ],
    );
  }
}
