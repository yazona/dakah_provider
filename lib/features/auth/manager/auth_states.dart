abstract class AuthStates {}

class AuthInitState extends AuthStates {}

class ChangeIsLoginSelectedState extends AuthStates {}

class GetCitiesLoadingState extends AuthStates {}

class GetCitiesSuccessState extends AuthStates {}

class ShowRegisterPasswordState extends AuthStates {}

class GetUserLocationSuccessState extends AuthStates {}

class GetUserLocationErrorState extends AuthStates {}

class GetVerificationCodeLoadingState extends AuthStates {}

class GetVerificationCodeSuccessState extends AuthStates {
  final bool fromResend;

  GetVerificationCodeSuccessState({
    required this.fromResend,
  });
}

class GetVerificationCodeErrorState extends AuthStates {
  final bool phoneError;
  final bool emailError;

  GetVerificationCodeErrorState(
      {required this.phoneError, required this.emailError});
}

class CreateNewAccountSuccessState extends AuthStates {}

class CreateNewAccountLoadingState extends AuthStates {}

class CreateNewAccountErrorState extends AuthStates {}

class GetVerificationCodeResetPasswordLoadingState extends AuthStates {}

class GetVerificationCodeResetPasswordSuccessState extends AuthStates {
  final bool fromResend;

  GetVerificationCodeResetPasswordSuccessState({
    required this.fromResend,
  });
}

class GetVerificationCodeResetPasswordErrorState extends AuthStates {}

class ResetPasswordSuccessState extends AuthStates {}

class ResetPasswordLoadingState extends AuthStates {}

class ResetPasswordErrorState extends AuthStates {}

class LoginSuccessState extends AuthStates {}

class LoginLoadingState extends AuthStates {}

class LoginErrorState extends AuthStates {}

class CheckVerificationCodeSuccessState extends AuthStates {}

class CheckVerificationCodeLoadingState extends AuthStates {}

class CheckVerificationCodeErrorState extends AuthStates {}

class ChangeCheckboxState extends AuthStates {}
