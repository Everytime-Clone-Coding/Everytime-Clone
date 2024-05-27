class Post {
  String postId;
  String userId;
  String title;
  String content;
  DateTime timestamp;
  String boardName;
  int likes;
  int scraped;
  List<String> likedBy;
  List<String> scrapedBy;

  Post({
    required this.postId,
    required this.userId,
    required this.title,
    required this.content,
    required this.timestamp,
    required this.boardName,
    this.likes = 0,
    this.scraped = 0,
    this.likedBy = const [],
    this.scrapedBy = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': userId,
      'title': title,
      'content': content,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'boardName': boardName,
      'likes': likes,
      'scraped': scraped,
      'likedBy': likedBy,
      'scrapedBy': scrapedBy,
    };
  }

  static Post fromMap(Map<String, dynamic> map) {
    return Post(
      postId: map['postId'],
      userId: map['userId'],
      title: map['title'],
      content: map['content'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      boardName: map['boardName'],
      likes: map['likes'] ?? 0,
      scraped: map['scraped'] ?? 0,
      likedBy: List<String>.from(map['likedBy'] ?? []),
      scrapedBy: List<String>.from(map['scrapedBy'] ?? []),
    );
  }
}
