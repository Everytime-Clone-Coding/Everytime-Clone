class Comment {
  String commentId;
  String userId;
  String content;
  DateTime timestamp;

  Comment({
    required this.commentId,
    required this.userId,
    required this.content,
    required this.timestamp,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      commentId: map['commentId'],
      content: map['content'],
      timestamp: DateTime.parse(map['timestamp']),
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'userId': userId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}