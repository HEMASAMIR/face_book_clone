import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String uid;
  String displayName;
  String username;
  String profilePic;
  String description;
  String postId;
  String postImage;
  DateTime date;
  dynamic like;

  PostModel({
    required this.uid,
    required this.date,
    required this.displayName,
    required this.username,
    required this.description,
    required this.profilePic,
    required this.like,
    required this.postId,
    required this.postImage,
  });

  factory PostModel.fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return PostModel(
      uid: snapshot["uid"],
      date: (snapshot['date'] as Timestamp).toDate(), // <-- مهم جدًا
      displayName: snapshot["displayName"],
      username: snapshot["username"],
      description: snapshot["description"],
      profilePic: snapshot["profilePic"],
      like: snapshot["like"],
      postId: snapshot["postId"],
      postImage: snapshot["postImage"],
    );
  }
  Map<String, dynamic> toJson() => {
    "uid": uid,
    "description": description,
    "displayName": displayName,
    "username": username,
    "profilePic": profilePic,
    "date": date,
    "like": like,
    "postId": postId,
    "postImage": postImage,
  };

  // --------- FROM JSON ----------
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      postId: json['postId'] ?? '',
      uid: json['uid'] ?? '',
      displayName: json['displayName'] ?? '',
      username: json['username'] ?? '',
      description: json['description'] ?? '',
      postImage: json['postImage'] ?? '', // صححت الاسم
      date: json['date'] != null
          ? (json['date'] is Timestamp
                ? (json['date'] as Timestamp).toDate()
                : DateTime.parse(json['date'])) // لو جاي كـ String
          : DateTime.now(), // fallback
      profilePic: json['profilePic'] ?? '',
      like: json['like'] ?? [],
    );
  }
}
