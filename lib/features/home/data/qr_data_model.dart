class OrderQRData {
  late int id;
  late String providerName;

  OrderQRData.fromJson(Map<String, dynamic> json) {
    id = json['orderID'];
    providerName = json['providerName'];
  }
}
