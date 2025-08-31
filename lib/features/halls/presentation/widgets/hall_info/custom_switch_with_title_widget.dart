import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class CustomSwitchWithTitle extends StatelessWidget {
  const CustomSwitchWithTitle(
      {super.key,
      required this.title,
      required this.switchValue,
      required this.onToggle});

  final String title;
  final bool switchValue;
  final void Function(bool value) onToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17),
        ),
        Directionality(
          textDirection: TextDirection.ltr,
          child: FlutterSwitch(
            value: switchValue,
            onToggle: onToggle,
            activeColor: ColorsManager.kPrimaryColor,
            showOnOff: true,
            activeTextColor: ColorsManager.kWhite,
            inactiveText: 'OFF',
            activeText: 'ON',
          ),
        )
      ],
    );
  }
}
