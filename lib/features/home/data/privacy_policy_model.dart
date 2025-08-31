class PrivacyPolicy {
  late String privacyAR;
  late String privacyEN;

  PrivacyPolicy.fromJson(Map<String,dynamic> json){
    privacyAR = json['data']['privacy_policy_provider_ar'];
    privacyEN = json['data']['privacy_policy_provider_en'];
  }
}