import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class CustomRating extends StatelessWidget {
  const CustomRating({
    super.key,
    required this.textController,
    required this.textHint,
    required this.boxTitle,
    required this.onRatingUpdate,
    this.child,
    required this.rateInit,
  });

  final TextEditingController textController;
  final String textHint;
  final String boxTitle;
  final double rateInit;
  final void Function(double) onRatingUpdate;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          boxTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: RatingBar(
            initialRating: rateInit,
            ratingWidget: RatingWidget(
                full: const Icon(
                  Icons.star,
                  color: ColorsManager.kPrimaryColor,
                ),
                half: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: const Icon(
                    Icons.star_half,
                    color: ColorsManager.kPrimaryColor,
                  ),
                ),
                empty: const Icon(
                  Icons.star_border,
                  color: ColorsManager.kPrimaryColor,
                )),
            itemSize: 40,
            minRating: 1,
            allowHalfRating: true,
            updateOnDrag: true,
            glow: false,
            textDirection: TextDirection.rtl,
            onRatingUpdate: onRatingUpdate,
          ),
        ),
      ],
    );
  }
}
