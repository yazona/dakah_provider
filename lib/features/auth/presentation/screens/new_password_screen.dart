import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/core/widgets/custom_appbar_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_button.dart';
import 'package:dakeh_service_provider/core/widgets/custom_loading_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_text_form_field.dart';
import 'package:dakeh_service_provider/features/auth/manager/auth_cubit.dart';
import 'package:dakeh_service_provider/features/auth/manager/auth_states.dart';
import 'package:dakeh_service_provider/features/auth/presentation/screens/auth_screen.dart';
import 'package:dakeh_service_provider/features/auth/presentation/widgets/otp_header_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var passwordController = TextEditingController();
    var confirmPasswordController = TextEditingController();
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is ResetPasswordSuccessState) {
          AuthCubit.get(context).changeIsLoginSelected(true);
          AppFunctions.navToWithoutBack(context, screen: const AuthScreen());
          AppFunctions.buildSnackBar(context,
              text: 'reLoginWithNewPassword'.tr(),
              title: 'passwordReset'.tr(),
              icon: Icons.verified);
        }
      },
      builder: (context, state) {
        var cubit = AuthCubit.get(context);
        return Scaffold(
          body: state is ResetPasswordLoadingState
              ? const CustomLoading()
              : Stack(
            children: [
              const OTPHeader(),
              SingleChildScrollView(
                padding: const EdgeInsets.only(top: 180),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * .3,
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomTextFormField(
                          controller: passwordController,
                          obscureText: cubit.resetIsPassword,
                          prefixIconSVGPath:
                          AssetsManager.kPasswordIconSVG,
                          keyboardType: TextInputType.visiblePassword,
                          hintText: 'newPassword'.tr(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              cubit.resetPasswordPrefixIcon,
                              size: 18,
                              color: ColorsManager.kHintTextGrey,
                            ),
                            onPressed: () => cubit.showResetPassword(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'pleaseEnterYourPassword'.tr();
                            }
                            if (!RegExp('(?=.*[A-Z])').hasMatch(value)) {
                              return 'passwordContain1UpperCase'.tr();
                            }
                            if (!RegExp('(?=.*[a-z])').hasMatch(value)) {
                              return 'passwordContain1LowerCase'.tr();
                            }
                            if (!RegExp('(?=.*?[0-9])').hasMatch(value)) {
                              return 'passwordContain1LowerCase'.tr();
                            }
                            if (!RegExp('(?=.*?[!@#\$&*~])')
                                .hasMatch(value)) {
                              return 'passwordContain1SpecialChar'.tr();
                            }
                            if (value.length < 8) {
                              return 'enterPassword8Char'.tr();
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomTextFormField(
                          controller: confirmPasswordController,
                          obscureText: cubit.confirmResetIsPassword,
                          prefixIconSVGPath:
                          AssetsManager.kPasswordIconSVG,
                          keyboardType: TextInputType.visiblePassword,
                          hintText: 'confirmNewPassword'.tr(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              cubit.confirmResetPasswordPrefixIcon,
                              size: 18,
                              color: ColorsManager.kHintTextGrey,
                            ),
                            onPressed: () =>
                                cubit.showConfirmResetPassword(),
                          ),
                          validator: (value) {
                            if (value != passwordController.text.trim()) {
                              return 'passwordsDontMatch'.tr();
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CustomButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              cubit.resetPassword(
                                password: passwordController.text,
                              );
                            }
                          },
                          title: 'accept'.tr(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const CustomAppBar(
                rightType: ButtonAppBarType.backButton,
                leftType: ButtonAppBarType.none,
              ),

            ],
          ),
        );
      },
    );
  }
}
