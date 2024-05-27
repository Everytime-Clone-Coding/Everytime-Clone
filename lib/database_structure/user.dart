class User {
  String userId;
  List<String> posts;
  List<String> comments;
  List<String> scraps;

  User({
    required this.userId,
    this.posts = const [],
    this.comments = const [],
    this.scraps = const []
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'posts': posts,
      'comments': comments,
      'scraps': scraps,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'],
      posts: List<String>.from(map['posts'] ?? []),
      comments: List<String>.from(map['comments'] ?? []),
      scraps: List<String>.from(map['scraps'] ?? [])
    );
  }
}