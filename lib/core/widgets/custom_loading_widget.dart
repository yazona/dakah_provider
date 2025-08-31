import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({
    super.key,
    this.backgroundColor,
  });

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: backgroundColor ?? ColorsManager.kPrimaryColor.withAlpha(2),
      child: const SpinKitCubeGrid(
        color: ColorsManager.kPrimaryColor,
      ),
    );
  }
}
