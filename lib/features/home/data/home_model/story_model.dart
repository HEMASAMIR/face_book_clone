import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  String storyId;
  String uid;
  String imageUrl;
  DateTime createdAt;

  StoryModel({
    required this.storyId,
    required this.uid,
    required this.imageUrl,
    required this.createdAt,
  });

  // تحويل البيانات من Firestore إلى StoryModel
  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      storyId: json['storyId'] as String,
      uid: json['uid'] as String,
      imageUrl: json['imageUrl'] as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  // تحويل StoryModel إلى Map علشان نخزنها في Firestore
  Map<String, dynamic> toJson() {
    return {
      'storyId': storyId,
      'uid': uid,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }
}
