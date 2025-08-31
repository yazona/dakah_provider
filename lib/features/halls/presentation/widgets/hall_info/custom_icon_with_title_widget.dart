import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIconWithTitle extends StatelessWidget {
  const CustomIconWithTitle({
    super.key,
    required this.iconPathSVG,
    required this.title,
    this.titleStyle,
    this.onTap,
  });

  final String iconPathSVG;
  final String title;
  final TextStyle? titleStyle;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPathSVG,
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: titleStyle,
            ),
          ),
        )
      ],
    );
  }
}
