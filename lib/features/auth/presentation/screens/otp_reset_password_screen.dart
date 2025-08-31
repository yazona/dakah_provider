import 'package:dakeh_service_provider/core/utils/assets_manager.dart';
import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/core/widgets/custom_appbar_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_button.dart';
import 'package:dakeh_service_provider/core/widgets/custom_loading_widget.dart';
import 'package:dakeh_service_provider/features/auth/manager/auth_cubit.dart';
import 'package:dakeh_service_provider/features/auth/manager/auth_states.dart';
import 'package:dakeh_service_provider/features/auth/presentation/screens/new_password_screen.dart';
import 'package:easy_localization/easy_localization.dart' as local;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class OTPResetPasswordScreen extends StatelessWidget {
  const OTPResetPasswordScreen({super.key});

  static String code = '';

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is GetVerificationCodeResetPasswordSuccessState) {
          if (state.fromResend) {
            AppFunctions.buildSnackBar(context,
                text: 'verificationCodeResent'.tr(), icon: Icons.verified);
          }
        }
        if (state is CheckVerificationCodeSuccessState) {
          var cubit = AuthCubit.get(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: cubit,
                child: const NewPasswordScreen(),
              ),
            ),
          );
        }
        if (state is CheckVerificationCodeErrorState) {
          AppFunctions.buildSnackBar(context,
              text: 'checkCode'.tr(),
              title: 'wrongCode'.tr(),
              icon: Icons.error,
              backgroundColor: ColorsManager.kRed);
        }
      },
      builder: (context, state) {
        var cubit = AuthCubit.get(context);
        return Scaffold(
          body: state is CheckVerificationCodeLoadingState ||
                  state is GetVerificationCodeResetPasswordLoadingState
              ? const CustomLoading()
              : Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: AlignmentDirectional.topCenter,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(bottom: 50),
                          // height: MediaQuery.of(context).size.height * .60,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(
                                AssetsManager.kOnBoardHeaderImage,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              const CustomAppBar(
                                rightType: ButtonAppBarType.backButton,
                                leftType: ButtonAppBarType.none,
                              ),
                              Image.asset(
                                AssetsManager.kDakehLogoIconPNG,
                                width: 150,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Pinput(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'pleaseEnterVerificationCode'.tr();
                                }
                                return null;
                              },
                              focusedPinTheme: PinTheme(
                                  width: 75,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3EFFFF),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  textStyle: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w500)),
                              defaultPinTheme: PinTheme(
                                  width: 75,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: ColorsManager.kWhite,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  textStyle: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w500)),
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              onChanged: (value) {},
                              onCompleted: (value) {
                                code = value;
                              },
                              separatorBuilder: (index) => const SizedBox(
                                width: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'dontReceiveCode'.tr(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 19),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            TextButton(
                              style: const ButtonStyle(
                                  padding: WidgetStatePropertyAll(
                                      EdgeInsets.zero)),
                              onPressed: () =>
                                  cubit.getVerificationCodeResetPassword(
                                phone: cubit.resetPasswordPhoneNumber!,
                                fromResend: true,
                              ),
                              child: Text(
                                'resend'.tr(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 19),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: CustomButton(
                            onPressed: () {
                             
                              if (formKey.currentState!.validate()) {
                                cubit.checkCode(code: code);
                                cubit.checkCode(code: code);
                              }
                            },
                            title: 'confirm'.tr(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
