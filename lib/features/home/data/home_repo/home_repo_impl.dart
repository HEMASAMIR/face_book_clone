import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:face_book_clone/core/failure/failure.dart';
import 'package:face_book_clone/features/home/data/home_model/home_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'home_repo.dart';
import 'package:dio/dio.dart';

class HomeRepoImpl implements HomeRepo {
  final FirebaseFirestore firestore;
  final ImagePicker _picker = ImagePicker();
  final String collectionName = "posts";
  final FirebaseStorage storage;
  final String cloudName = 'djndzjeud';
  final String uploadPreset = 'ourImagesUploaded';

  HomeRepoImpl(this.firestore, this.storage);

  @override
  Future<Either<Failure, UploadSuccess>> uploadPost(PostModel postModel) async {
    final Stopwatch timer = Stopwatch()..start();
    try {
      debugPrint("🚀 [UploadPost] START");
      debugPrint("📄 Post ID: ${postModel.postId}");
      debugPrint("👤 User: ${postModel.username}");
      debugPrint("🕓 Date: ${postModel.date}");

      await firestore
          .collection(collectionName)
          .doc(postModel.postId)
          .set(postModel.toJson());

      debugPrint("✅ [UploadPost] DONE in ${timer.elapsedMilliseconds}ms");
      return right(const UploadSuccess());
    } on FirebaseException catch (e) {
      return left(Failure(e.message ?? "Firebase Error"));
    } catch (e, stackTrace) {
      debugPrint("❌ [UploadPost]: $e");
      debugPrint("🧵 StackTrace: $stackTrace");
      return left(Failure(e.toString()));
    } finally {
      timer.stop();
      debugPrint("⏳ [UploadPost] TIME: ${timer.elapsedMilliseconds}ms");
    }
  }

  @override
  Future<Either<Failure, ImagePickedSuccess>> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile == null) return left(Failure("No image captured"));
      return right(ImagePickedSuccess(File(pickedFile.path)));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ImagePickedSuccess>> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile == null) return left(Failure("No image selected"));
      return right(ImagePickedSuccess(File(pickedFile.path)));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  // Future<Either<Failure, String>> uploadImage(File file) async {
  //   try {
  //     final fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //     final ref = storage.ref().child('posts/$fileName');
  //     await ref.putFile(file);
  //     final downloadUrl = await ref.getDownloadURL();
  //     return right(downloadUrl);
  //   } on FirebaseException catch (e) {
  //     return left(Failure(e.message ?? "Firebase Storage Error"));
  //   } catch (e) {
  //     return left(Failure(e.toString()));
  //   }
  // }
  //CLOIDNARY
  // Cloudinary settings
  Future<Either<Failure, String>> uploadImage(File file) async {
    try {
      final url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        'upload_preset': uploadPreset,
      });

      final response = await Dio().post(url, data: formData);
      return right(response.data['secure_url']);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
  //GET ALL POSTS IMPL USING STREAM

  @override
  Stream<List<PostModel>> getAllPosts() {
    return firestore
        .collection(collectionName)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PostModel.fromJson(doc.data()))
              .toList(),
        );
  }

  @override
  Future<Either<Failure, List<PostModel>>> searchPostsByUsername(
    String query,
  ) async {
    try {
      final snapshot = await firestore
          .collection('posts')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: "$query\uf8ff")
          .get();

      final posts = snapshot.docs
          .map((doc) => PostModel.fromJson({...doc.data(), 'postId': doc.id}))
          .toList();

      return Right(posts);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePost(String postId) async {
    try {
      await firestore.collection('posts').doc(postId).delete();
      return right(unit); // unit من dartz
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

/**
 * 159119936895714
 * djndzjeud
 * ourImagesUploaded 
 * 
 */
