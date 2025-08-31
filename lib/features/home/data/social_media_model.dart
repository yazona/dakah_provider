class SocialMediaInfo{
  String? whatsApp;
  String? twitter;
  String? tikTok;
  String? snapChat;
  String? instagram;

  SocialMediaInfo.fromJson(Map<String,dynamic> json){
    whatsApp = json['whatsApp'];
    twitter = json['twitter'];
    tikTok = json['tiktok'];
    snapChat = json['snapshat'];
    instagram = json['instagram'];
  }
}