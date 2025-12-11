import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_book_clone/features/auth/model/user_model.dart';
import 'package:face_book_clone/features/auth/register/logic/repos/auth_repo/register_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _firestore = firestore ?? FirebaseFirestore.instance;

  // -------------------- LOGIN --------------------
  @override
  Future<Either<AuthFailure, UserCredential>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await getUserData(userCredential.user!.uid);
      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? "Authentication error"));
    } catch (e) {
      return Left(AuthFailure("Unexpected error: $e"));
    }
  }

  // -------------------- REGISTER --------------------
  @override
  Future<Either<AuthFailure, UserCredential>> registerWithEmail({
    required String email,
    required String password,
    required String userName,
    required String displayName,
    String? bio,
    String? profilePic,
    List<dynamic>? followers,
    List<dynamic>? following,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      await userCredential.user!.updateDisplayName(displayName);

      // إعداد الموديل
      UserModel userModel = UserModel(
        uid: uid,
        email: email,
        displayName: displayName,
        username: userName,
        bio: bio ?? "this is my bio",
        profilePic: profilePic ?? "assets/images/man.png",
        followers: followers ?? [],
        following: following ?? [],
      );

      // حفظ بيانات المستخدم
      await _firestore.collection("users").doc(uid).set(userModel.toJson());
      await addUserData(userModel);
      await getUserData(userCredential.user!.uid);
      return Right(userCredential);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? "Registration error"));
    } catch (e) {
      return Left(AuthFailure("Unexpected error: $e"));
    }
  }

  // -------------------- ADD USER DATA --------------------
  @override
  Future<Either<AuthFailure, Unit>> addUserData(UserModel user) async {
    try {
      await _firestore
          .collection("users")
          .doc(user.uid)
          .set(user.toJson(), SetOptions(merge: true));

      return Right(unit);
    } catch (e) {
      return Left(AuthFailure("Failed to add user data"));
    }
  }

  // -------------------- GET USER DATA --------------------
  @override
  Future<Either<AuthFailure, UserModel>> getUserData(String uid) async {
    try {
      final snapshot = await _firestore.collection("users").doc(uid).get();

      if (!snapshot.exists) {
        return Left(AuthFailure("User not found"));
      }

      final data = snapshot.data()?.cast<String, dynamic>() ?? {};
      final userModel = UserModel.fromJson(data);

      return Right(userModel);
    } catch (e) {
      return Left(AuthFailure("Failed to fetch user data"));
    }
  }

  // -------------------- LOGOUT --------------------
  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // -------------------- CURRENT USER --------------------
  @override
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<Either<AuthFailure, Unit>> updateUserData(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).update({
        'displayName': user.displayName,
        'username': user.username,
        'bio': user.bio,
        'profilePic': user.profilePic,
      });
      return Right(unit);
    } catch (e) {
      return Left(AuthFailure("Failed to update user data: ${e.toString()}"));
    }
  }
}
