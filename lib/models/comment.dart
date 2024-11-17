class Comment {
  final int? id;
  final String name;
  final String content;
  final String date;

  Comment(
      {this.id, required this.name, required this.content, required this.date});

  // Convert Comment to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'content': content,
      'date': date,
    };
  }

  // Create Comment object from Map
  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      name: map['name'],
      content: map['content'],
      date: map['date'],
    );
  }
}
