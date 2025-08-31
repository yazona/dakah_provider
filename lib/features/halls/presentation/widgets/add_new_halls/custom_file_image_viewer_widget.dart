import 'dart:io';

import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';

class CustomFileImageViewer extends StatelessWidget {
  const CustomFileImageViewer({
    super.key,
    required this.fileImage,
    this.deleteImageOnTap,
  });

  final File fileImage;
  final void Function()? deleteImageOnTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => showImageViewer(
          context,
          FileImage(
            fileImage,
          ),
          closeButtonColor: ColorsManager.kPrimaryColor,
          backgroundColor: ColorsManager.kBlack.withAlpha(1),
        ),
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            SizedBox(
              width: 115,
              height: 125,
              child: Image.file(fileImage, fit: BoxFit.cover),
            ),
            GestureDetector(
              onTap: deleteImageOnTap,
              child: const Icon(
                Icons.delete,
                size: 15,
                color: ColorsManager.kRed,
              ),
            )
          ],
        ),
      ),
    );
  }
}
