import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:face_book_clone/features/home/data/home_repo/comments_repo/comments_repo.dart';

class CommentRepositoryImpl implements CommentRepository {
  final FirebaseFirestore firestore;

  CommentRepositoryImpl(this.firestore);

  CollectionReference _comments(String postId) =>
      firestore.collection('posts').doc(postId).collection('comments');

  @override
  Stream<List<Map<String, dynamic>>> commentsStream(String postId) {
    return _comments(postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList(),
        );
  }

  @override
  Future<Either<String, Unit>> addComment({
    required String postId,
    required String uid,
    required String content,
  }) async {
    try {
      await _comments(postId).add({
        'uid': uid,
        'content': content,
        'createdAt': DateTime.now().toIso8601String(),
      });
      return right(unit);
    } catch (e) {
      return left(e.toString());
    }
  }
}
