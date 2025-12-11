import 'package:equatable/equatable.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object?> get props => [];
}

class CommentInitial extends CommentState {}

class CommentActionSuccess extends CommentState {}

class CommentActionFailure extends CommentState {
  final String error;
  const CommentActionFailure(this.error);

  @override
  List<Object?> get props => [error];
}
