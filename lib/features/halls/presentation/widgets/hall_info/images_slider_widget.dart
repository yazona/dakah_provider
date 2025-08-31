import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dakeh_service_provider/core/widgets/custom_appbar_widget.dart';
import 'package:dakeh_service_provider/features/halls/manager/halls_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImagesSlider extends StatelessWidget {
  const ImagesSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CarouselSlider(
              items: List.generate(
                HallsCubit.get(context).hallInfo.images.length,
                (index) => CachedNetworkImage(
                  imageUrl:
                      '${AppConstants.kBaseURL}${HallsCubit.get(context).hallInfo.images[index].url}',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => SizedBox(
                    height: MediaQuery.of(context).size.height * .35,
                    child: const SpinKitCubeGrid(
                      color: ColorsManager.kPrimaryColor,
                      size: 30,
                    ),
                  ),
                  imageBuilder: (context, imageProvider) => Container(
                    height: MediaQuery.of(context).size.height * .35,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.fill,
                      image: imageProvider,
                    )),
                  ),
                  errorWidget: (context, url, error) => Container(
                    alignment: AlignmentDirectional.center,
                    height: MediaQuery.of(context).size.height * .35,
                    child: const Icon(
                      Icons.error,
                      color: ColorsManager.kPrimaryColor,
                      size: 50,
                    ),
                  ),
                ),
              ),
              options: CarouselOptions(
                autoPlay: true,
                viewportFraction: 1,
                onPageChanged: (index, reason) =>
                    HallsCubit.get(context).changeSmoothPageIndex(index),
              ),
            ),
            const CustomAppBar(
              rightType: ButtonAppBarType.none,
              leftType: ButtonAppBarType.backButton,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        AnimatedSmoothIndicator(
          activeIndex: HallsCubit.get(context).smoothPageIndex,
          count: HallsCubit.get(context).hallInfo.images.length,
          effect: const WormEffect(
            dotWidth: 4,
            dotHeight: 4,
            spacing: 4,
            activeDotColor: ColorsManager.kPrimaryColor,
            type: WormType.thinUnderground,
          ),
        ),
      ],
    );
  }
}
