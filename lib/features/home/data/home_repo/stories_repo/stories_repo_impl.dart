import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:face_book_clone/features/home/data/home_model/story_model.dart';
import 'stories_repo.dart';

class StoriesRepositoryImpl implements StoriesRepository {
  final FirebaseFirestore firestore;

  StoriesRepositoryImpl(this.firestore);

  @override
  Stream<List<StoryModel>> storiesStream() {
    return firestore.collection('stories').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return StoryModel.fromJson({...doc.data(), 'storyId': doc.id});
      }).toList();
    });
  }

  @override
  Future<Either<String, Unit>> addStory(StoryModel story) async {
    try {
      await firestore
          .collection('stories')
          .doc(story.storyId)
          .set(story.toJson());
      return right(unit);
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> removeStory(String storyId) async {
    try {
      await firestore.collection('stories').doc(storyId).delete();
      return right(unit);
    } catch (e) {
      return left(e.toString());
    }
  }
}
