import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:flutter/material.dart';

class OTPHeader extends StatelessWidget {
  const OTPHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.topCenter,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .60,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(
            AssetsManager.kOnBoardHeaderImage,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Image.asset(
          AssetsManager.kDakehLogoIconPNG,
          width: 150,
        ),
      ),
    );
  }
}
