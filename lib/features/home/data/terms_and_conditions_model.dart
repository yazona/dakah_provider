class TermsAndConditions {
  late String termsAR;
  late String termsEN;

  TermsAndConditions.fromJson(Map<String,dynamic> json){
    termsAR = json['data']['terms_provider_ar'];
    termsEN = json['data']['terms_provider_en'];
  }
}