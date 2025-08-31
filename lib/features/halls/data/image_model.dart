class HallImage {
  late int id;
  late String url;

  HallImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['img'];
  }
}
