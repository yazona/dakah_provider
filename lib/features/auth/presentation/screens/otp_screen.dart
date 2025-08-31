import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/core/widgets/custom_appbar_widget.dart';
import 'package:dakeh_service_provider/core/widgets/custom_button.dart';
import 'package:dakeh_service_provider/core/widgets/custom_loading_widget.dart';
import 'package:dakeh_service_provider/features/auth/manager/auth_cubit.dart';
import 'package:dakeh_service_provider/features/auth/manager/auth_states.dart';
import 'package:dakeh_service_provider/features/auth/presentation/widgets/otp_header_widget.dart';
import 'package:easy_localization/easy_localization.dart' as local;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({
    super.key,
  });

  static String code = '';

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is GetVerificationCodeSuccessState) {
          AppFunctions.buildSnackBar(context,
              text: 'verificationCodeResent'.tr(), icon: Icons.verified);
        }
        if (state is CreateNewAccountErrorState) {
          AppFunctions.buildSnackBar(context,
              text: 'checkCode'.tr(),
              title: 'wrongCode'.tr(),
              icon: Icons.error,
              backgroundColor: ColorsManager.kRed);
        }
        if (state is CreateNewAccountSuccessState) {
          AuthCubit.get(context).changeIsLoginSelected(true);
          Navigator.pop(context);
          AppFunctions.buildSnackBar(
            context,
            text: 'reLogin'.tr(),
            title: 'accountCreated'.tr(),
            icon: Icons.verified,
          );
        }
      },
      builder: (context, state) {
        var cubit = AuthCubit.get(context);
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: state is GetVerificationCodeLoadingState ||
                  state is CreateNewAccountLoadingState
              ? const CustomLoading()
              : Stack(
                  children: [
                    const OTPHeader(),
                    const CustomAppBar(
                      rightType: ButtonAppBarType.backButton,
                      leftType: ButtonAppBarType.none,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 3.20,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: Pinput(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'الرجاء إدخال كود التحقق';
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    fontWeight: FontWeight.w500,
                                    fontSize: 19),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              TextButton(
                                style: const ButtonStyle(
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.zero)),
                                onPressed: () => cubit.getVerificationCode(
                                  name: cubit.newUser!.name,
                                  email: cubit.newUser!.email,
                                  phone: cubit.newUser!.phone,
                                  password: cubit.newUser!.password,
                                  cityID: cubit.newUser!.cityID,
                                  fromResend: true,
                                ),
                                child: Text(
                                  'resend'.tr(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 19),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 34,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: CustomButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  cubit.createNewAccount(code);
                                }
                              },
                              title: 'confirm'.tr(),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
        );
      },
    );
  }
}
