import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/widgets/body_with_header_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_appbar_widget.dart';
import 'package:dakeh_service_provider/features/home/manager/home_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EmptyNotifications extends StatelessWidget {
  const EmptyNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return BodyWithAppHeader(
      fromHome: false,
      appBar: CustomAppBar(
        rightType: ButtonAppBarType.menuButton,
        scaffoldKey: HomeCubit.get(context).homeLayoutScaffoldKey,
        title: '- ${'notifications'.tr()} -',
        leftType: ButtonAppBarType.none,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: ColorsManager.kWhite,
            borderRadius: BorderRadius.circular(10)),
        child: RefreshIndicator(
          onRefresh: () => Future(() {
            if (context.mounted) {
              HomeCubit.get(context)
                  .getNotifications(fromPagination: false, sortByNewest: true);
            }
          }),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.5,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.notifications_paused_sharp,
                    color: ColorsManager.kPrimaryColor,
                    size: 200,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    'noNotifications'.tr(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
