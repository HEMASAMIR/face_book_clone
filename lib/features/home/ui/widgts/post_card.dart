import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_book_clone/core/colors/app_colors.dart';
import 'package:face_book_clone/features/home/data/home_model/home_model.dart';
import 'package:face_book_clone/features/home/data/home_model/story_model.dart';
import 'package:face_book_clone/features/home/data/home_repo/stories_repo/stories_repo_impl.dart';
import 'package:face_book_clone/features/home/logic/cubit/home_cubit/home_cubit.dart';
import 'package:face_book_clone/features/home/logic/cubit/home_cubit/home_states.dart';
import 'package:face_book_clone/features/home/ui/comments.dart';
import 'package:face_book_clone/features/home/data/home_repo/likes_repo/likes_repo_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final String currentUid;

  const PostCard({super.key, required this.post, required this.currentUid});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late LikesRepositoryImpl likesRepositoryImpl;
  late StoriesRepositoryImpl storiesRepositoryImpl;
  final currentUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    likesRepositoryImpl = LikesRepositoryImpl(
      FirebaseFirestore.instance,
      storiesRepositoryImpl = StoriesRepositoryImpl(FirebaseFirestore.instance),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              child: StreamBuilder<List<StoryModel>>(
                stream: storiesRepositoryImpl.storiesStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());

                  final stories = snapshot.data!
                      .where(
                        (story) =>
                            DateTime.now()
                                .difference(story.createdAt)
                                .inSeconds <
                            30,
                      )
                      .toList(); // مدة 30 ثانية

                  if (stories.isEmpty)
                    return Center(child: Text("No stories yet"));

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: stories.length,
                    itemBuilder: (context, index) {
                      final story = stories[index];
                      final isMine = story.uid == currentUid;

                      return Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.all(8),
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(story.imageUrl),
                              ),
                            ),
                          ),
                          if (isMine)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => storiesRepositoryImpl.removeStory(
                                  story.storyId,
                                ),
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.red,
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            // --- Profile Row ---
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: widget.post.profilePic.startsWith("http")
                      ? NetworkImage(widget.post.profilePic)
                      : AssetImage('assets/images/man.png') as ImageProvider,
                ),
                Gap(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.displayName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.post.username,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Spacer(),
                Text(
                  DateFormat('dd/MM/yyyy  hh:mm a').format(widget.post.date),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            Gap(12),

            // --- Post Image ---
            if (widget.post.postImage.isNotEmpty)
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: widget.post.postImage.startsWith("http")
                        ? NetworkImage(widget.post.postImage)
                        : AssetImage('assets/images/man.png') as ImageProvider,
                  ),
                ),
              ),
            Gap(12),

            // --- Description ---
            Text(
              widget.post.description,
              maxLines: 3,
              style: TextStyle(fontSize: 14),
            ),
            Gap(12),

            // --- Actions Row ---
            Row(
              children: [
                // --- Likes Button ---
                StreamBuilder<List<String>>(
                  stream: likesRepositoryImpl.likesStream(widget.post.postId),
                  builder: (context, snapshot) {
                    final likes = snapshot.data ?? [];
                    final isLiked = likes.contains(widget.currentUid);

                    return Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            try {
                              if (isLiked) {
                                await likesRepositoryImpl.unLikePost(
                                  postId: widget.post.postId,
                                  uid: widget.currentUid,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("You unliked this post"),
                                  ),
                                );
                              } else {
                                await likesRepositoryImpl.likePost(
                                  postId: widget.post.postId,
                                  uid: widget.currentUid,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("You liked this post"),
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: $e")),
                              );
                            }
                          },
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : kPrimaryColor,
                          ),
                        ),
                        Text("${likes.length} likes"),
                      ],
                    );
                  },
                ),
                Gap(20),

                // --- Comments Button ---
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CommentScreen(
                          postId: widget.post.postId,
                          currentUid: widget.currentUid,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.comment),
                ),
                Text("comments"),
                Spacer(),

                // --- Delete Post ---
                BlocConsumer<HomeCubit, HomeState>(
                  listener: (context, state) {
                    if (state is DeletePostSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Post deleted successfully!")),
                      );
                    } else if (state is DeletePostFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Failed to delete post: ${state.error}",
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return IconButton(
                      onPressed: state is DeletePostLoading
                          ? null
                          : () {
                              context.read<HomeCubit>().deletePost(
                                widget.post.postId,
                              );
                            },
                      icon: state is DeletePostLoading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(Icons.delete),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
