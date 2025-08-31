import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/core/widgets/body_with_header_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_appbar_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_button.dart';
import 'package:dakeh_service_provider/core/widgets/custom_loading_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_text_form_field.dart';
import 'package:dakeh_service_provider/core/widgets/drawer_widget.dart';
import 'package:dakeh_service_provider/features/home/manager/home_cubit.dart';
import 'package:dakeh_service_provider/features/home/manager/home_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUSScreen extends StatelessWidget {
  const ContactUSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    var nameController = TextEditingController();
    nameController.text = AppConstants.user!.data.name;
    var phoneController = TextEditingController();
    phoneController.text = AppConstants.user!.data.phone;
    var emailController = TextEditingController();
    emailController.text = AppConstants.user!.data.email;
    var subjectController = TextEditingController();
    var messageController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is ContactUSSuccessState) {
          subjectController.clear();
          messageController.clear();
          AppFunctions.buildSnackBar(
            context,
            text: 'messageSentSuccess'.tr(),
            icon: Icons.verified,
          );
        }
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          drawer: AppDrawer(
            user: AppConstants.user,
            scaffoldKey: scaffoldKey,
            screenContext: context,
          ),
          body: state is GetSocialMediaInfoLoadingState
              ? const CustomLoading()
              : SingleChildScrollView(
                  child: BodyWithAppHeader(
                    fromHome: false,
                    appBar: CustomAppBar(
                      rightType: ButtonAppBarType.menuButton,
                      scaffoldKey: scaffoldKey,
                      title: Text(
                        '- ${'contactUS'.tr()} -',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 30),
                      ),
                      leftType: ButtonAppBarType.backButton,
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          CustomTextFormField(
                            controller: nameController,
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
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
                            hintText: 'userName'.tr(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'pleaseEnterUsername'.tr();
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextFormField(
                            controller: phoneController,
                            prefixIconSVGPath: AssetsManager.kPhoneIconSVG,
                            hintText: 'phoneNumber'.tr(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'pleaseEnterPhoneNumber'.tr();
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextFormField(
                            controller: emailController,
                            prefixIconSVGPath: AssetsManager.kEmailIconSVG,
                            hintText: 'email'.tr(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'pleaseEnterEmailAddress'.tr();
                              } else if (!EmailValidator.validate(value)) {
                                return 'enterValidEmail'.tr();
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextFormField(
                            controller: subjectController,
                            autovalidateMode: AutovalidateMode.disabled,
                            prefixIconSVGPath: AssetsManager.kSubjectIconSVG,
                            hintText: 'subject'.tr(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'pleaseEnterSubject'.tr();
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextFormField(
                            controller: messageController,
                            autovalidateMode: AutovalidateMode.disabled,
                            prefixIconSVGPath:
                                AssetsManager.kTypeMessageIconSVG,
                            hintText: 'typeMessage'.tr(),
                            maxLines: 5,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'pleaseEnterMessage'.tr();
                              }
                              return null;
                            },
                            keyboardType: TextInputType.multiline,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomButton(
                            onPressed: state is ContactUSLoadingState
                                ? null
                                : () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    if (formKey.currentState!.validate()) {
                                      HomeCubit.get(context).contactUS(
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        email: emailController.text,
                                        subject: subjectController.text.trim(),
                                        message: messageController.text.trim(),
                                      );
                                    }
                                  },
                            title: 'send'.tr(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (cubit.socialMediaInfo.whatsApp != null)
                                IconButton(
                                  onPressed: () async {
                                    String url =
                                        'https://wa.me/${cubit.socialMediaInfo.whatsApp}';
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      launchUrl(Uri.parse(url));
                                    } else {
                                     
                                    }
                                  },
                                  icon: SvgPicture.asset(
                                      AssetsManager.kWhatsAppIconSVG),
                                ),
                              if (cubit.socialMediaInfo.twitter != null)
                                IconButton(
                                  onPressed: () async {
                                    String url =
                                        'https://x.com/${cubit.socialMediaInfo.twitter}';
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      launchUrl(Uri.parse(url));
                                    } else {
                                     
                                    }
                                  },
                                  icon: SvgPicture.asset(
                                      AssetsManager.kTwitterIconSVG),
                                ),
                              if (cubit.socialMediaInfo.instagram != null)
                                IconButton(
                                  onPressed: () async {
                                    String url =
                                        'https://www.instagram.com/${cubit.socialMediaInfo.instagram}';
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      launchUrl(Uri.parse(url));
                                    } else {
                                     
                                    }
                                  },
                                  icon: SvgPicture.asset(
                                      AssetsManager.kInstagramIconSVG),
                                ),
                              if (cubit.socialMediaInfo.tikTok != null)
                                IconButton(
                                  onPressed: () async {
                                    String url =
                                        'https://www.tiktok.com/${cubit.socialMediaInfo.tikTok}';
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      launchUrl(Uri.parse(url));
                                    } else {
                                     
                                    }
                                  },
                                  icon: SvgPicture.asset(
                                      AssetsManager.kTikTokIconSVG),
                                ),
                              if (cubit.socialMediaInfo.snapChat != null)
                                IconButton(
                                  onPressed: () async {
                                    String url =
                                        'https://www.snapchat.com/${cubit.socialMediaInfo.snapChat}';
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      launchUrl(Uri.parse(url));
                                    } else {
                                     
                                    }
                                  },
                                  icon: SvgPicture.asset(
                                      AssetsManager.kSnapchatIconSVG),
                                ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
