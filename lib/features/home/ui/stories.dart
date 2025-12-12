import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:face_book_clone/features/home/data/home_repo/stories_repo/stories_repo_impl.dart';
import 'package:face_book_clone/features/home/logic/story_cubit/story_cubit.dart';
import 'package:face_book_clone/features/home/logic/story_cubit/story_state.dart';

class StoriesUI extends StatelessWidget {
  final String currentUid;
  final String currentUserName;

  const StoriesUI({
    super.key,
    required this.currentUid,
    required this.currentUserName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoriesCubit(
        repo: StoriesRepositoryImpl(firestore: FirebaseFirestore.instance),
        currentUserId: currentUid,
        currentUserName: currentUserName,
      ),
      child: BlocBuilder<StoriesCubit, StoriesState>(
        builder: (context, state) {
          if (state is StoriesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          List stories = [];
          if (state is StoriesLoaded) stories = state.stories;

          return SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 12),
              itemCount: stories.length + 1,
              separatorBuilder: (context, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                if (index < stories.length) {
                  final story = stories[index];
                  return GestureDetector(
                    onTap: () {
                      print("Story clicked: ${story.storyId}");
                      // ممكن تفتح صفحة ستوري كاملة هنا
                    },
                    child: Container(
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(story.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "Your Story",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            backgroundColor: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  // أيقونة إضافة ستوري
                  return GestureDetector(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? pickedFile = await picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 80,
                      );
                      if (pickedFile != null) {
                        final file = File(pickedFile.path);
                        // نرفع الصورة ونضيفها كـ Story
                        await context.read<StoriesCubit>().uploadStoryImage(
                          file,
                        );
                      }
                    },
                    child: Container(
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 40,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
