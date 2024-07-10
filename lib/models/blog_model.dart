import 'dart:convert';

class BlogPost {
  String id;
  String title;
  String subTitle;
  String body;
  DateTime dateCreated;
  BlogPost({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.body,
    required this.dateCreated,
  });

  BlogPost copyWith({
    String? id,
    String? title,
    String? subTitle,
    String? body,
    DateTime? dateCreated,
  }) {
    return BlogPost(
      id: id ?? this.id,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      body: body ?? this.body,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'blogId': id,
      'title': title,
      'subTitle': subTitle,
      'body': body,
    };
  }

  Map<String, dynamic> toMapStore() {
    return {
      'blogId': id,
      'title': title,
      'subTitle': subTitle,
      'body': body,
      'dateCreated': dateCreated
    };
  }

  factory BlogPost.fromMap(Map<String, dynamic> map) {
    return BlogPost(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      subTitle: map['subTitle'] ?? '',
      body: map['body'] ?? '',
      dateCreated: DateTime.tryParse(map['dateCreated']) ??
          DateTime.fromMillisecondsSinceEpoch(map['dateCreated']),
    );
  }

  String toJson() => json.encode(toMapStore());

  factory BlogPost.fromJson(String source) =>
      BlogPost.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BlogPost(id: $id, title: $title, subTitle: $subTitle, body: $body, dateCreated: $dateCreated)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BlogPost &&
        other.id == id &&
        other.title == title &&
        other.subTitle == subTitle &&
        other.body == body &&
        other.dateCreated == dateCreated;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        subTitle.hashCode ^
        body.hashCode ^
        dateCreated.hashCode;
  }

  String formatDate() {
    var elapsedTime = DateTime.now().difference(dateCreated).inDays;
    var msg = switch (elapsedTime) {
      0 => 'Less than 1 day ago',
      1 => '1 day ago',
      _ => '$elapsedTime days ago'
    };
    return msg;
  }
}
