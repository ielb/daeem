import 'dart:convert';



class Notification {
  String? id;
  String title;
  String body;
  Notification({
    this.id,
    required this.title,
    required this.body,
  });

  Notification copyWith({
    String? id,
    String? title,
    String? body,
  }) {
    return Notification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      title: map['title'],
      body: map['body'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Notification.fromJson(String source) => Notification.fromMap(json.decode(source));

  @override
  String toString() => 'Notification(id: $id, title: $title, body: $body)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Notification &&
      other.id == id &&
      other.title == title &&
      other.body == body;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ body.hashCode;
}
