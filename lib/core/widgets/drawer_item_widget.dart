import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.iconPath,
    required this.title,
    this.onTap,
  });

  final dynamic iconPath;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          iconPath is String
              ? SvgPicture.asset(
            iconPath,
            width: 22,
            height: 22,
          )
              : iconPath,
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            size: 15,
          )
        ],
      ),
    );
  }
}
