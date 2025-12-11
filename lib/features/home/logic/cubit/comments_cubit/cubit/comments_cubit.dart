import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:face_book_clone/features/home/data/home_repo/comments_repo/comments_repo.dart';
import 'package:face_book_clone/features/home/logic/cubit/comments_cubit/cubit/comments_state.dart';

class CommentCubit extends Cubit<CommentState> {
  final CommentRepository repository;
  StreamSubscription? _commentsSubscription;

  CommentCubit(this.repository) : super(CommentInitial());

  /// إضافة تعليق
  Future<void> addComment(String postId, String uid, String content) async {
    final result = await repository.addComment(
      postId: postId,
      uid: uid,
      content: content,
    );

    result.fold(
      (error) => emit(CommentActionFailure(error)),
      (_) => emit(CommentActionSuccess()),
    );
  }

  /// Stream التعليقات
  Stream<List<Map<String, dynamic>>> commentsStream(String postId) {
    return repository.commentsStream(postId);
  }

  @override
  Future<void> close() {
    _commentsSubscription?.cancel();
    return super.close();
  }
}
