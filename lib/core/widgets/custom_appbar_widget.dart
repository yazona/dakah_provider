import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.padding,
    this.scaffoldKey,
    required this.rightType,
    required this.leftType,
  });

  final dynamic title;
  final ButtonAppBarType rightType;
  final ButtonAppBarType leftType;
  final EdgeInsetsGeometry? padding;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 58.0, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (rightType == ButtonAppBarType.menuButton)
            GestureDetector(
              onTap: () => scaffoldKey?.currentState?.openDrawer(),
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: ColorsManager.kWhite),
                child: const Icon(
                  Icons.menu,
                ),
              ),
            )
          else if (rightType == ButtonAppBarType.backButton)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: ColorsManager.kWhite),
                child: const Icon(
                  Icons.arrow_back,
                ),
              ),
            )
          else
            GestureDetector(
              onTap: null,
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.transparent),
              ),
            ),
          if (title != null)
            title is String
                ? Text(
              title!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            )
                : title,
          if (leftType == ButtonAppBarType.menuButton)
            GestureDetector(
              onTap: () => scaffoldKey?.currentState?.openDrawer(),
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: ColorsManager.kWhite),
                child: const Icon(
                  Icons.menu,
                ),
              ),
            )
          else if (leftType == ButtonAppBarType.backButton)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: ColorsManager.kWhite),
                child: const Icon(
                  Icons.arrow_forward,
                ),
              ),
            )
          else
            GestureDetector(
              onTap: null,
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.transparent),
              ),
            ),
        ],
      ),
    );
  }
}

enum ButtonAppBarType { backButton, menuButton, none }
