import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/core/widgets/body_with_header_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_appbar_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_button.dart';
import 'package:dakeh_service_provider/core/widgets/custom_loading_widget.dart';
import 'package:dakeh_service_provider/features/home/manager/home_cubit.dart';
import 'package:dakeh_service_provider/features/home/manager/home_states.dart';
import 'package:dakeh_service_provider/features/home/presentation/widgets/empty_notifications_widget.dart';
import 'package:dakeh_service_provider/features/home/presentation/widgets/notification_list_item_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return state is GetNotificationsLoadingState
            ? const CustomLoading()
            : HomeCubit.get(context).notifications.isEmpty
                ? const EmptyNotifications()
                : BodyWithAppHeader(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => AppFunctions.buildAppDialog(
                              allowCloseWithBackButton: true,
                              context,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'deleteAllNotification'.tr(),
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'confirmDeleteAllNotification'.tr(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  const SizedBox(height: 25),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          title: 'deleteAllNotification'.tr(),
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                            HomeCubit.get(context)
                                                .deleteAllNotification();
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: CustomButton(
                                          backgroundColor: ColorsManager.kWhite,
                                          borderColor:
                                              ColorsManager.kPrimaryColor,
                                          fontColor: ColorsManager.kBlack,
                                          title: 'cancel'.tr(),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            child: Text(
                              'deleteAll'.tr(),
                            ),
                          ),
                          Expanded(
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (notification) {
                                if (notification.metrics.pixels ==
                                        notification.metrics.maxScrollExtent &&
                                    notification is ScrollUpdateNotification) {
                                  if (HomeCubit.get(context)
                                      .notificationsHasMore) {
                                    HomeCubit.get(context).getNotifications(
                                        fromPagination: true,
                                        sortByNewest: true);
                                  }
                                }
                                return true;
                              },
                              child: RefreshIndicator(
                                onRefresh: () => Future(() {
                                  if (context.mounted) {
                                    HomeCubit.get(context).getNotifications(
                                        fromPagination: false,
                                        sortByNewest: true);
                                  }
                                }),
                                child: ListView.separated(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) =>
                                      NotificationItem(
                                    model: HomeCubit.get(context)
                                        .notifications[index],
                                  ),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    height: 15,
                                  ),
                                  itemCount: HomeCubit.get(context)
                                      .notifications
                                      .length,
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
