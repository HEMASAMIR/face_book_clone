import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  final String storyId;
  final String uid;
  final String imageUrl; // أو فيديو لو حبيت
  final DateTime createdAt;

  StoryModel({
    required this.storyId,
    required this.uid,
    required this.imageUrl,
    required this.createdAt,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      storyId: json['storyId'] ?? '',
      uid: json['uid'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storyId': storyId,
      'uid': uid,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }
}
