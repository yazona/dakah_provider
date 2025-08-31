import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.hintText,
    required this.controller,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.prefixIconSVGPath,
    this.suffixIcon,
    this.obscureText = false,
    this.maxLines = 1,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.readOnly = false,
    this.onTap, this.borderColor,
  });

  final String? hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String? value)? validator;
  final Widget? prefixIcon;
  final String? prefixIconSVGPath;
  final Widget? suffixIcon;
  final bool obscureText;
  final int maxLines;
  final AutovalidateMode? autovalidateMode;
  final bool readOnly;
  final void Function()? onTap;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: autovalidateMode,
      cursorOpacityAnimates: true,
      cursorErrorColor: ColorsManager.kRed,
      controller: controller,
      onTap: onTap,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: maxLines,
      validator: validator,
      obscureText: obscureText,
      decoration: InputDecoration(
          fillColor: ColorsManager.kWhite,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: ColorsManager.kWhite,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:  BorderSide(
              color: borderColor ?? ColorsManager.kWhite,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: ColorsManager.kRed,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: ColorsManager.kRed,
            ),
          ),
          prefixIcon: prefixIconSVGPath != null
              ? maxLines < 1
                  ? Align(
                      heightFactor: 4.5,
                      widthFactor: 1,
                      alignment: AlignmentDirectional.topStart,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SvgPicture.asset(
                          prefixIconSVGPath!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SvgPicture.asset(
                        prefixIconSVGPath!,
                      ),
                    )
              : prefixIcon,
          suffixIcon: suffixIcon,
          hintText: hintText,
          hintStyle: const TextStyle(
              color: ColorsManager.kHintTextGrey,
              fontSize: 18,
              fontWeight: FontWeight.w500)),
    );
  }
}
