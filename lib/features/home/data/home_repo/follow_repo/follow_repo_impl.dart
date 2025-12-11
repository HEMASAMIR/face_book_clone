import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'follow_repo.dart';

class FollowRepositoryImpl implements FollowRepository {
  final FirebaseFirestore firestore;

  FollowRepositoryImpl(this.firestore);

  // دوال مساعدة للحصول على collections
  CollectionReference _followers(String uid) =>
      firestore.collection('users').doc(uid).collection('followers');

  CollectionReference _following(String uid) =>
      firestore.collection('users').doc(uid).collection('following');

  @override
  Future<Either<String, Unit>> followUser({
    required String currentUid,
    required String targetUid,
  }) async {
    try {
      await Future.wait([
        _followers(targetUid).doc(currentUid).set({"uid": currentUid}),
        _following(currentUid).doc(targetUid).set({"uid": targetUid}),
      ]);
      return right(unit);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> unFollowUser({
    required String currentUid,
    required String targetUid,
  }) async {
    try {
      await Future.wait([
        _followers(targetUid).doc(currentUid).delete(),
        _following(currentUid).doc(targetUid).delete(),
      ]);
      return right(unit);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> isFollowing({
    required String currentUid,
    required String targetUid,
  }) async {
    try {
      final doc = await _followers(targetUid).doc(currentUid).get();
      return right(doc.exists);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Stream<int> followersCount(String uid) =>
      _followers(uid).snapshots().map((snap) => snap.docs.length);

  @override
  Stream<int> followingCount(String uid) =>
      _following(uid).snapshots().map((snap) => snap.docs.length);

  @override
  Stream<bool> isFollowingStream({
    required String currentUid,
    required String targetUid,
  }) {
    return _followers(
      targetUid,
    ).doc(currentUid).snapshots().map((doc) => doc.exists);
  }
}
