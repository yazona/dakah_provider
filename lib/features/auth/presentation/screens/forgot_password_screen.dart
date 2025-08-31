import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/core/widgets/custom_appbar_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_button.dart';
import 'package:dakeh_service_provider/core/widgets/custom_loading_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_text_form_field.dart';
import 'package:dakeh_service_provider/features/auth/manager/auth_cubit.dart';
import 'package:dakeh_service_provider/features/auth/manager/auth_states.dart';
import 'package:dakeh_service_provider/features/auth/presentation/screens/otp_reset_password_screen.dart';
import 'package:dakeh_service_provider/features/auth/presentation/widgets/otp_header_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var phoneController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          var cubit = AuthCubit.get(context);
          if (state is GetVerificationCodeResetPasswordSuccessState) {
            if (!state.fromResend) {
              AppFunctions.navTo(context,
                  screen: BlocProvider.value(
                    value: cubit,
                    child: const OTPResetPasswordScreen(),
                  ));
            }
          }
          if (state is GetVerificationCodeResetPasswordErrorState) {
            AppFunctions.buildSnackBar(context,
                text: 'noAccount'.tr(),
                title: 'checkPhone'.tr(),
                backgroundColor: ColorsManager.kRed,
                icon: Icons.error);
          }
        },
        builder: (context, state) {
          var cubit = AuthCubit.get(context);
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: state is GetVerificationCodeResetPasswordLoadingState
                ? const CustomLoading()
                : Stack(
                    children: [
                      const OTPHeader(),
                      const CustomAppBar(
                        rightType: ButtonAppBarType.backButton,
                        leftType: ButtonAppBarType.none,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 180, left: 20, right: 20),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomTextFormField(
                                controller: phoneController,
                                hintText: 'phoneNumber'.tr(),
                                keyboardType: TextInputType.phone,
                                prefixIconSVGPath: AssetsManager.kPhoneIconSVG,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'pleaseEnterPhoneNumber'.tr();
                                  }
                                  if (!value.startsWith('05')) {
                                    return 'phoneNumberMustStartWith05'.tr();
                                  }
                                  if (value.length != 10) {
                                    return 'pleaseEnterValidPhoneNumber'.tr();
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'pleaseEnterValidPhoneNumber'.tr();
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 35,
                              ),
                              CustomButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.getVerificationCodeResetPassword(
                                      fromResend: false,
                                      phone: phoneController.text.trim(),
                                    );
                                  }
                                },
                                title: 'accept'.tr(),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
          );
        },
      ),
    );
  }
}
