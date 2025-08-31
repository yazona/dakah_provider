class EndPoints {
  ///AUTH ENDPOINTS
  static const String getCities = 'api/cities';
  static const String getVerificationCode = 'api/provider_auth/send_sms';
  static const String createNewAccount = 'api/provider_auth/register';
  static const String resetPassword = 'api/provider_auth/reset_password';
  static const String sendFCMToken = 'api/provider_auth/fcm_token';
  static const String login = 'api/provider_auth/login';
  static const String editProfile = 'api/provider_auth/update_provider_info';
  static const String logout = 'api/provider_auth/logout';
  static const String editPassword =
      'api/provider_auth/update_provider_password';
  static const String getTermsAndConditions = 'api/get_terms';
  static const String getPrivacyPolicy = 'api/get_policy';
  static const String contactUS = 'api/send_message';
  static const String getHalls = 'api/provider_app/halls/index';
  static const String addNewHall = 'api/provider_app/halls/store';
  static const String getHallInfo = 'api/provider_app/halls/hall_info';
  static const String deleteHall = 'api/provider_app/halls/destroy';
  static const String editHall = 'api/provider_app/halls/update';
  static const String getCurrentReservations =
      'api/provider_app/reserve/current_reservations';
  static const String getPreviousReservations =
      'api/provider_app/reserve/previous_reservations';
  static const String getReservationDetails =
      'api/provider_app/reserve/reserve_info';
  static const String acceptReservation = 'api/provider_app/reserve/accept';
  static const String checkCode = 'api/provider_auth/check_code';
  static const String getNotifications = 'api/provider_app/notifications/index';
  static const String deleteNotifications = 'api/provider_app/notifications/destroy';
  static const String deleteAllNotifications = 'api/provider_app/notifications/destroy_all';
  static const String changeHallActivation = 'api/provider_app/halls/change_activation';
  static const String getSetting = 'api/get_settings';
  static const String ratePlayers = 'api/provider_app/rates/store';
  static const String changeLanguage = 'api/provider_app/change_language';
  static const String deleteAccount = 'api/provider_auth/del_account';
  static const String changeGameStatus = 'api/provider_app/halls/update_game_activation';
}
