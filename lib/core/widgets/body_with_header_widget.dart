import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:flutter/material.dart';

class BodyWithAppHeader extends StatelessWidget {
  const BodyWithAppHeader({
    super.key,
    required this.child,
    required this.appBar,
    this.fromHome = true,
  });

  final Widget child;
  final Widget appBar;
  final bool fromHome;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.topCenter,
      children: [
        Container(
          height: 175,
          alignment: !fromHome ? AlignmentDirectional.topCenter : null,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(AssetsManager.kAppBarHeaderImagePNG),
            ),
          ),
          child: appBar,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 140,
          ),
          child: child,
        )
      ],
    );
  }
}
