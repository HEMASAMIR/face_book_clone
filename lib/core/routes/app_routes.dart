import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_book_clone/core/routes/routes.dart';
import 'package:face_book_clone/features/auth/login/ui/login.dart';
import 'package:face_book_clone/features/auth/register/data/register_cubit/cubit/auh_cubit.dart';
import 'package:face_book_clone/features/auth/register/logic/repos/register_repo_impl.dart';
import 'package:face_book_clone/features/auth/register/ui/register.dart';
import 'package:face_book_clone/features/home/data/home_repo/home_repo_impl.dart';
import 'package:face_book_clone/features/home/logic/cubit/home_cubit.dart';
import 'package:face_book_clone/features/home/ui/layout_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.loginPage:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthCubit(AuthRepositoryImpl()),
            child: LoginPage(),
          ),
        );
      case Routes.registerScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthCubit(AuthRepositoryImpl()),
            child: RegisterPage(),
          ),
        );
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<AuthCubit>(
                create: (_) => AuthCubit(AuthRepositoryImpl()),
              ),
              BlocProvider<HomeCubit>(
                create: (_) => HomeCubit(
                  HomeRepoImpl(
                    FirebaseFirestore.instance,
                    FirebaseStorage.instance,
                  ),
                ),
              ),
            ],
            child: LayoutPage(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
