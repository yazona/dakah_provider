class City {
  late int id;
  late String nameAR;
  late String nameEN;

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameAR = json['name_ar'];
    nameEN = json['name_en'];
  }
}
