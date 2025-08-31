import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/features/halls/manager/halls_cubit.dart';
import 'package:dakeh_service_provider/features/halls/presentation/widgets/add_new_halls/custom_file_image_viewer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageGallery extends StatelessWidget {
  const ImageGallery({super.key, required this.cubit});

  final HallsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return cubit.hallImages.isNotEmpty
        ? SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if(index < cubit.hallImages.length) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 90,
                    width: 115,
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF939393)),
                        color: ColorsManager.kWhite,
                        borderRadius: BorderRadius.circular(10)),
                    child: CustomFileImageViewer(
                      fileImage: cubit.hallImages[index],
                      deleteImageOnTap: () => cubit.deleteHallImage(index),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () => cubit.pickHallImages(),
                    child: Container(
                      alignment: AlignmentDirectional.center,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      height: 90,
                      width: 115,
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF939393)),
                          color: ColorsManager.kWhite,
                          borderRadius: BorderRadius.circular(10)),
                      child: SvgPicture.asset(
                        AssetsManager.kAddImageBoxIconSVG,
                      ),
                    ),
                  );
                }
              },
              itemCount: cubit.hallImages.length + 1,
            ),
          )
        : GestureDetector(
            onTap: () => cubit.pickHallImages(),
            child: Container(
              alignment: AlignmentDirectional.center,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 90,
              width: 115,
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF939393)),
                  color: ColorsManager.kWhite,
                  borderRadius: BorderRadius.circular(10)),
              child: SvgPicture.asset(
                AssetsManager.kAddImageBoxIconSVG,
              ),
            ),
          );
  }
}
