import 'package:face_book_clone/core/colors/app_colors.dart';
import 'package:face_book_clone/features/home/data/home_model/home_model.dart';
import 'package:face_book_clone/features/home/logic/cubit/home_cubit.dart';
import 'package:face_book_clone/features/home/ui/comments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    // فورمات التاريخ
    // final formattedDate = DateFormat('dd/MM/yyyy  hh:mm a').format(post.date);

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
            // --- Profile Row ---
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: post.profilePic.startsWith("http")
                      ? NetworkImage(post.profilePic)
                      : AssetImage('assets/images/man.png') as ImageProvider,
                ),

                Gap(10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.displayName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(post.username, style: TextStyle(color: Colors.grey)),
                  ],
                ),

                Spacer(),

                Text(
                  DateFormat('dd/MM/yyyy  hh:mm a').format(post.date),

                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),

            Gap(12),

            // --- Post Image ---
            if (post.postImage.isNotEmpty)
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: post.postImage.startsWith("http")
                        ? NetworkImage(post.postImage)
                        : AssetImage('assets/images/man.png') as ImageProvider,
                  ),
                ),
              ),

            Gap(12),

            // --- Description ---
            Text(post.description, maxLines: 3, style: TextStyle(fontSize: 14)),

            Gap(12),

            // --- Actions Row ---
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.favorite_border, color: kPrimaryColor),
                ),
                Text("${post.like.length} likes"),

                Gap(20),

                IconButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => CommentScreen()),
                      (route) => false,
                    );
                  },
                  icon: Icon(Icons.comment),
                ),
                Text("comments"),

                Spacer(),

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
                          ? null // disable button while loading
                          : () {
                              context.read<HomeCubit>().deletePost(post.postId);
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
