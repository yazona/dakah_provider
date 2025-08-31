class RatePlayer {
  late int playerID;
  late double rateCount;
  String? rateText;

  RatePlayer({
    required this.playerID,
    required this.rateCount,
    this.rateText,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': playerID,
      'num_rate': rateCount,
      'text_rate': rateText,
    };
  }
}
