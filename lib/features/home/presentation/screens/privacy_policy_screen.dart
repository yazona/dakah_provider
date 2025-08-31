import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dakeh_service_provider/core/widgets/body_with_header_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_appbar_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_loading_widget.dart';
import 'package:dakeh_service_provider/core/widgets/drawer_widget.dart';
import 'package:dakeh_service_provider/features/home/manager/home_cubit.dart';
import 'package:dakeh_service_provider/features/home/manager/home_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          drawer: AppDrawer(
            user: AppConstants.user,
            scaffoldKey: scaffoldKey,
            screenContext: context,
          ),
          body: state is GetPrivacyPolicyLoadingState
              ? const CustomLoading()
              : SingleChildScrollView(
                  child: BodyWithAppHeader(
                    fromHome: false,
                    appBar: CustomAppBar(
                      rightType: ButtonAppBarType.menuButton,
                      scaffoldKey: scaffoldKey,
                      title: Text(
                        '- ${'privacyAndPolicy'.tr()} -',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 30),
                      ),
                      leftType: ButtonAppBarType.backButton,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          color: ColorsManager.kWhite,
                          borderRadius: BorderRadius.circular(10)),
                      child: Html(
                        data: context.locale.languageCode == 'ar'
                            ? cubit.privacyPolicy.privacyAR
                            : cubit.privacyPolicy.privacyEN,
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
