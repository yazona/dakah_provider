import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/core/widgets/custom_button.dart';
import 'package:dakeh_service_provider/core/widgets/custom_text_form_field.dart';
import 'package:dakeh_service_provider/features/auth/manager/auth_cubit.dart';
import 'package:dakeh_service_provider/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.cubit,
  });

  final AuthCubit cubit;
  static final passwordController = TextEditingController();
  static final phoneController = TextEditingController();
  static final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          controller: phoneController,
          prefixIconSVGPath: AssetsManager.kPhoneIconSVG,
          keyboardType: TextInputType.phone,
          hintText: 'phoneNumber'.tr(),
          validator: (value) {
            if (value!.isEmpty) {
              return 'pleaseEnterPhoneNumber'.tr();
            }
            return null;
          },
        ),
        const SizedBox(
          height: 20,
        ),
        CustomTextFormField(
          controller: passwordController,
          maxLines: 1,
          prefixIconSVGPath: AssetsManager.kPasswordIconSVG,
          keyboardType: TextInputType.visiblePassword,
          hintText: 'password'.tr(),
          obscureText: cubit.loginIsPassword,
          suffixIcon: IconButton(
            icon: Icon(
              cubit.loginPasswordPrefixIcon,
              size: 18,
              color: ColorsManager.kHintTextGrey,
            ),
            onPressed: () => cubit.showLoginPassword(),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'pleaseEnterYourPassword'.tr();
            }
            return null;
          },
        ),
        const SizedBox(
          height: 9,
        ),
        TextButton(
          onPressed: () =>
              AppFunctions.navTo(context, screen: const ForgotPasswordScreen()),
          child: Text(
            'forgotPassword'.tr(),
            style: const TextStyle(
                color: ColorsManager.kHintTextGrey,
                fontSize: 15,
                fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(
          height: 41,
        ),
        CustomButton(
          onPressed: () => cubit.login(
            phone: phoneController.text.trim(),
            password: passwordController.text.trim(),
          ).then((value) {
            phoneController.clear();
            passwordController.clear();
          }),
          title: 'login'.tr(),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
