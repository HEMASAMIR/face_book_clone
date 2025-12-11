import 'package:face_book_clone/features/home/logic/cubit/home_cubit/home_cubit.dart';
import 'package:face_book_clone/features/home/logic/cubit/home_cubit/home_states.dart';
import 'package:face_book_clone/features/home/ui/widgts/post_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPostsPage extends StatelessWidget {
  SearchPostsPage({super.key});
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<HomeCubit>();

    return Scaffold(
      appBar: AppBar(title: Text("Search Posts")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search posts...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                searchCubit.searchPosts(query.toLowerCase());
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is SearchSuccess) {
                  if (state.posts.isEmpty) {
                    return Center(child: Text("No posts found"));
                  }
                  return ListView.builder(
                    itemCount: state.posts.length,
                    itemBuilder: (context, index) {
                      final post = state.posts[index];
                      return PostCard(
                        post: post,
                        currentUid: FirebaseAuth.instance.currentUser!.uid,
                      );
                    },
                  );
                } else if (state is SearchFailure) {
                  return Center(child: Text("Error: ${state.error}"));
                }
                return Center(child: Text("Start typing to search"));
              },
            ),
          ),
        ],
      ),
    );
  }
}
