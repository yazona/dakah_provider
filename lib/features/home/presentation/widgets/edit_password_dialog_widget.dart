import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/core/widgets/custom_button.dart';
import 'package:dakeh_service_provider/core/widgets/custom_text_form_field.dart';
import 'package:dakeh_service_provider/features/home/manager/home_cubit.dart';
import 'package:dakeh_service_provider/features/home/manager/home_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EditPasswordDialog extends StatelessWidget {
  const EditPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    var newPasswordController = TextEditingController();
    var oldPasswordController = TextEditingController();
    var confirmPasswordController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is EditPasswordErrorState) {
          Navigator.pop(context);
          AppFunctions.buildSnackBar(
            context,
            text: 'checkWrongPassword'.tr(),
            title: 'wrongOldPassword'.tr(),
            backgroundColor: ColorsManager.kRed,
            icon: Icons.error,
          );
        }
        if (state is EditPasswordSuccessState) {
          Navigator.pop(context);
          AppFunctions.buildSnackBar(
            context,
            text: 'passwordChanged'.tr(),
            backgroundColor: ColorsManager.kPrimaryColor,
            icon: Icons.verified,
          );
        }
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return SingleChildScrollView(
          child: state is EditPasswordLoadingState
              ? const SizedBox(
                  height: 200,
                  child: Center(
                    child: SpinKitCubeGrid(
                      color: ColorsManager.kPrimaryColor,
                    ),
                  ),
                )
              : Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'editPassword'.tr(),
                        style: const TextStyle(
                            color: Colors.transparent,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            decorationColor: ColorsManager.kPrimaryColor,
                            decoration: TextDecoration.underline,
                            shadows: [
                              Shadow(
                                  color: ColorsManager.kPrimaryColor,
                                  offset: Offset(0, -10)),
                            ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        controller: oldPasswordController,
                        hintText: 'oldPassword'.tr(),
                        prefixIconSVGPath: AssetsManager.kPasswordIconSVG,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: cubit.oldIsPassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'pleaseEnterOldPassword'.tr();
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          onPressed: () => cubit.showOldPassword(),
                          icon: Icon(
                            cubit.oldPasswordSuffixIcon,
                            color: ColorsManager.kHintTextGrey,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        controller: newPasswordController,
                        obscureText: cubit.newIsPassword,
                        prefixIconSVGPath: AssetsManager.kPasswordIconSVG,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: 'newPassword'.tr(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            cubit.newPasswordSuffixIcon,
                            size: 18,
                            color: ColorsManager.kHintTextGrey,
                          ),
                          onPressed: () => cubit.showNewPassword(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'pleaseEnterNewPassword'.tr();
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
                          if (!RegExp('(?=.*?[!@#\$&*~])').hasMatch(value)) {
                            return 'passwordContain1SpecialChar'.tr();
                          }
                          if (value.length < 8) {
                            return 'enterPassword8Char'.tr();
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                        controller: confirmPasswordController,
                        hintText: 'confirmNewPassword'.tr(),
                        prefixIconSVGPath: AssetsManager.kPasswordIconSVG,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: cubit.confirmIsPassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'pleaseConfirmNewPassword'.tr();
                          } else if (value != newPasswordController.text) {
                            return 'passwordsDontMatch'.tr();
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          onPressed: () => cubit.showConfirmPassword(),
                          icon: Icon(
                            cubit.confirmPasswordSuffixIcon,
                            color: ColorsManager.kHintTextGrey,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  cubit.editPassword(
                                    oldPassword: oldPasswordController.text,
                                    newPassword: newPasswordController.text,
                                  );
                                }
                              },
                              title: 'accept'.tr(),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: CustomButton(
                              onPressed: () => Navigator.of(context).pop(),
                              borderColor: ColorsManager.kBottomNavTextGrey,
                              backgroundColor: ColorsManager.kBottomNavTextGrey,
                              title: 'cancel'.tr(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
