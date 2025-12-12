import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:face_book_clone/features/home/data/home_model/story_model.dart';

abstract class StoriesRepository {
  Stream<List<StoryModel>> storiesStream();
  Future<Either<String, Unit>> addStory(StoryModel story);
  Future<Either<String, Unit>> removeStory(String storyId);
  Future<Either<String, String>> uploadImageToStories(File file);
}
