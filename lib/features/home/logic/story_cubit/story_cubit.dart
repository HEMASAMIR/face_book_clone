import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:face_book_clone/features/home/data/home_model/story_model.dart';
import 'package:face_book_clone/features/home/data/home_repo/stories_repo/stories_repo.dart';
import 'story_state.dart';

class StoriesCubit extends Cubit<StoriesState> {
  final StoriesRepository repo;
  final String currentUserId;
  final String currentUserName;

  StoriesCubit({
    required this.repo,
    required this.currentUserId,
    required this.currentUserName,
  }) : super(StoriesInitial()) {
    _listenToStories();
  }

  void _listenToStories() {
    repo.storiesStream().listen(
      (stories) => emit(StoriesLoaded(stories: stories)),
      onError: (error) => emit(StoriesError(message: error.toString())),
    );
  }

  Future<void> addStory(String imageUrl) async {
    final story = StoryModel(
      storyId: DateTime.now().millisecondsSinceEpoch.toString(),
      uid: currentUserId,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
    );
    final result = await repo.addStory(story);
    result.fold(
      (failure) => emit(StoriesError(message: failure)),
      (_) => null, // لا حاجة لإرسال StoryAdded لأن Stream هيتابع
    );
  }

  Future<void> removeStory(String storyId) async {
    final result = await repo.removeStory(storyId);
    result.fold((failure) => emit(StoriesError(message: failure)), (_) => null);
  }

  Future<void> uploadStoryImage(File file) async {
    final result = await repo.uploadImageToStories(file);
    result.fold(
      (failure) => emit(StoriesError(message: failure)),
      (url) => addStory(url),
    );
  }
}
