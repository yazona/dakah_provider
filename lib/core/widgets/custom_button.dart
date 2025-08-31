import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    this.btnWidth,
    this.btnHeight = 60,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w500,
    this.backgroundColor = ColorsManager.kPrimaryColor,
    this.borderColor = ColorsManager.kPrimaryColor,
    this.fontColor = ColorsManager.kWhite,
    required this.title,
  });

  final void Function()? onPressed;
  final double? btnWidth;
  final double btnHeight;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color backgroundColor;
  final Color borderColor;
  final Color fontColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      elevation: 0.0,
      minWidth: btnWidth ?? MediaQuery.of(context).size.width,
      height: btnHeight,
      color: backgroundColor,
      disabledColor: ColorsManager.kTextGrey,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: fontColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
