class NewUser {
  late String name;
  late String email;
  late String phone;
  late String password;
  late int cityID;

  NewUser({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.cityID,
  });

  Map<String,dynamic> toMap(){
    return {
      'name' : name,
      'email' : email,
      'mobile' : phone,
      'password' : password,
      'password_confirmation' : password,
      'city_id' : cityID,
    };
  }
}
