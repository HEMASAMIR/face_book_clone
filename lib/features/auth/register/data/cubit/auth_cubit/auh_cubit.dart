import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:face_book_clone/features/auth/model/user_model.dart';
import 'package:face_book_clone/features/auth/register/logic/repos/auth_repo/register_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  AuthCubit(this._authRepository) : super(RegisterInitial());

  //LOGIN METHOD
  Future<void> login(String email, String password) async {
    // Emit loading state
    emit(LoginLoading());

    // Attempt to log in
    final result = await _authRepository.loginWithEmail(
      email: email,
      password: password,
    );

    // Handle login result
    result.fold(
      // If login fails, emit error state with failure message
      (failure) => emit(LoginError(failure.message)),
      (userCredential) => emit(LoginAuthenticated(userCredential.user!)),
    );
  }

  //REGISTER METHOD
  Future<void> register(
    String email,
    String password,
    String userName,
    String displayname,
  ) async {
    emit(RegisterLoading());
    final result = await _authRepository.registerWithEmail(
      email: email,
      password: password,
      displayName: displayname,
      userName: userName,
    );

    result.fold(
      (failure) => emit(RegisterError(failure.message)),
      (userCredential) => emit(RegisterAuthenticated(userCredential.user!)),
    );
  }

  //LOGOUT METHOD
  Future<void> logout() async {
    await _authRepository.logout();
    emit(SignOutSuccess());
  }

  //update user data
  void updateProfile(UserModel user) async {
    emit(EditProfileLoading());
    final result = await _authRepository.updateUserData(user);

    result.fold(
      (failure) => emit(EditProfileFailure(failure.message)),
      (_) => emit(EditProfileSuccess()),
    );
  }
}
