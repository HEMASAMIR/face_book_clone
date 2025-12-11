import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String email;
  String displayName;
  String username;
  String bio;
  String profilePic;
  List<dynamic> followers;
  List<dynamic> following;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.username,
    required this.bio,
    required this.profilePic,
    required this.followers,
    required this.following,
  });

  // ===================== From Firestore DocumentSnapshot =====================
  factory UserModel.fromSnap(DocumentSnapshot snap) {
    final snapshot =
        (snap.data() as Map<dynamic, dynamic>?)?.cast<String, dynamic>() ?? {};

    return UserModel(
      uid: snapshot["uid"] ?? "",
      email: snapshot["email"] ?? "",
      displayName: snapshot["displayName"] ?? "",
      username: snapshot["username"] ?? "",
      bio: snapshot["bio"] ?? "",
      profilePic: snapshot["profilePic"] ?? "",
      followers: snapshot["followers"] ?? [],
      following: snapshot["following"] ?? [],
    );
  }

  // ===================== To JSON for Firestore =====================
  Map<String, dynamic> toJson() => {
    "uid": uid,
    "email": email,
    "displayName": displayName,
    "username": username,
    "bio": bio,
    "profilePic": profilePic,
    "followers": followers,
    "following": following,
  };

  // ===================== From generic Map (JSON / API) =====================
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final map = Map<String, dynamic>.from(json);

    return UserModel(
      uid: map["uid"] ?? "",
      email: map["email"] ?? "",
      displayName: map["displayName"] ?? "",
      username: map["username"] ?? "",
      bio: map["bio"] ?? "",
      profilePic: map["profilePic"] ?? "",
      followers: map["followers"] ?? [],
      following: map["following"] ?? [],
    );
  }
}
