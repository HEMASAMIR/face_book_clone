import 'package:face_book_clone/core/colors/app_colors.dart' as MangerColors;
import 'package:face_book_clone/core/routes/app_routes.dart';
import 'package:face_book_clone/core/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FaceBookClone extends StatelessWidget {
  final AppRouter appRouter;
  const FaceBookClone({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    // هنا نتحقق من حالة تسجيل الدخول
    User? user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Facebook clone appe',
      theme: ThemeData(scaffoldBackgroundColor: MangerColors.white),
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: user != null ? Routes.homeScreen : Routes.loginPage,
    );
  }
}
 /**
  * StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // شاشة انتظار أثناء تحميل الحالة
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            // المستخدم مسجّل دخول
            return const LayoutPage();
          } else {
            // المستخدم مش مسجّل دخول
            return const RegisterScreen();
          }
        },
      ),
    );
  */