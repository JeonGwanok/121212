import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final int? id;
  final String? title;
  final String? content;

  const NotificationModel({this.id, this.title, this.content});

  static const empty = NotificationModel();

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json["id"],
      title: json["title"],
      content: json["content"],
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
      ];
}
