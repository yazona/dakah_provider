import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dakeh_service_provider/core/widgets/custom_button.dart';
import 'package:dakeh_service_provider/core/widgets/custom_loading_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_text_form_field.dart';
import 'package:dakeh_service_provider/core/widgets/translate_text_widget.dart';
import 'package:dakeh_service_provider/features/auth/manager/auth_cubit.dart';
import 'package:dakeh_service_provider/features/auth/manager/auth_states.dart';
import 'package:dakeh_service_provider/features/auth/presentation/widgets/custom_checkbox_form_filed.dart';
import 'package:dakeh_service_provider/features/home/manager/home_cubit.dart';
import 'package:dakeh_service_provider/features/home/manager/home_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
    required this.cubit,
  });

  final AuthCubit cubit;
  static final passwordController = TextEditingController();
  static final phoneController = TextEditingController();
  static final nameController = TextEditingController();
  static final emailController = TextEditingController();
  static final formKey = GlobalKey<FormState>();
  static int? cityID;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is CreateNewAccountSuccessState) {
          passwordController.clear();
          phoneController.clear();
          nameController.clear();
          emailController.clear();
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                controller: nameController,
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: 28,
                    height: 28,
                    alignment: AlignmentDirectional.center,
                    decoration: const BoxDecoration(
                      color: ColorsManager.kPrimaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      AssetsManager.kUserWithoutBackgroundIconSVG,
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        ColorsManager.kWhite,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'pleaseEnterUsername'.tr();
                  } else if (value.length < 5) {
                    return 'usernameIsShort'.tr();
                  }
                  return null;
                },
                hintText: 'userName'.tr(),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                controller: phoneController,
                prefixIconSVGPath: AssetsManager.kPhoneIconSVG,
                keyboardType: TextInputType.phone,
                hintText: 'phoneNumber'.tr(),
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
                height: 20,
              ),
              CustomTextFormField(
                controller: emailController,
                prefixIconSVGPath: AssetsManager.kEmailIconSVG,
                keyboardType: TextInputType.emailAddress,
                hintText: 'email'.tr(),
                validator: (value) {
                  if (!EmailValidator.validate(value!)) {
                    return 'enterValidEmail'.tr();
                  } else if (value.isEmpty) {
                    return 'pleaseEnterEmailAddress'.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              AppConstants.cities.isEmpty
                  ? const Center(
                      child: LinearProgressIndicator(),
                    )
                  : DropdownButtonFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      items: List.generate(
                        AppConstants.cities.length,
                        (index) => DropdownMenuItem(
                          value: AppConstants.cities[index].id,
                          child: TranslateText(
                            textAR: AppConstants.cities[index].nameAR,
                            textEN: AppConstants.cities[index].nameEN,
                          ),
                        ),
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: ColorsManager.kWhite,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: ColorsManager.kWhite,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: ColorsManager.kWhite,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: ColorsManager.kRed,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: ColorsManager.kRed,
                          ),
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SvgPicture.asset(
                            AssetsManager.kCityIconSVG,
                          ),
                        ),
                        hintText: 'city'.tr(),
                        hintStyle: const TextStyle(
                            height: 0,
                            color: ColorsManager.kHintTextGrey,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'pleaseChooseCity'.tr();
                        }
                        return null;
                      },
                      onChanged: (value) {
                        cityID = value!;
                      },
                    ),
              const SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                controller: passwordController,
                obscureText: cubit.registerIsPassword,
                prefixIconSVGPath: AssetsManager.kPasswordIconSVG,
                keyboardType: TextInputType.visiblePassword,
                hintText: 'password'.tr(),
                suffixIcon: IconButton(
                  icon: Icon(
                    cubit.registerPasswordPrefixIcon,
                    size: 18,
                    color: ColorsManager.kHintTextGrey,
                  ),
                  onPressed: () => cubit.showRegisterPassword(),
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
              CheckboxFormFiled(
                title: Row(
                  children: [
                    Text(
                      'iAgreeTo'.tr(),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            HomeCubit.get(context).getPrivacyPolicy();
                            return BlocConsumer<HomeCubit, HomeStates>(
                              listener: (context, state) {},
                              builder: (context, state) {
                                return state is GetPrivacyPolicyLoadingState
                                    ? const CustomLoading()
                                    : Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        insetPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Html(
                                                  data: context.locale
                                                              .languageCode ==
                                                          'ar'
                                                      ? HomeCubit.get(context)
                                                          .privacyPolicy
                                                          .privacyAR
                                                      : HomeCubit.get(context)
                                                          .privacyPolicy
                                                          .privacyEN,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: CustomButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    title: 'done'.tr(),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ));
                              },
                            );
                          },
                        );
                      },
                      child: Text(
                        ' ${'privacyAndPolicy'.tr()} ',
                        style: const TextStyle(
                          color: ColorsManager.kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'and'.tr(),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              HomeCubit.get(context).getTermsAndConditions();
                              return BlocConsumer<HomeCubit, HomeStates>(
                                listener: (context, state) {},
                                builder: (context, state) {
                                  return state is GetTermsAndConditionsLoadingState
                                      ? const CustomLoading()
                                      : Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      insetPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Html(
                                                data: context.locale
                                                    .languageCode ==
                                                    'ar'
                                                    ? HomeCubit.get(context)
                                                    .termsAndConditions
                                                    .termsAR
                                                    : HomeCubit.get(context)
                                                    .termsAndConditions
                                                    .termsEN,
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: CustomButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  title: 'done'.tr(),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ));
                                },
                              );
                            },
                          );
                        },
                        child: Text(
                          ' ${'termsAndConditions'.tr()} ',
                          style: const TextStyle(
                              color: ColorsManager.kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                isChecked: cubit.registerAgreeTermsAndConditions,
                onChanged: (p0) {
                  cubit.changeAcceptedRegisterTermsAndConditions(p0!);
                },
                validator: (value) {
                  if (!value!) {
                    return 'pleaseAgreePrivacyPolicy'.tr();
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                onPressed: AppConstants.cities.isEmpty
                    ? null
                    : () {
                        if (formKey.currentState!.validate()) {
                          cubit.getVerificationCode(
                            name: nameController.text.trim(),
                            email: emailController.text.trim(),
                            phone: phoneController.text.trim(),
                            password: passwordController.text.trim(),
                            cityID: cityID!,
                          );
                        }
                      },
                title: 'register'.tr(),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}
