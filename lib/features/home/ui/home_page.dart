import 'package:face_book_clone/core/colors/app_colors.dart';
import 'package:face_book_clone/features/home/logic/cubit/home_cubit/home_cubit.dart';
import 'package:face_book_clone/features/home/ui/stories.dart';
import 'package:face_book_clone/features/home/ui/widgts/post_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "El",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              TextSpan(
                text: "Holandy",
                style: TextStyle(
                  fontSize: 26,
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.message))],
      ),
      body: StreamBuilder(
        stream: cubit.postsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return Center(child: Text('No posts yet'));
          }
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: StoriesUI(
                  currentUid: FirebaseAuth.instance.currentUser!.uid,
                  currentUserName:
                      FirebaseAuth.instance.currentUser!.displayName!,
                ),
              ), //SliverToBoxAdapter(child: StoriesWidget(currentId: cubit.currentId)),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return PostCard(
                    post: posts[index],
                    currentUid: FirebaseAuth.instance.currentUser!.uid,
                  );
                }, childCount: posts.length),
              ),
            ],
          );
        },
      ),
    );
  }
}
