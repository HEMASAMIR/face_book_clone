import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_book_clone/core/colors/app_colors.dart';
import 'package:face_book_clone/core/routes/routes.dart';
import 'package:face_book_clone/features/home/data/home_repo/comments_repo/comments_repo_impl.dart';
import 'package:face_book_clone/features/home/logic/cubit/comments_cubit/cubit/comments_cubit.dart';
import 'package:face_book_clone/features/home/ui/layout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentScreen extends StatefulWidget {
  final String postId;
  final String currentUid;
  const CommentScreen({
    super.key,
    required this.postId,
    required this.currentUid,
  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentCon = TextEditingController();
  late CommentCubit commentCubit;

  @override
  void initState() {
    super.initState();
    final repo = CommentRepositoryImpl(FirebaseFirestore.instance);
    commentCubit = CommentCubit(repo);
  }

  @override
  void dispose() {
    commentCon.dispose();
    commentCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: commentCubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Comments"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.homeScreen, // هنا String اسم المسار
                (route) => false,
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: commentCubit.commentsStream(widget.postId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(child: CircularProgressIndicator());
                    final comments = snapshot.data!;
                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return Padding(
                          padding: EdgeInsets.all(12),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: kWhiteColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: AssetImage(
                                        'assets/images/man.png',
                                      ), // ممكن تجيبها من uid
                                    ),
                                    SizedBox(width: 10),
                                    Text(comment['createdAt'] ?? 'Unknown'),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(comment['content'] ?? ''),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColor),
                        color: kWhiteColor,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: TextField(
                        controller: commentCon,
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          hintText: "Type here ...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
                      backgroundColor: kSeconderyColor,
                      foregroundColor: kWhiteColor,
                    ),
                    onPressed: () {
                      if (commentCon.text.isNotEmpty) {
                        commentCubit.addComment(
                          widget.postId,
                          widget.currentUid,
                          commentCon.text,
                        );
                        commentCon.clear();
                      }
                    },
                    child: Icon(Icons.arrow_circle_right_outlined),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
