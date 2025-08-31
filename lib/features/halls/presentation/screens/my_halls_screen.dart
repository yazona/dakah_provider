import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/core/widgets/body_with_header_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_appbar_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_button.dart';
import 'package:dakeh_service_provider/core/widgets/custom_loading_widget.dart';
import 'package:dakeh_service_provider/core/widgets/drawer_widget.dart';
import 'package:dakeh_service_provider/features/halls/manager/halls_cubit.dart';
import 'package:dakeh_service_provider/features/halls/manager/halls_states.dart';
import 'package:dakeh_service_provider/features/halls/presentation/screens/add_new_hall_screen.dart';
import 'package:dakeh_service_provider/features/halls/presentation/widgets/hall_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHallsScreen extends StatelessWidget {
  const MyHallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return BlocConsumer<HallsCubit, HallsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          key: scaffoldKey,
          drawer: AppDrawer(
            user: AppConstants.user,
            scaffoldKey: scaffoldKey,
            screenContext: context,
          ),
          body: state is GetHallsLoadingState
              ? const CustomLoading()
              : BodyWithAppHeader(
                  fromHome: false,
                  appBar: CustomAppBar(
                    rightType: ButtonAppBarType.menuButton,
                    title: Text(
                      '- ${'myHalls'.tr()} -',
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 30),
                    ),
                    leftType: ButtonAppBarType.backButton,
                    scaffoldKey: scaffoldKey,
                  ),
                  child: Column(
                    children: [
                      CustomButton(
                        onPressed: () {
                          AppFunctions.navTo(context,
                              screen: const AddNewHallScreen());
                        },
                        title: 'addNewHall'.tr(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      HallsCubit.get(context).halls.isEmpty
                          ? Expanded(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 90,
                                  ),
                                  const Icon(
                                    Icons.not_interested_rounded,
                                    size: 100,
                                    color: ColorsManager.kPrimaryColor,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'dontHaveHalls'.tr(),
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )
                          : Expanded(
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (notification) {
                                  if (notification.metrics.pixels ==
                                          notification
                                              .metrics.maxScrollExtent &&
                                      notification
                                          is ScrollUpdateNotification) {
                                    if (HallsCubit.get(context).hallsHasMore) {
                                      HallsCubit.get(context)
                                          .getHalls(fromPagination: true);
                                    }
                                  }
                                  return true;
                                },
                                child: RefreshIndicator(
                                  onRefresh: () {
                                    return Future(() {
                                      if (context.mounted) {
                                        HallsCubit.get(context).getHalls();
                                      }
                                    });
                                  },
                                  child: ListView.separated(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    physics:
                                        const AlwaysScrollableScrollPhysics()
                                            .applyTo(
                                                const ClampingScrollPhysics()),
                                    itemBuilder: (context, index) {
                                      if (index <
                                          HallsCubit.get(context)
                                              .halls
                                              .length) {
                                        return HallItem(
                                          model: HallsCubit.get(context)
                                              .halls[index],
                                        );
                                      } else {
                                        return Center(
                                          child: HallsCubit.get(context)
                                                  .hallsHasMore
                                              ? const LinearProgressIndicator()
                                              : Text(
                                                  'noMoreHalls'.tr(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                      color: ColorsManager
                                                          .kPrimaryColor),
                                                ),
                                        );
                                      }
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      height: 20,
                                    ),
                                    itemCount:
                                        HallsCubit.get(context).halls.length +
                                            1,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
