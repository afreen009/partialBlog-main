import '../firebaseservice.dart';

class Users {
  final List<String> history;
  final List<BookMarks> bookmark;
  final List<String> subscribedChannel;
  Users({
    this.history,
    this.bookmark,
    this.subscribedChannel,
  });
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      history: json['history'],
      bookmark: json['bookmark'],
      subscribedChannel: json['subscribedChannel'],
    );
  }
  toJson() => {
        "history": this.history,
        'bookmark': this.bookmark,
        'subscribedChannels': 'subscribedChannel'
      };
}

class BookMarks {
  final String postsId;
  final String categoryId;
  BookMarks({
    this.postsId,
    this.categoryId,
  });
  factory BookMarks.fromJson(Map<String, dynamic> json) {
    return BookMarks(
      postsId: json['postId'],
      categoryId: json['categoryId'],
    );
  }
  toJson() => {"postId": this.postsId, 'categoryId': this.categoryId};
}
