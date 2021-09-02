class Todo {
  final String id;
  final String title;
  final DateTime createdAt;
  final int notificationId;
  DateTime? scheduleDate;
  bool isNotify;
  bool isFavorite;
  Todo({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.notificationId,
    this.scheduleDate,
    this.isNotify = false,
    this.isFavorite = false,
  });
}
