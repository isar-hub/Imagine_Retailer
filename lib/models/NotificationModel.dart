class NotificationModel {
  final String title;
  final String message;
  final DateTime createdAt;

  NotificationModel({
    required this.title,
    required this.message,
    required this.createdAt,
  });

  factory NotificationModel.fromFirestore(Map<String, dynamic> data) {
    return NotificationModel(
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      createdAt: DateTime.parse(data['createdAt']),
    );
  }
}
