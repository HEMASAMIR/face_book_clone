import 'package:face_book_clone/features/home/data/home_model/story_model.dart';

abstract class StoriesState {}

class StoriesInitial extends StoriesState {}

class StoriesLoading extends StoriesState {}

class StoriesLoaded extends StoriesState {
  final List<StoryModel> stories;

  StoriesLoaded({required this.stories});
}

class StoriesError extends StoriesState {
  final String message;

  StoriesError({required this.message});
}

class StoryAdded extends StoriesState {}
