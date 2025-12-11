import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:face_book_clone/core/failure/failure.dart';
import 'package:face_book_clone/features/home/data/home_model/home_model.dart';
import 'package:face_book_clone/features/home/data/home_repo/home_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;
  HomeCubit(this.homeRepo) : super(HomeInitial());

  Future<void> uploadPost(PostModel postModel) async {
    emit(UploadPostLoading());

    final result = await homeRepo.uploadPost(postModel);

    result.fold(
      (failure) => emit(UploadPostFailure(failure.message)),
      (_) => emit(UploadPostSuccess()),
    );
  }

  //PICHIMAGE METHOD
  Future<void> pickFromCamera() async {
    emit(ImageLoading());
    final result = await homeRepo.pickImageFromCamera();
    result.fold(
      (failure) => emit(ImagePickFailure(failure.message)),
      (success) => emit(ImagePicked(success)),
    );
  }

  Future<void> pickFromGallery() async {
    emit(ImageLoading());
    final result = await homeRepo.pickImageFromGallery();
    result.fold(
      (failure) => emit(ImagePickFailure(failure.message)),
      (success) => emit(ImagePicked(success)),
    );
  }

  //UPLOAD IMAGE
  Future<void> uploadPickedImage(File file) async {
    emit(ImageUploadLoading());
    final Either<Failure, String> result = await homeRepo.uploadImage(file);

    result.fold(
      (failure) => emit(ImageUploadFailure(failure.message)),
      (url) => emit(ImageUploadSuccess(url)),
    );
  }

  Future<void> uploadPickedImagetoCloudnary(File file) async {
    emit(ImageUploadLoading());
    final result = await homeRepo.uploadImage(file);
    result.fold(
      (failure) => emit(ImageUploadFailure(failure.message)),
      (url) => emit(ImageUploadSuccess(url)),
    );
  }

  //get all posts method
  // stream من الـ repo
  Stream<List<PostModel>> get postsStream => homeRepo.getAllPosts();

  //search method
  void searchPosts(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());

    final result = await homeRepo.searchPostsByUsername(query.toLowerCase());

    result.fold(
      (failure) {
        log("Failure to search ${failure.message}");
        emit(SearchFailure(error: failure.message));
      },
      (posts) {
        log("Success to search ${posts.length}");
        emit(SearchSuccess(posts));
      },
    );
  }

  //delete post
  Future<void> deletePost(String postId) async {
    emit(DeletePostLoading());
    final result = await homeRepo.deletePost(postId);
    result.fold(
      (failure) => emit(DeletePostFailure(failure.message)),
      (_) => emit(DeletePostSuccess()),
    );
  }
}
