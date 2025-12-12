import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'likes_repo.dart';

class LikesRepositoryImpl implements LikesRepository {
  final FirebaseFirestore firestore;

  LikesRepositoryImpl(this.firestore);

  @override
  Stream<List<String>> likesStream(String postId) {
    return firestore.collection('posts').doc(postId).snapshots().map((snap) {
      final data = snap.data() ?? {};
      final likes = List<String>.from(data['likes'] ?? []);
      return likes;
    });
  }

  @override
  Future<Either<String, Unit>> likePost({
    required String postId,
    required String uid,
  }) async {
    try {
      final docRef = firestore.collection('posts').doc(postId);
      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        final data = snapshot.data() ?? {};
        final likes = List<String>.from(data['likes'] ?? []);
        if (!likes.contains(uid)) {
          likes.add(uid);
        }
        transaction.update(docRef, {'likes': likes});
      });
      return right(unit);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> unLikePost({
    required String postId,
    required String uid,
  }) async {
    try {
      final docRef = firestore.collection('posts').doc(postId);
      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);
        final data = snapshot.data() ?? {};
        final likes = List<String>.from(data['likes'] ?? []);
        likes.remove(uid);
        transaction.update(docRef, {'likes': likes});
      });
      return right(unit);
    } catch (e) {
      return left(e.toString());
    }
  }
}
