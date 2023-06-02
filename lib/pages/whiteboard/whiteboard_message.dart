class WhiteboardMessage {
  WhiteboardMessage(
      {required this.timePosted,
      required this.username,
      required this.userId,
      required this.dbId,
      required this.text});

  final String dbId;
  final String text;
  final DateTime timePosted;
  final String username;
  final String userId;

  @override
  String toString() {
    return text;
  }
}
