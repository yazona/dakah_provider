import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/core/widgets/custom_loading_widget.dart';
import 'package:dakeh_service_provider/features/auth/manager/auth_cubit.dart';
import 'package:dakeh_service_provider/features/auth/manager/auth_states.dart';
import 'package:dakeh_service_provider/features/auth/presentation/screens/otp_screen.dart';
import 'package:dakeh_service_provider/features/auth/presentation/widgets/custom_tab_bar_widget.dart';
import 'package:dakeh_service_provider/features/auth/presentation/widgets/login_form_widget.dart';
import 'package:dakeh_service_provider/features/auth/presentation/widgets/register_form_widget.dart';
import 'package:dakeh_service_provider/features/home/presentation/screens/home_layout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit()..getCities(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is GetVerificationCodeSuccessState) {
            if (!state.fromResend) {
              AppFunctions.navTo(context,
                  screen: BlocProvider.value(
                    value: AuthCubit.get(context),
                    child: const OTPScreen(),
                  ));
            }
          }
          if (state is GetVerificationCodeErrorState) {
            if (state.emailError) {
              AppFunctions.buildSnackBar(context,
                  text: 'checkUsedEmail'.tr(),
                  title: 'usedEmail'.tr(),
                  icon: Icons.error,
                  backgroundColor: ColorsManager.kRed);
              return;
            }
            if (state.phoneError) {
              AppFunctions.buildSnackBar(context,
                  text: 'checkUsedPhone'.tr(),
                  title: 'usedPhone'.tr(),
                  icon: Icons.error,
                  backgroundColor: ColorsManager.kRed);
              return;
            }
          }
          if (state is LoginErrorState) {
            AppFunctions.buildSnackBar(context,
                text: 'checkEmailOrPassword'.tr(),
                title: 'errorOccurred'.tr(),
                icon: Icons.error,
                backgroundColor: ColorsManager.kRed);
          }
          if (state is LoginSuccessState) {
            AppFunctions.navToWithoutBack(context, screen: const HomeLayout());
          }
        },
        builder: (context, state) {
          var cubit = AuthCubit.get(context);
          return Scaffold(
            body: state is GetVerificationCodeLoadingState ||
                    state is LoginLoadingState
                ? const CustomLoading()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .5,
                          color:
                              ColorsManager.kAppBarBackgroundColor.withAlpha(1),
                          child: CustomTabBar(
                            isLoginSelected: cubit.isLoginSelected,
                            loginOnTap: () => cubit.changeIsLoginSelected(true),
                            registerOnTap: () =>
                                cubit.changeIsLoginSelected(false),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: cubit.isLoginSelected
                              ? LoginForm(cubit: cubit)
                              : RegisterForm(
                                  cubit: cubit,
                                ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
