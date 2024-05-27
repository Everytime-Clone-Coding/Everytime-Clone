class Board {
  String boardId;
  String boardName;

  Board({
    required this.boardId,
    required this.boardName,
  });

  Map<String, dynamic> toMap() {
    return {
      'boardId': boardId,
      'boardName': boardName,
    };
  }

  static Board fromMap(Map<String, dynamic> map) {
    return Board(
      boardId: map['boardId'],
      boardName: map['boardName']
    );
  }
}