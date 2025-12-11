import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:face_book_clone/features/home/data/home_repo/stories_repo/stories_repo_impl.dart';
import 'likes_repo.dart';

class LikesRepositoryImpl implements LikesRepository {
  final FirebaseFirestore firestore;

  LikesRepositoryImpl(
    this.firestore,
    StoriesRepositoryImpl storiesRepositoryImpl,
  );

  @override
  Stream<List<String>> likesStream(String postId) {
    return firestore.collection('posts').doc(postId).snapshots().map((snap) {
      final data = snap.data() as Map<String, dynamic>? ?? {};
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
        final data = snapshot.data() as Map<String, dynamic>? ?? {};
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
        final data = snapshot.data() as Map<String, dynamic>? ?? {};
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
