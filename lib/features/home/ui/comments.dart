import 'package:face_book_clone/core/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comments")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(12),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                  'assets/images/man.png',
                                ),
                              ),
                              Gap(10),
                              Text('displayName'),
                            ],
                          ),
                          Gap(10),
                          Row(children: [Expanded(child: Text('commentText'))]),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Gap(10),
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
                Gap(10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    shape: CircleBorder(),
                    backgroundColor: kSeconderyColor,
                    foregroundColor: kWhiteColor,
                  ),
                  onPressed: () {},
                  child: Icon(Icons.arrow_circle_right_outlined),
                ),
              ],
            ),
            Gap(10),
          ],
        ),
      ),
    );
  }
}
