import 'package:bloc/bloc.dart';
import 'package:face_book_clone/core/face_book_clone.dart';
import 'package:face_book_clone/core/my_bloc_observer.dart';
import 'package:face_book_clone/core/routes/app_routes.dart';
import 'package:face_book_clone/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Bloc.observer = MyObserver();
  runApp(FaceBookClone(appRouter: AppRouter()));
}
