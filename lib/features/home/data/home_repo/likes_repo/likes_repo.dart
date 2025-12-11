import 'package:dartz/dartz.dart';

abstract class LikesRepository {
  Stream<List<String>> likesStream(String postId);
  Future<Either<String, Unit>> likePost({
    required String postId,
    required String uid,
  });
  Future<Either<String, Unit>> unLikePost({
    required String postId,
    required String uid,
  });
}
