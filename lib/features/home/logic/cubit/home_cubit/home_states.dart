import 'package:equatable/equatable.dart';
import 'package:face_book_clone/core/failure/failure.dart';
import 'package:face_book_clone/features/home/data/home_model/home_model.dart';

class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

//UPLOAD POSTS
class UploadPostLoading extends HomeState {}

class UploadPostSuccess extends HomeState {}

class UploadPostFailure extends HomeState {
  final String error;
  const UploadPostFailure(this.error);
}

//IMAGE STATES
class ImageLoading extends HomeState {}

class ImagePicked extends HomeState {
  final ImagePickedSuccess image;
  const ImagePicked(this.image);
}

class ImagePickFailure extends HomeState {
  final String error;
  const ImagePickFailure(this.error);
}

//UPLOAD IMAGE
class ImageUploadLoading extends HomeState {}

class ImageUploadSuccess extends HomeState {
  final String url;
  const ImageUploadSuccess(this.url);
}

class ImageUploadFailure extends HomeState {
  final String error;
  const ImageUploadFailure(this.error);
}

//SEARCH STATE
class SearchLoading extends HomeState {}

class SearchSuccess extends HomeState {
  final List<PostModel> posts;
  const SearchSuccess(this.posts);
}

class SearchFailure extends HomeState {
  final String error;
  const SearchFailure({required this.error});
}

class SearchInitial extends HomeState {}

//DELETE STATE
class DeletePostLoading extends HomeState {}

class DeletePostSuccess extends HomeState {}

class DeletePostFailure extends HomeState {
  final String error;
  const DeletePostFailure(this.error);
}
