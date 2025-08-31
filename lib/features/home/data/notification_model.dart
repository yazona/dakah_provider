import 'package:easy_localization/easy_localization.dart';

class NotificationData {
  late int id;
  late int reserveID;
  late String titleAR;
  late String titleEN;
  late String msgEN;
  late String msgAR;
  late DateTime createdAt;
  late String time;

  NotificationData.formJson(Map<String,dynamic> json){
    id = json['id'];
    reserveID = int.parse(json['reserve_id']);
    titleAR = json['title_ar'];
    titleEN = json['title_en'];
    msgAR = json['msg_ar'];
    msgEN = json['msg_en'];
    createdAt = DateTime.parse(json['created_at']);
    time = DateFormat.jm().format(createdAt);
  }
}