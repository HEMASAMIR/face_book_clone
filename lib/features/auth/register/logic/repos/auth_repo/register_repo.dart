import 'package:dartz/dartz.dart';
import 'package:face_book_clone/features/auth/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<Either<AuthFailure, UserCredential>> loginWithEmail({
    required String email,
    required String password,
  });

  Future<Either<AuthFailure, UserCredential>> registerWithEmail({
    required String email,
    required String password,
    required String userName,
    required String displayName,
  });

  Future<void> logout();

  User? getCurrentUser();

  Future<Either<AuthFailure, UserModel>> getUserData(String uid);

  Future<Either<AuthFailure, Unit>> addUserData(UserModel user);

  Future<Either<AuthFailure, Unit>> updateUserData(UserModel user);
}

class AuthFailure {
  final String message;
  AuthFailure(this.message);
}
