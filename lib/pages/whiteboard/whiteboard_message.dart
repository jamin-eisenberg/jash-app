class WhiteboardMessage {
  WhiteboardMessage({required this.dbId, required this.message});

  final String dbId;
  final String message;

  @override
  String toString() {
    return message;
  }
}