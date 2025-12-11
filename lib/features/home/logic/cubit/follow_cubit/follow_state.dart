import 'package:equatable/equatable.dart';

abstract class FollowState extends Equatable {
  const FollowState();
  @override
  List<Object?> get props => [];
}

class FollowInitial extends FollowState {}

class FollowLoading extends FollowState {}

class FollowSuccess extends FollowState {}

class FollowFailure extends FollowState {
  final String message;
  const FollowFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class FollowStatusChanged extends FollowState {
  final bool isFollowing;
  const FollowStatusChanged(this.isFollowing);
  @override
  List<Object?> get props => [isFollowing];
}

class FollowersCountLoaded extends FollowState {
  final int count;
  const FollowersCountLoaded(this.count);
  @override
  List<Object?> get props => [count];
}

class FollowingCountLoaded extends FollowState {
  final int count;
  const FollowingCountLoaded(this.count);
  @override
  List<Object?> get props => [count];
}

class FollowActionFailure extends FollowState {
  final String error;
  const FollowActionFailure(this.error);
  @override
  List<Object?> get props => [error];
}

class FollowActionSuccess extends FollowState {}
