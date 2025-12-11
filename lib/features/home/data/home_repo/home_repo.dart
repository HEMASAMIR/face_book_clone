import 'dart:io';

import 'package:face_book_clone/core/failure/failure.dart';
import 'package:face_book_clone/features/home/data/home_model/home_model.dart';

import 'package:dartz/dartz.dart';

abstract class HomeRepo {
  Future<Either<Failure, UploadSuccess>> uploadPost(PostModel postModel);
  // دوال الصور
  Future<Either<Failure, ImagePickedSuccess>> pickImageFromGallery();
  Future<Either<Failure, ImagePickedSuccess>> pickImageFromCamera();

  //upload image to firebase storage
  Future<Either<Failure, String>> uploadImage(File file);

  //GET ALL POSTS
  // جلب كل البوستات كـ Stream
  Stream<List<PostModel>> getAllPosts();

  //Search users
  Future<Either<Failure, List<PostModel>>> searchPostsByUsername(String query);

  //delete post
  Future<Either<Failure, Unit>> deletePost(String postId);
}
