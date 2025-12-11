import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class FollowRepository {
  Future<Either<String, Unit>> followUser({
    required String currentUid,
    required String targetUid,
  });

  Future<Either<String, Unit>> unFollowUser({
    required String currentUid,
    required String targetUid,
  });

  Future<Either<String, bool>> isFollowing({
    required String currentUid,
    required String targetUid,
  });

  // عداد المتابعين كـ Stream
  Stream<int> followersCount(String uid);

  // عداد المتابع لهم كـ Stream
  Stream<int> followingCount(String uid);

  Stream<bool> isFollowingStream({
    required String currentUid,
    required String targetUid,
  }) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUid)
        .collection('following')
        .doc(targetUid)
        .snapshots()
        .map((doc) => doc.exists);
  }
}
