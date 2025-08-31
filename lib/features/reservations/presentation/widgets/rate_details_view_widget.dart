import 'package:dakeh_service_provider/core/utils/colors_manager.dart' show ColorsManager;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateDetailsView extends StatelessWidget {
  const RateDetailsView(
      {super.key,
      required this.rateTitle,
      required this.rateNum,
      this.rateText});

  final String rateTitle;
  final double rateNum;
  final String? rateText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rateTitle,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Center(
          child: RatingBar(
            ignoreGestures: true,
            ratingWidget: RatingWidget(
              empty: const Icon(
                Icons.star_border,
                color: ColorsManager.kPrimaryColor,
              ),
              full: const Icon(
                Icons.star,
                color: ColorsManager.kPrimaryColor,
              ),
              half: const Icon(
                Icons.star_half,
                color: ColorsManager.kPrimaryColor,
              ),
            ),
            initialRating: rateNum,
            minRating: rateNum,
            maxRating: rateNum,
            updateOnDrag: false,
            onRatingUpdate: (value) {},
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        if (rateText != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            alignment: AlignmentDirectional.center,
            decoration: BoxDecoration(
                color: ColorsManager.kBottomNavTextGrey.withValues(alpha: .3),
                borderRadius: BorderRadius.circular(10)),
            child: Text(
              rateText!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          )
      ],
    );
  }
}
