abstract class HomeStates {}

class HomeInitState extends HomeStates {}

class ChangeBottomNavIndexState extends HomeStates {}

class GetCitiesLoadingState extends HomeStates {}

class GetCitiesSuccessState extends HomeStates {}

class EditProfileLoadingState extends HomeStates {}

class EditProfileSuccessState extends HomeStates {}

class EditProfileErrorState extends HomeStates {}

class LogoutLoadingState extends HomeStates {}

class LogoutSuccessState extends HomeStates {}

class LogoutErrorState extends HomeStates {}

class DeleteAccountLoadingState extends HomeStates {}

class DeleteAccountSuccessState extends HomeStates {}

class DeleteAccountErrorState extends HomeStates {}

class ShowPasswordState extends HomeStates {}

class EditPasswordLoadingState extends HomeStates {}

class EditPasswordSuccessState extends HomeStates {}

class EditPasswordErrorState extends HomeStates {}

class GetTermsAndConditionsLoadingState extends HomeStates {}

class GetTermsAndConditionsSuccessState extends HomeStates {}

class GetTermsAndConditionsErrorState extends HomeStates {}

class GetPrivacyPolicyLoadingState extends HomeStates {}

class GetPrivacyPolicySuccessState extends HomeStates {}

class GetPrivacyPolicyErrorState extends HomeStates {}

class ContactUSLoadingState extends HomeStates {}

class ContactUSSuccessState extends HomeStates {}

class ContactUSErrorState extends HomeStates {}

class PickProfileImageState extends HomeStates {}

class GetNotificationsLoadingState extends HomeStates {}

class GetNotificationsErrorState extends HomeStates {}

class GetNotificationsSuccessState extends HomeStates {}

class GetSocialMediaInfoLoadingState extends HomeStates {}

class GetSocialMediaInfoSuccessState extends HomeStates {}

class GetSocialMediaInfoErrorState extends HomeStates {}

class ChangeLanguageLoadingState extends HomeStates {}

class ChangeLanguageSuccessState extends HomeStates {
  final String langCode;

  ChangeLanguageSuccessState({required this.langCode});
}

class ChangeLanguageErrorState extends HomeStates {}
