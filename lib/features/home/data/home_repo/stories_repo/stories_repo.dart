import 'package:dartz/dartz.dart';
import 'package:face_book_clone/features/home/data/home_model/story_model.dart';

abstract class StoriesRepository {
  // Stream كل الـ stories
  Stream<List<StoryModel>> storiesStream();

  // إضافة story
  Future<Either<String, Unit>> addStory(StoryModel story);

  // حذف story
  Future<Either<String, Unit>> removeStory(String storyId);
}
