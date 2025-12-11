import 'package:dartz/dartz.dart';

abstract class CommentRepository {
  /// جلب التعليقات كـ Stream
  Stream<List<Map<String, dynamic>>> commentsStream(String postId);

  /// إضافة تعليق جديد
  Future<Either<String, Unit>> addComment({
    required String postId,
    required String uid,
    required String content,
  });
}
