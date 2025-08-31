import 'package:cached_network_image/cached_network_image.dart';
import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/core/utils/cache_helper.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/core/widgets/body_with_header_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_appbar_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_button.dart';
import 'package:dakeh_service_provider/core/widgets/custom_loading_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_text_form_field.dart';
import 'package:dakeh_service_provider/core/widgets/drawer_widget.dart';
import 'package:dakeh_service_provider/core/widgets/translate_text_widget.dart';
import 'package:dakeh_service_provider/features/auth/presentation/screens/auth_screen.dart';
import 'package:dakeh_service_provider/features/home/manager/home_cubit.dart';
import 'package:dakeh_service_provider/features/home/manager/home_states.dart';
import 'package:dakeh_service_provider/features/home/presentation/widgets/edit_password_dialog_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static late int cityID;

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    var emailController = TextEditingController();
    emailController.text = AppConstants.user!.data.email;
    var nameController = TextEditingController();
    nameController.text = AppConstants.user!.data.name;
    var phoneController = TextEditingController();
    phoneController.text = AppConstants.user!.data.phone;
    var bankController = TextEditingController();
    bankController.text = AppConstants.user!.data.bank ?? '';
    var ibanController = TextEditingController();
    ibanController.text = AppConstants.user!.data.iban != null
        ? AppConstants.user!.data.iban.toString()
        : '';
    cityID = AppConstants.user!.data.cityID;
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is DeleteAccountSuccessState) {
          CacheHelper.deleteData(key: 'user');
          AppFunctions.navToWithoutBack(context, screen: const AuthScreen());
          HomeCubit.get(context).bottomNavIndex = 0;
          AppConstants.user = null;
        }
      },
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          drawer: AppDrawer(
            screenContext: context,
            scaffoldKey: scaffoldKey,
            user: AppConstants.user!,
          ),
          body: state is EditProfileLoadingState
              ? const CustomLoading()
              : SingleChildScrollView(
                  child: BodyWithAppHeader(
                    fromHome: false,
                    appBar: CustomAppBar(
                      rightType: ButtonAppBarType.menuButton,
                      title: Text(
                        '- ${'myAccount'.tr()} -',
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 30),
                      ),
                      leftType: ButtonAppBarType.backButton,
                      scaffoldKey: scaffoldKey,
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                '${AppConstants.kBaseURL}${AppConstants.user!.data.image}',
                            imageBuilder: (context, imageProvider) => Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                if (cubit.profileImage == null)
                                  CircleAvatar(
                                    radius: 65,
                                    backgroundImage: imageProvider,
                                  )
                                else
                                  CircleAvatar(
                                    radius: 65,
                                    backgroundImage: FileImage(
                                      cubit.profileImage!,
                                    ),
                                  ),
                                GestureDetector(
                                  onTap: () {
                                    cubit.pickProfileImage(ImageSource.gallery);
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: ColorsManager.kWhite,
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: ColorsManager.kPrimaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            placeholder: (context, url) => CircleAvatar(
                              backgroundColor:
                                  ColorsManager.kPrimaryColor.withAlpha(1),
                              radius: 65,
                              child: const SpinKitCubeGrid(
                                color: ColorsManager.kPrimaryColor,
                                size: 20,
                              ),
                            ),
                            errorWidget: (context, url, error) => CircleAvatar(
                              backgroundColor:
                                  ColorsManager.kPrimaryColor.withAlpha(1),
                              radius: 65,
                              child: const Icon(
                                Icons.error,
                                size: 20,
                                color: ColorsManager.kWhite,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.name,
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
                          DropdownButtonFormField(
                            value: cityID,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: SvgPicture.asset(
                                  AssetsManager.kCityIconSVG,
                                ),
                              ),
                              hintText: 'city'.tr(),
                              hintStyle: const TextStyle(
                                height: 0,
                                color: ColorsManager.kHintTextGrey,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
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
                            controller: bankController,
                            prefixIconSVGPath: AssetsManager.kBankIconSVG,
                            hintText: 'bankName'.tr(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'pleaseEnterBankName'.tr();
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextFormField(
                            controller: ibanController,
                            prefixIconSVGPath: AssetsManager.kIbanIconSVG,
                            hintText: 'ibanNumber'.tr(),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'pleaseEnterIbanNumber'.tr();
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(
                            height: 62,
                          ),
                          CustomButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                cubit.editProfile(
                                  name: nameController.text.trim(),
                                  email: emailController.text.trim(),
                                  phone: phoneController.text.trim(),
                                  bank: bankController.text.trim(),
                                  iban: ibanController.text.trim(),
                                  cityID: cityID,
                                );
                              }
                            },
                            title: 'edit'.tr(),
                            backgroundColor: ColorsManager.kPrimaryColor,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomButton(
                            onPressed: () {
                              AppFunctions.buildAppDialog(context,
                                  child: const EditPasswordDialog());
                            },
                            title: 'editPassword'.tr(),
                            backgroundColor: ColorsManager.kPrimaryColor,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomButton(
                            onPressed: () async {
                              AppFunctions.buildAppDialog(context,
                                  child:
                                      const DeleteAccountConfirmationDialog());
                            },
                            backgroundColor: ColorsManager.kRed,
                            borderColor: ColorsManager.kRed,
                            title: 'deleteAccount'.tr(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
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

class DeleteAccountConfirmationDialog extends StatelessWidget {
  const DeleteAccountConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return state is DeleteAccountLoadingState
            ? const SizedBox(
                height: 100,
                child: Center(
                  child: SpinKitCubeGrid(
                    color: ColorsManager.kPrimaryColor,
                  ),
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning,
                    color: ColorsManager.kPrimaryColor,
                    size: 50,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'deleteAccountConfirmation'.tr(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          onPressed: () => Navigator.pop(context, false),
                          title: 'cancel'.tr(),
                        ),
                      ),
                      Expanded(
                        child: CustomButton(
                          onPressed: () =>
                              HomeCubit.get(context).deleteAccount().then(
                            (value) {
                              if (context.mounted) {
                                Navigator.pop(context, true);
                              }
                            },
                          ),
                          borderColor: ColorsManager.kRed,
                          backgroundColor: ColorsManager.kRed,
                          title: 'confirm'.tr(),
                        ),
                      ),
                    ],
                  )
                ],
              );
      },
    );
  }
}
