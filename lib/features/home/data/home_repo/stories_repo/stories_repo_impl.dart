import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:face_book_clone/features/home/data/home_model/story_model.dart';
import 'stories_repo.dart';

class StoriesRepositoryImpl implements StoriesRepository {
  final FirebaseFirestore firestore;
  final String collectionName = 'stories';
  final String cloudName = 'djndzjeud';
  final String uploadPreset = 'ourImagesUploaded';

  StoriesRepositoryImpl({required this.firestore});

  @override
  Stream<List<StoryModel>> storiesStream() {
    return firestore
        .collection(collectionName)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => StoryModel.fromJson(doc.data()))
              .toList(),
        );
  }

  @override
  Future<Either<String, Unit>> addStory(StoryModel story) async {
    try {
      await firestore
          .collection(collectionName)
          .doc(story.storyId)
          .set(story.toJson());
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Unit>> removeStory(String storyId) async {
    try {
      await firestore.collection(collectionName).doc(storyId).delete();
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> uploadImageToStories(File file) async {
    try {
      final url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        'upload_preset': uploadPreset,
      });
      final response = await Dio().post(url, data: formData);
      return right(response.data['secure_url'] as String);
    } catch (e) {
      return left(e.toString());
    }
  }
}
