import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    required this.text,
    this.withExpanded = false,
  });

  final String text;
  final bool withExpanded;

  @override
  Widget build(BuildContext context) {
    return withExpanded
        ? Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.block,
                    size: 150,
                    color: ColorsManager.kPrimaryColor,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.block,
                  size: 150,
                  color: ColorsManager.kPrimaryColor,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  text,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
  }
}
